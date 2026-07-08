Sequel.migration do
  change do
    create_table(:parent_student_links) do
      primary_key :id, type: :Bignum
      foreign_key :parent_user_id, :users, type: :Bignum, null: false, on_delete: :cascade
      foreign_key :student_user_id, :users, type: :Bignum, null: false, on_delete: :cascade
      String :relationship, size: 50
      column :link_status, :link_status_enum, default: 'PENDING'
      foreign_key :approved_by, :users, type: :Bignum, on_delete: :set_null
      DateTime :approved_at
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP

      index [:parent_user_id, :student_user_id], unique: true, name: :uq_parent_student
      index :student_user_id
      index :approved_by
    end
  end
end
