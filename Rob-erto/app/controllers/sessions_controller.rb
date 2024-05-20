class SessionsController < Devise::SessionsController
  def create
    super do
      flash[:notice] = 'Logged in successfully' if is_navigational_format?
    end
  end
end
