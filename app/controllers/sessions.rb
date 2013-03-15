YellowJersey.controllers :sessions do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  get :new do
    render 'sessions/new'
  end

  
  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      redirect url("/home")
    else
      params[:email], params[:password] = h(params[:email]), h(params[:password])
      flash[:warning] = "Login or password wrong."
      redirect url(:sessions, :new)
    end
  end

end
