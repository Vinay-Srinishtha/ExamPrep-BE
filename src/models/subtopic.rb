class App::Models::Subtopic < Sequel::Model(:subtopics)
  many_to_one :section
  one_to_many :learning_items, order: :display_order

  def validate
    super
    validates_presence [:section_id, :subtopic_name]
    validates_unique [:section_id, :subtopic_name]
  end

  def to_pos
    as_json(only: [:id, :section_id, :subtopic_name, :display_order, :status])
  end
end
