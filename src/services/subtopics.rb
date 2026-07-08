class App::Services::Subtopics < App::Services::Base
  def model; Subtopic; end

  def list
    ds = model.order(:display_order)
    ds = ds.where(section_id: qs[:section_id]) if qs[:section_id].present?
    return_success(ds.all.map(&:to_pos))
  end

  def self.fields
    { save: [:section_id, :subtopic_name, :display_order, :status] }
  end
end
