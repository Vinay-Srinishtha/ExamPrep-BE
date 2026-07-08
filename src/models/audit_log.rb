class App::Models::AuditLog < Sequel::Model(:audit_logs)
  many_to_one :user, class: :'App::Models::User', key: :user_id

  def validate
    super
    validates_presence [:action]
  end

  def to_pos
    as_json(only: [
      :id, :user_id, :action, :entity_name, :entity_id, :old_value, :new_value,
      :ip_address, :user_agent, :created_at
    ])
  end
end
