Sequel.migration do
  change do
    create_table(:readiness_scores) do
      primary_key :id, type: :Bignum
      foreign_key :student_user_id, :users, type: :Bignum, null: false, on_delete: :cascade
      foreign_key :exam_id, :exams, type: :Bignum, null: false, on_delete: :cascade
      BigDecimal :completion_score, size: [5, 2], default: 0.00
      BigDecimal :revision_score, size: [5, 2], default: 0.00
      BigDecimal :confidence_score, size: [5, 2], default: 0.00
      BigDecimal :practice_score, size: [5, 2], default: 0.00
      BigDecimal :overall_readiness, size: [5, 2], default: 0.00
      column :readiness_level, :readiness_level_enum, default: 'LOW'
      DateTime :calculated_at, default: Sequel::CURRENT_TIMESTAMP

      index [:student_user_id, :exam_id], unique: true, name: :uq_student_exam_readiness
      index :student_user_id, name: :idx_readiness_student
    end
  end
end
