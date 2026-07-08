Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id, type: :Bignum
      foreign_key :role_id, :roles, type: :Bignum, null: false, on_update: :cascade, on_delete: :restrict
      String :full_name, null: false, size: 150
      String :email, size: 150
      String :mobile, size: 20
      String :password_hash, size: 255, null: false

      column :account_status, :account_status_enum, default: 'ACTIVE'

      DateTime :last_login_at

      # Session / device-binding / password-reset support (app-level auth features).
      String :device_uuid
      String :current_session_id, text: true
      String :reset_token
      DateTime :reset_sent_at

      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP

      index :email, unique: true
      index :mobile, unique: true
      index :role_id
      index :reset_token
    end
  end
end
