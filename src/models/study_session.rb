class App::Models::StudySession < Sequel::Model(:study_sessions)
  many_to_one :student, class: :'App::Models::User', key: :student_user_id
  many_to_one :learning_item, class: :'App::Models::LearningItem', key: :learning_item_id

  def validate
    super
    validates_presence [:student_user_id, :learning_item_id, :session_date, :hours_spent]
  end

  def to_pos
    as_json(only: [
      :id, :student_user_id, :learning_item_id, :session_date, :hours_spent, :session_type, :notes
    ])
  end
end
