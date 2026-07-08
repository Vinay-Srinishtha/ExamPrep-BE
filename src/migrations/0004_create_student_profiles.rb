Sequel.migration do
  change do
    create_table(:student_profiles) do
      primary_key :id, type: :Bignum
      foreign_key :user_id, :users, type: :Bignum, null: false, unique: true, on_delete: :cascade
      Integer :target_exam_year
      String :coaching_batch, size: 100
      String :school_name, size: 150
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

      constraint(:chk_student_profiles_target_year) { (target_exam_year >= 1901) & (target_exam_year <= 2155) }
    end
  end
end
