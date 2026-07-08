class App::Services::Sections < App::Services::Base
  def model; Section; end

  def list
    ds = model.order(:display_order)
    ds = ds.where(chapter_id: qs[:chapter_id]) if qs[:chapter_id].present?
    return_success(ds.all.map(&:to_pos))
  end

  def self.fields
    { save: [:chapter_id, :section_name, :display_order, :status] }
  end
end
