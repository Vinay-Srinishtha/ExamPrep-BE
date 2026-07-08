class App::Models::Exam < Sequel::Model(:exams)
  one_to_many :subjects
  one_to_many :readiness_scores

  def validate
    super
    validates_presence [:exam_name]
    validates_unique :exam_code if exam_code
  end

  def to_pos
    as_json(only: [:id, :exam_name, :exam_code, :description, :status])
  end
end
