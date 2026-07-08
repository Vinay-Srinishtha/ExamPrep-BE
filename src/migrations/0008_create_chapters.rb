Sequel.migration do
  change do
    create_table(:chapters) do
      primary_key :id, type: :Bignum
      foreign_key :subject_id, :subjects, type: :Bignum, null: false, on_delete: :cascade
      String :chapter_name, null: false, size: 180
      Integer :display_order, default: 0
      BigDecimal :importance_weight, size: [6, 2], default: 1.00
      column :difficulty_level, :difficulty_level_enum, default: 'MEDIUM'
      BigDecimal :estimated_hours, size: [6, 2], default: 0.00
      column :status, :chapter_status_enum, default: 'ACTIVE'
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

      index [:subject_id, :display_order], name: :idx_chapters_subject_order
      index [:subject_id, :chapter_name], unique: true, name: :uq_chapters_subject_chapter
    end
  end
end
