
class App::Routes < Roda
  include App::Router::AllPlugins
  plugin :not_found do
    { status: 'error', data: 'Not Found' }
  end

  def do_crud(klass, r, only='CRUDL', opts = {})
    r.post { klass[r, opts].create } if only.include?('C')
    r.get(Integer) {|id| klass[r, opts.merge(id: id)].get} if only.include?('R')
    r.get { klass[r, opts].list } if only.include?('L')
    r.put(Integer) {|id| klass[r, opts.merge(id: id)].update } if only.include?('U')
    r.delete(Integer) {|id| klass[r, opts.merge(id: id)].delete } if only.include?('D')
  end

  route do |r|
    r.public

    r.root do
      File.read(File.join(App.root, 'public', 'index.html'))
    end

    r.on 'admin' do
      r.get do
        File.read(File.join(App.root, 'public', 'index.html'))
      end
    end

    r.on 'api' do
      r.response['Content-Type'] = 'application/json'
      
      # Public endpoints (no auth required)
      r.post('login') { Session[r].login }
      r.post('forgot-password') { Users[r].forgot_password }
      r.post('validate-password-token') { Users[r].validate_password_token }
      r.post('reset-password') { Users[r].reset_password }
      
      r.get 'version' do
        { status: 'success', version: 1 }
      end

      # Authentication required for all routes below
      auth_required!

      # User profile routes
      r.on 'me' do
        r.get('info') { Users[r].info }
        r.put('update-password') { Users[r].update_password }
      end

      # Student-facing syllabus + progress routes (any authenticated user may read the tree)
      r.on 'syllabus' do
        r.get('tree') { Syllabus[r].tree }
      end

      r.on 'progress' do
        r.get { Progress[r].list }
        r.put(Integer) { |learning_item_id| Progress[r, learning_item_id: learning_item_id].upsert }
      end

      r.on 'study-sessions' do
        r.post { Progress[r].log_session }
      end

      r.on 'readiness' do
        r.get { Readiness[r].mine }
      end

      # Parent dashboard routes
      r.on 'parent' do
        r.get('students') { ParentDashboard[r].students }
        r.get('students', Integer, 'progress') { |student_id| ParentDashboard[r, student_id: student_id].progress }
      end

      # Admin-only routes
      admin_required!

      # Wrap all admin routes in error handling
      begin
        r.on 'users' do
          do_crud(Users, r, 'CRUDL')
        end

        r.on 'exams' do
          do_crud(Exams, r, 'CRUDL')
        end

        r.on 'subjects' do
          do_crud(Subjects, r, 'CRUDL')
        end

        r.on 'chapters' do
          do_crud(Chapters, r, 'CRUDL')
        end

        r.on 'sections' do
          do_crud(Sections, r, 'CRUDL')
        end

        r.on 'subtopics' do
          do_crud(Subtopics, r, 'CRUDL')
        end

        r.on 'learning-items' do
          do_crud(LearningItems, r, 'CRUDL')
        end

        r.on 'parent-links' do
          r.get { ParentLinks[r].list }
          r.put(Integer) { |id| ParentLinks[r, id: id].approve }
        end

        # Add other admin routes here
      rescue => e
        App.logger.error("API Error: #{e.message}")
        App.logger.error(e.backtrace)
        { status: 'error', message: "An error occurred: #{e.message}" }
      end
    end

    # Fallback route
    r.get do
      File.read(File.join(App.root, 'public', 'index.html'))
    end
  end

  before do
    @time = Time.now
    App::Helpers::Before.run!(request)
  end

  after do |res|
    rtype = request.request_method
    App.logger.info("→ [#{Time.now - @time} seconds] - [#{rtype}]#{request.path}")
  end

  def auth_required!
    unless App.cu.valid?
      request.halt(401, {'Content-Type' => 'application/json'},{ status: 'Unauthorized!' }.to_json)
    end
  end

  def admin_required!
    unless App.cu.user_obj.admin_access?
      request.halt(403, {'Content-Type' => 'application/json'},{ status: 'Forbidden!' }.to_json)
    end
  end
end

App.require_blob('services/base.rb')
App.require_blob('services/*.rb')

App::Routes.send(:include, App::Services)