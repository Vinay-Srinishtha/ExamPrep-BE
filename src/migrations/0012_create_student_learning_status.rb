Sequel.migration do
  change do
    create_table(:student_learning_status) do
      primary_key :id, type: :Bignum
      foreign_key :student_user_id, :users, type: :Bignum, null: false, on_delete: :cascade
      foreign_key :learning_item_id, :learning_items, type: :Bignum, null: false, on_delete: :cascade
      column :learning_status, :learning_status_enum, default: 'NOT_STARTED'
      BigDecimal :completion_percentage, size: [5, 2], default: 0.00
      column :confidence_score, :smallint
      Integer :revision_count, default: 0
      Date :revision_due_date
      BigDecimal :hours_spent, size: [6, 2], default: 0.00
      String :notes, text: true
      DateTime :last_updated, default: Sequel::CURRENT_TIMESTAMP
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP

      index [:student_user_id, :learning_item_id], unique: true, name: :uq_student_learning_item
      index :student_user_id, name: :idx_student_status_student
      index :learning_item_id, name: :idx_student_status_item

      constraint(:chk_student_learning_completion) { (completion_percentage >= 0) & (completion_percentage <= 100) }
      # NULL confidence_score satisfies a CHECK constraint automatically (three-valued SQL logic),
      # so this only actually constrains non-null values to the 1..5 range.
      constraint(:chk_student_learning_confidence) { (confidence_score >= 1) & (confidence_score <= 5) }
    end
  end
end
