class App::Services::ParentLinks < App::Services::Base
  def model; ParentStudentLink; end

  def list
    ds = model.order(Sequel.desc(:created_at))
    ds = ds.where(link_status: qs[:status]) if qs[:status].present?
    return_success(ds.all.map(&:to_pos))
  end

  def approve
    link = item
    link.link_status = 'APPROVED'
    link.approved_by = App.cu.user_obj.id
    link.approved_at = Time.now
    save(link)
  end
end
