Sequel.migration do
  change do
    create_table(:sections) do
      primary_key :id, type: :Bignum
      foreign_key :chapter_id, :chapters, type: :Bignum, null: false, on_delete: :cascade
      String :section_name, null: false, size: 180
      Integer :display_order, default: 0
      column :status, :section_status_enum, default: 'ACTIVE'
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

      index [:chapter_id, :display_order], name: :idx_sections_chapter_order
      index [:chapter_id, :section_name], unique: true, name: :uq_sections_chapter_section
    end
  end
end
