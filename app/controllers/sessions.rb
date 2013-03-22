YellowJersey.controllers :sessions do
  get :new do
    render 'sessions/new'
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      redirect 'home'
    else
      params[:email], params[:password] = h(params[:email]), h(params[:password])
      flash[:warning] = 'Login or password wrong.'
      redirect 'sessions/new'
    end
  end
end
