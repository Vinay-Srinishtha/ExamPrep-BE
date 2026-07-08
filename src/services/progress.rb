class App::Services::Progress < App::Services::Base
  UPDATABLE_FIELDS = %w[learning_status completion_percentage confidence_score hours_spent revision_due_date notes]

  def list
    return_errors!('Only students track progress', 403) unless App.cu.user_obj.student?

    ds = StudentLearningStatus.where(student_user_id: App.cu.user_obj.id)
    return_success(ds.all.map(&:to_pos))
  end

  def upsert
    return_errors!('Only students can update their own progress', 403) unless App.cu.user_obj.student?

    learning_item_id = rp[:learning_item_id]
    record = StudentLearningStatus.find_or_create(student_user_id: App.cu.user_obj.id, learning_item_id: learning_item_id)

    data = params.slice(*UPDATABLE_FIELDS)
    becoming_revised = data['learning_status'] == 'REVISED' && record.learning_status != 'REVISED'

    record.set_fields(data, data.keys)
    record.last_updated = Time.now
    record.revision_count = (record.revision_count || 0) + 1 if becoming_revised

    save(record) do |r|
      if becoming_revised
        RevisionLog.create(
          student_user_id: r.student_user_id,
          learning_item_id: r.learning_item_id,
          revision_number: r.revision_count,
          revision_date: Date.today,
          confidence_score: r.confidence_score,
          notes: r.notes
        )
      end
      return_success(r.to_pos)
    end
  end

  def log_session
    return_errors!('Only students can log study sessions', 403) unless App.cu.user_obj.student?
    check_presence!(:learning_item_id, :session_date, :hours_spent)

    session = StudySession.new(
      student_user_id: App.cu.user_obj.id,
      learning_item_id: params[:learning_item_id],
      session_date: params[:session_date],
      hours_spent: params[:hours_spent],
      session_type: params[:session_type] || 'LEARNING',
      notes: params[:notes]
    )
    save(session)
  end
end
