class App::Models::Chapter < Sequel::Model(:chapters)
  many_to_one :subject
  one_to_many :sections, order: :display_order

  def validate
    super
    validates_presence [:subject_id, :chapter_name]
    validates_unique [:subject_id, :chapter_name]
  end

  def to_pos
    as_json(only: [
      :id, :subject_id, :chapter_name, :display_order, :importance_weight,
      :difficulty_level, :estimated_hours, :status
    ])
  end
end
