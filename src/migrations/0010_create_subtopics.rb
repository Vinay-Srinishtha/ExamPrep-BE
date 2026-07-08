Sequel.migration do
  change do
    create_table(:subtopics) do
      primary_key :id, type: :Bignum
      foreign_key :section_id, :sections, type: :Bignum, null: false, on_delete: :cascade
      String :subtopic_name, null: false, size: 180
      Integer :display_order, default: 0
      column :status, :subtopic_status_enum, default: 'ACTIVE'
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

      index [:section_id, :display_order], name: :idx_subtopics_section_order
      index [:section_id, :subtopic_name], unique: true, name: :uq_subtopics_section_subtopic
    end
  end
end
