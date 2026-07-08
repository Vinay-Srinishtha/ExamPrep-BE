class App::Services::AdminDashboard < App::Services::Base
  def student_progress
    return_errors!('Only admins can view arbitrary student progress', 403) unless App.cu.user_obj.admin_access?

    student_id = rp[:student_id].to_i
    statuses = StudentLearningStatus.where(student_user_id: student_id).all.map(&:to_pos)
    return_success(statuses)
  end
end
