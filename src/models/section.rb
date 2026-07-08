class App::Models::Section < Sequel::Model(:sections)
  many_to_one :chapter
  one_to_many :subtopics, order: :display_order

  def validate
    super
    validates_presence [:chapter_id, :section_name]
    validates_unique [:chapter_id, :section_name]
  end

  def to_pos
    as_json(only: [:id, :chapter_id, :section_name, :display_order, :status])
  end
end
