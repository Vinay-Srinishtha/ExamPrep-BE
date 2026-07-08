Sequel.migration do
  change do
    create_table(:revision_logs) do
      primary_key :id, type: :Bignum
      foreign_key :student_user_id, :users, type: :Bignum, null: false, on_delete: :cascade
      foreign_key :learning_item_id, :learning_items, type: :Bignum, null: false, on_delete: :cascade
      Integer :revision_number, null: false
      Date :revision_date, null: false
      column :confidence_score, :smallint
      String :notes, text: true
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP

      index :student_user_id, name: :idx_revision_student
      index [:student_user_id, :learning_item_id], name: :idx_revision_logs_student_item
    end
  end
end
