YellowJersey.controllers :accounts do

  get :new do
    render 'accounts/new'
  end

  post :create do
    @account = Account.new(params[:account])
    @account.role = :athlete
    if @account.save
      flash[:notice] = 'Account was successfully created.'
      redirect url(:home, :index)
    else
      flash[:error] = 'Please fix the problems highlighted below and try again.'
      render 'accounts/new'
    end
  end

end
