YellowJersey.controllers :home do

  get :index do
    render 'home/index'
  end

  get :guest, :map => "/" do
    render 'home/guest'
  end

end