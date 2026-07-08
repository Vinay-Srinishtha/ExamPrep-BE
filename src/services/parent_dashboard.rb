class App::Services::ParentDashboard < App::Services::Base
  def students
    return_errors!('Only parents can view linked students', 403) unless App.cu.user_obj.parent?

    ids = App.cu.user_obj.linked_student_ids
    return_success(User.where(id: ids).all.map { |u| u.to_pos.merge('student_profile' => u.student_profile&.to_pos) })
  end

  def progress
    return_errors!('Only parents can view student progress', 403) unless App.cu.user_obj.parent?

    student_id = rp[:student_id].to_i
    unless App.cu.user_obj.linked_student_ids.include?(student_id)
      return_errors!('Not authorized to view this student', 403)
    end

    statuses = StudentLearningStatus.where(student_user_id: student_id).all.map(&:to_pos)
    return_success(statuses)
  end
end
