YellowJersey.controllers :sessions do

  get :new do
    render url(:sessions, :new)
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      redirect url(:home, :index)
    else
      params[:email], params[:password] = h(params[:email]), h(params[:password])
      flash[:error] = "Wrong email or password."
      redirect url(:sessions, :new)
    end
  end

end
