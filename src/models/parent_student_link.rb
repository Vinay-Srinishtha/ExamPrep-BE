class App::Models::ParentStudentLink < Sequel::Model(:parent_student_links)
  many_to_one :parent, class: :'App::Models::User', key: :parent_user_id
  many_to_one :student, class: :'App::Models::User', key: :student_user_id
  many_to_one :approver, class: :'App::Models::User', key: :approved_by

  def validate
    super
    validates_presence [:parent_user_id, :student_user_id]
    validates_unique [:parent_user_id, :student_user_id]
  end

  def to_pos
    as_json(only: [:id, :parent_user_id, :student_user_id, :relationship, :link_status, :approved_by, :approved_at])
  end
end
