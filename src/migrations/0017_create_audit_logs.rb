Sequel.migration do
  change do
    create_table(:audit_logs) do
      primary_key :id, type: :Bignum
      foreign_key :user_id, :users, type: :Bignum, on_delete: :set_null
      String :action, null: false, size: 150
      String :entity_name, size: 100
      Integer :entity_id
      column :old_value, :jsonb
      column :new_value, :jsonb
      String :ip_address, size: 50
      String :user_agent, size: 255
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP

      index :user_id, name: :idx_audit_user
    end
  end
end
