Sequel.migration do
  change do
    create_table(:study_sessions) do
      primary_key :id, type: :Bignum
      foreign_key :student_user_id, :users, type: :Bignum, null: false, on_delete: :cascade
      foreign_key :learning_item_id, :learning_items, type: :Bignum, null: false, on_delete: :cascade
      Date :session_date, null: false
      BigDecimal :hours_spent, size: [5, 2], null: false
      column :session_type, :session_type_enum, default: 'LEARNING'
      String :notes, text: true
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP

      index :student_user_id, name: :idx_study_sessions_student
    end
  end
end
