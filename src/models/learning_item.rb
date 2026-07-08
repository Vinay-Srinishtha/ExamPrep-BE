class App::Models::LearningItem < Sequel::Model(:learning_items)
  many_to_one :subtopic
  one_to_many :student_learning_statuses, key: :learning_item_id
  one_to_many :study_sessions, key: :learning_item_id
  one_to_many :revision_logs, key: :learning_item_id
  one_to_many :dependencies, class: :'App::Models::TopicDependency', key: :learning_item_id

  def validate
    super
    validates_presence [:subtopic_id, :item_name]
    validates_unique [:subtopic_id, :item_name]
  end

  def to_pos
    as_json(only: [
      :id, :subtopic_id, :item_name, :item_description, :display_order,
      :importance_weight, :mains_weight, :advanced_weight, :difficulty_level,
      :estimated_hours, :status
    ])
  end
end
