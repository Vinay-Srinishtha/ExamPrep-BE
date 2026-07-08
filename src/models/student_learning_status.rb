class App::Models::StudentLearningStatus < Sequel::Model(:student_learning_status)
  many_to_one :student, class: :'App::Models::User', key: :student_user_id
  many_to_one :learning_item, class: :'App::Models::LearningItem', key: :learning_item_id

  def validate
    super
    validates_presence [:student_user_id, :learning_item_id]
    validates_unique [:student_user_id, :learning_item_id]
  end

  def to_pos
    as_json(only: [
      :id, :student_user_id, :learning_item_id, :learning_status, :completion_percentage,
      :confidence_score, :revision_count, :revision_due_date, :hours_spent, :notes, :last_updated
    ])
  end
end
