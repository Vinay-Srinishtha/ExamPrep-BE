class App::Models::Role < Sequel::Model(:roles)
  STUDENT = 'STUDENT'
  PARENT = 'PARENT'
  ADMIN = 'ADMIN'
  SUPER_ADMIN = 'SUPER_ADMIN'

  one_to_many :users, key: :role_id

  def validate
    super
    validates_presence [:role_name]
    validates_unique :role_name
  end

  def to_pos
    as_json(only: [:id, :role_name, :description])
  end
end
