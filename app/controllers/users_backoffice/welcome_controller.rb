class UsersBackoffice::WelcomeController < UsersBackofficeController
  before_action :authenticate_user!
  layout 'users_backoffice'

  def index
  end
end
