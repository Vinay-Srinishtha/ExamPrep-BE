class App::Models::TopicDependency < Sequel::Model(:topic_dependencies)
  many_to_one :learning_item, class: :'App::Models::LearningItem', key: :learning_item_id
  many_to_one :prerequisite, class: :'App::Models::LearningItem', key: :depends_on_learning_item_id

  def validate
    super
    validates_presence [:learning_item_id, :depends_on_learning_item_id]
    validates_unique [:learning_item_id, :depends_on_learning_item_id]

    if learning_item_id && learning_item_id == depends_on_learning_item_id
      errors.add(:depends_on_learning_item_id, 'cannot depend on itself')
    end
  end

  def to_pos
    as_json(only: [:id, :learning_item_id, :depends_on_learning_item_id, :dependency_strength])
  end
end
