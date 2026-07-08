class App::Services::Chapters < App::Services::Base
  def model; Chapter; end

  def list
    ds = model.order(:display_order)
    ds = ds.where(subject_id: qs[:subject_id]) if qs[:subject_id].present?
    return_success(ds.all.map(&:to_pos))
  end

  def self.fields
    {
      save: [:subject_id, :chapter_name, :display_order, :importance_weight, :difficulty_level, :estimated_hours, :status]
    }
  end
end
