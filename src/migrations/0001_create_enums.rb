Sequel.migration do
  up do
    create_enum(:account_status_enum, %w[ACTIVE INACTIVE SUSPENDED])
    create_enum(:link_status_enum, %w[PENDING APPROVED REJECTED REMOVED])
    create_enum(:exam_status_enum, %w[DRAFT ACTIVE ARCHIVED DEPRECATED])
    create_enum(:subject_status_enum, %w[ACTIVE INACTIVE])
    create_enum(:chapter_status_enum, %w[ACTIVE INACTIVE])
    create_enum(:section_status_enum, %w[ACTIVE INACTIVE])
    create_enum(:subtopic_status_enum, %w[ACTIVE INACTIVE])
    create_enum(:learning_item_status_enum, %w[ACTIVE INACTIVE])
    create_enum(:difficulty_level_enum, %w[EASY MEDIUM HARD])
    create_enum(:learning_status_enum, %w[NOT_STARTED LEARNING PRACTICING COMPLETED REVISED])
    create_enum(:session_type_enum, %w[LEARNING PRACTICE REVISION])
    create_enum(:readiness_level_enum, %w[LOW NEEDS_ATTENTION MODERATE GOOD HIGH])
  end

  down do
    drop_enum(:readiness_level_enum)
    drop_enum(:session_type_enum)
    drop_enum(:learning_status_enum)
    drop_enum(:difficulty_level_enum)
    drop_enum(:learning_item_status_enum)
    drop_enum(:subtopic_status_enum)
    drop_enum(:section_status_enum)
    drop_enum(:chapter_status_enum)
    drop_enum(:subject_status_enum)
    drop_enum(:exam_status_enum)
    drop_enum(:link_status_enum)
    drop_enum(:account_status_enum)
  end
end
