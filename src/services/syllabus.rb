class App::Services::Syllabus < App::Services::Base
  # Full exam -> subject -> chapter -> section -> subtopic -> learning_item tree.
  # Read-only, available to any authenticated user (student/parent/admin).
  def tree
    exams_ds = Exam.where(status: 'ACTIVE')
    exams_ds = exams_ds.where(id: qs[:exam_id]) if qs[:exam_id].present?

    data = exams_ds.order(:id).all.map do |exam|
      exam.to_pos.merge(
        'subjects' => exam.subjects_dataset.where(status: 'ACTIVE').order(:display_order).all.map { |subject| subject_node(subject) }
      )
    end

    return_success(data)
  end

  private

  def subject_node(subject)
    subject.to_pos.merge(
      'chapters' => subject.chapters_dataset.where(status: 'ACTIVE').order(:display_order).all.map { |chapter| chapter_node(chapter) }
    )
  end

  def chapter_node(chapter)
    chapter.to_pos.merge(
      'sections' => chapter.sections_dataset.where(status: 'ACTIVE').order(:display_order).all.map { |section| section_node(section) }
    )
  end

  def section_node(section)
    section.to_pos.merge(
      'subtopics' => section.subtopics_dataset.where(status: 'ACTIVE').order(:display_order).all.map { |subtopic| subtopic_node(subtopic) }
    )
  end

  def subtopic_node(subtopic)
    subtopic.to_pos.merge(
      'learning_items' => subtopic.learning_items_dataset.where(status: 'ACTIVE').order(:display_order).all.map(&:to_pos)
    )
  end
end
