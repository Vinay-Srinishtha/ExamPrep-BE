Sequel.migration do
  change do
    create_table(:topic_dependencies) do
      primary_key :id, type: :Bignum
      foreign_key :learning_item_id, :learning_items, type: :Bignum, null: false, on_delete: :cascade
      foreign_key :depends_on_learning_item_id, :learning_items, type: :Bignum, null: false, on_delete: :cascade
      BigDecimal :dependency_strength, size: [3, 2], default: 1.00
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP

      index [:learning_item_id, :depends_on_learning_item_id], unique: true, name: :uq_topic_dependency

      constraint(:chk_topic_dependencies_no_self, Sequel.lit('learning_item_id <> depends_on_learning_item_id'))
    end
  end
end
