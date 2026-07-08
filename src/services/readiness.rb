class App::Services::Readiness < App::Services::Base
  def mine
    return_errors!('Only students have readiness scores', 403) unless App.cu.user_obj.student?

    exam_id = qs[:exam_id]
    ds = ReadinessScore.where(student_user_id: App.cu.user_obj.id)
    ds = ds.where(exam_id: exam_id) if exam_id.present?

    scores = ds.all
    scores = [compute!(exam_id)].compact if scores.empty? && exam_id.present?

    return_success(scores.map(&:to_pos))
  end

  # Recomputes and persists the readiness_scores row for the current student/exam pair,
  # averaging four tracked metrics (completion, revision, confidence, practice).
  def compute!(exam_id)
    student_id = App.cu.user_obj.id

    item_ids = LearningItem
      .join(:subtopics, Sequel[:subtopics][:id] => Sequel[:learning_items][:subtopic_id])
      .join(:sections, Sequel[:sections][:id] => Sequel[:subtopics][:section_id])
      .join(:chapters, Sequel[:chapters][:id] => Sequel[:sections][:chapter_id])
      .join(:subjects, Sequel[:subjects][:id] => Sequel[:chapters][:subject_id])
      .where(Sequel[:subjects][:exam_id] => exam_id)
      .select_map(Sequel[:learning_items][:id])

    return nil if item_ids.empty?

    statuses = StudentLearningStatus.where(student_user_id: student_id, learning_item_id: item_ids).all
    total = item_ids.size.to_f

    completion_score = (statuses.sum { |s| s.completion_percentage.to_f } / total).round(2)
    revision_score = (statuses.count { |s| s.learning_status == 'REVISED' } / total * 100).round(2)
    confidence_vals = statuses.map(&:confidence_score).compact
    confidence_score = confidence_vals.empty? ? 0 : (confidence_vals.sum.to_f / confidence_vals.size / 5 * 100).round(2)
    practice_score = (statuses.count { |s| %w[PRACTICING COMPLETED REVISED].include?(s.learning_status) } / total * 100).round(2)
    overall = ((completion_score + revision_score + confidence_score + practice_score) / 4).round(2)

    level = case overall
            when 0...20 then 'LOW'
            when 20...40 then 'NEEDS_ATTENTION'
            when 40...65 then 'MODERATE'
            when 65...85 then 'GOOD'
            else 'HIGH'
            end

    record = ReadinessScore.find_or_create(student_user_id: student_id, exam_id: exam_id)
    record.update(
      completion_score: completion_score,
      revision_score: revision_score,
      confidence_score: confidence_score,
      practice_score: practice_score,
      overall_readiness: overall,
      readiness_level: level,
      calculated_at: Time.now
    )
    record
  end
end
