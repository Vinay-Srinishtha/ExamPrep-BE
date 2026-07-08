class App::Models::ReadinessScore < Sequel::Model(:readiness_scores)
  many_to_one :student, class: :'App::Models::User', key: :student_user_id
  many_to_one :exam, class: :'App::Models::Exam', key: :exam_id

  def validate
    super
    validates_presence [:student_user_id, :exam_id]
    validates_unique [:student_user_id, :exam_id]
  end

  def to_pos
    as_json(only: [
      :id, :student_user_id, :exam_id, :completion_score, :revision_score, :confidence_score,
      :practice_score, :overall_readiness, :readiness_level, :calculated_at
    ])
  end
end
