class App::Services::LearningItems < App::Services::Base
  def model; LearningItem; end

  def list
    ds = model.order(:display_order)
    ds = ds.where(subtopic_id: qs[:subtopic_id]) if qs[:subtopic_id].present?
    return_success(ds.all.map(&:to_pos))
  end

  def self.fields
    {
      save: [
        :subtopic_id, :item_name, :item_description, :display_order, :importance_weight,
        :mains_weight, :advanced_weight, :difficulty_level, :estimated_hours, :status
      ]
    }
  end
end
