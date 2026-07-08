class App::Models::Subject < Sequel::Model(:subjects)
  many_to_one :exam
  one_to_many :chapters, order: :display_order

  def validate
    super
    validates_presence [:exam_id, :subject_name]
    validates_unique [:exam_id, :subject_name]
  end

  def to_pos
    as_json(only: [:id, :exam_id, :subject_name, :display_order, :status])
  end
end
