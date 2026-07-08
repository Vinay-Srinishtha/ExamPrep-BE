class App::Models::User < Sequel::Model(:users)
  include BCrypt

  many_to_one :role
  one_to_one :student_profile, key: :user_id

  one_to_many :parent_links, class: :'App::Models::ParentStudentLink', key: :parent_user_id
  one_to_many :student_links, class: :'App::Models::ParentStudentLink', key: :student_user_id

  def role_name
    role&.role_name
  end

  def student?
    role_name == App::Models::Role::STUDENT
  end

  def parent?
    role_name == App::Models::Role::PARENT
  end

  def admin?
    role_name == App::Models::Role::ADMIN
  end

  def super_admin?
    role_name == App::Models::Role::SUPER_ADMIN
  end

  # Admin dashboards and content-management routes are open to admins and super admins alike.
  def admin_access?
    admin? || super_admin?
  end

  # For a parent user: the students they're approved to view.
  def linked_student_ids
    parent_links_dataset.where(link_status: 'APPROVED').select_map(:student_user_id)
  end

  def validate
    super
    validates_presence [:full_name, :password_hash, :role_id]
    validates_unique(:email) if email
    validates_unique(:mobile) if mobile
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def generate_reset_token!
    self.reset_token = SecureRandom.urlsafe_base64
    self.reset_sent_at = Time.now
    save
  end

  def send_password_reset_email(base_url)
    generate_reset_token!

    user_email = self.email
    user_name = self.full_name
    reset_url = "#{base_url}/reset_password?token=#{CGI.escape(reset_token)}"

    mail = Mail.new do
      from    ENV.fetch('EMAIL_FROM', 'noreply@example.com')
      to      user_email
      subject 'Reset your password'
      html_part do
        content_type 'text/html; charset=UTF-8'
        body <<-HTML
          <html>
          <body>
            <h1>Reset your password</h1>
            <p>Hello #{user_name},</p>
            <p>We received a request to reset your password. Click the link below to reset your password:</p>
            <p><a href="#{reset_url}">Reset your password</a></p>
            <p>If you did not request a password reset, please ignore this email.</p>
            <p>Thank you,<br/>Support Team</p>
          </body>
          </html>
        HTML
      end
    end

    mail.deliver!
  end

  def to_pos
    as_json(only: [:id, :full_name, :email, :mobile, :role_id, :account_status, :last_login_at, :created_at, :updated_at])
      .merge('role_name' => role_name)
  end
end
