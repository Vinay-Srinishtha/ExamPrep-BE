Sequel.migration do
  change do
    create_table(:subjects) do
      primary_key :id, type: :Bignum
      foreign_key :exam_id, :exams, type: :Bignum, null: false, on_delete: :cascade
      String :subject_name, null: false, size: 120
      Integer :display_order, default: 0
      column :status, :subject_status_enum, default: 'ACTIVE'
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

      index :exam_id
      index [:exam_id, :subject_name], unique: true, name: :uq_subjects_exam_subject
    end
  end
end
