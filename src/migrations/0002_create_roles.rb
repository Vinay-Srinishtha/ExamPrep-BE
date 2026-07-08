Sequel.migration do
  change do
    create_table(:roles) do
      primary_key :id, type: :Bignum
      String :role_name, null: false, size: 50
      String :description, size: 255
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP

      index :role_name, unique: true
    end
  end
end
