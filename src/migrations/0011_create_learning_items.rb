Sequel.migration do
  change do
    create_table(:learning_items) do
      primary_key :id, type: :Bignum
      foreign_key :subtopic_id, :subtopics, type: :Bignum, null: false, on_delete: :cascade
      String :item_name, null: false, size: 220
      String :item_description, text: true
      Integer :display_order, default: 0
      BigDecimal :importance_weight, size: [6, 2], default: 1.00
      BigDecimal :mains_weight, size: [6, 2], default: 1.00
      BigDecimal :advanced_weight, size: [6, 2], default: 1.00
      column :difficulty_level, :difficulty_level_enum, default: 'MEDIUM'
      BigDecimal :estimated_hours, size: [6, 2], default: 0.00
      column :status, :learning_item_status_enum, default: 'ACTIVE'
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

      index [:subtopic_id, :display_order], name: :idx_learning_items_subtopic_order
      index [:subtopic_id, :item_name], unique: true, name: :uq_learning_items_subtopic_item
    end
  end
end
