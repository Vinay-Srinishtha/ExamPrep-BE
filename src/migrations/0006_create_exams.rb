Sequel.migration do
  change do
    create_table(:exams) do
      primary_key :id, type: :Bignum
      String :exam_name, null: false, size: 120
      String :exam_code, size: 50, unique: true
      String :description, text: true
      column :status, :exam_status_enum, default: 'ACTIVE'
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
