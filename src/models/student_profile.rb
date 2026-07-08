class App::Models::StudentProfile < Sequel::Model(:student_profiles)
  many_to_one :user

  def validate
    super
    validates_presence [:user_id]
    validates_unique :user_id
  end

  def to_pos
    as_json(only: [:id, :user_id, :target_exam_year, :coaching_batch, :school_name])
  end
end
