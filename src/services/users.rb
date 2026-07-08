class App::Services::Users < App::Services::Base
  def model; User; end

  RESET_TOKEN_EXPIRATION_TIME = 2 * 60 * 60

  def list
    ds = model.order(Sequel.desc(:created_at))
    if qs[:search].present?
      search_term = "%#{qs[:search]}%"
      ds = ds.where(Sequel.ilike(:full_name, search_term)).or(Sequel.ilike(:email, search_term))
    end
    ds = ds.where(role_id: qs[:role_id]) if qs[:role_id].present?
    count = ds.count
    return_success(ds.offset(offset).limit(limit).all.map(&:to_pos), total_pages: (count / page_size.to_f).ceil)
  end

  def get
    result = item.to_pos
    result.merge!(student_profile: item.student_profile&.to_pos) if item.student?
    return_success(result)
  end

  def create
    obj = model.new(data_for(:save))
    save(obj)
  end

  def info
    user = App.cu.user_obj
    result = user.to_pos
    if user.student?
      result.merge!(student_profile: user.student_profile&.to_pos)
    elsif user.parent?
      result.merge!(linked_student_ids: user.linked_student_ids)
    end
    return_success(result)
  end

  def update_password
    if App.cu.user_obj.password == params[:current_password]
      u = App.cu.user_obj
      u.password = params[:new_password]
      save(u) do |u|
        return_success("successfully updated password!!")
      end
    else
      return_errors!("Invalid password!!")
    end
  end

  def forgot_password
    email = params[:email]
    if email.present?
      user = App::Models::User.where(email: email).first
      if user
        user.send_password_reset_email(ENV.fetch('APP_BASE_URL', 'http://localhost:3000'))
        return_success("Password reset email sent to #{user.email}")
      else
        return_errors!("User not found with email: #{email}", 404)
      end
    else
      return_errors!("User email is required!", 400)
    end
  end

  def validate_password_token
    token = params['token']

    if token.nil? || token.empty?
      return_errors!('Token is missing.', 400)
    else
      user = App::Models::User.where(reset_token: token).first
      if user && token_valid?(user)
        return_success('Token is valid.')
      else
        return_errors!('Invalid or expired token.')
      end
    end
  end

  def token_valid?(user)
    return false if user.reset_sent_at.nil?

    token_age = Time.now - user.reset_sent_at
    token_age < RESET_TOKEN_EXPIRATION_TIME
  end

  def reset_password
    token = params['token']
    new_password = params['password']

    if token.nil? || new_password.nil?
      return_errors!('Token and new password are required.', 400)
    else
      user = App::Models::User.where(reset_token: token).first
      if user && token_valid?(user)
        user.update(
          password: new_password,
          reset_token: nil,
          reset_sent_at: nil
        )
        return_success('Password has been reset.')
      else
        return_errors!('Invalid or expired token.', 400)
      end
    end
  end

  def self.fields
    {
      save: [:full_name, :password, :email, :mobile, :role_id, :account_status]
    }
  end
end
