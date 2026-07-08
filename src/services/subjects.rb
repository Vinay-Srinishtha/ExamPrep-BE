class App::Services::Subjects < App::Services::Base
  def model; Subject; end

  def list
    ds = model.order(:display_order)
    ds = ds.where(exam_id: qs[:exam_id]) if qs[:exam_id].present?
    return_success(ds.all.map(&:to_pos))
  end

  def self.fields
    { save: [:exam_id, :subject_name, :display_order, :status] }
  end
end
