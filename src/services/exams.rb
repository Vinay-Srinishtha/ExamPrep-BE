class App::Services::Exams < App::Services::Base
  def model; Exam; end

  def list
    return_success(model.order(:id).all.map(&:to_pos))
  end

  def self.fields
    { save: [:exam_name, :exam_code, :description, :status] }
  end
end
