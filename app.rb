require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'barbershop.db' }

class Client < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :datestamp, presence: true
end

class Barber < ActiveRecord::Base
  validates :name, presence: true
end


before do
	@barbers = Barber.all
end

get '/' do
  @active = 'main'
	erb :index
end

# =============================================
# авторизация
# =============================================

get '/login' do
	@active = 'login'
  erb :login
end

post '/login' do
	@active = 'login'

  @login    = params[:login]
  @password = params[:password]

  if @login == 'admin' && @password == 'secret'
    erb :admin
  else
    @dinaed = 'Access is denied'
    erb :login
  end
end

get '/admin' do
	@active = 'login'
  erb :admin
end

# =============================================
# зона записи к парикмахеру
# =============================================

get '/visit' do
  @active = 'visit'
  @c = Client.new
	erb :visit
end

post '/visit' do
  @active = 'visit'
	@c = Client.new params[:client] 

  if @c.save 
    @message = "Thank you!"
		erb :visit
	else
    #@error = @c.errors.full_messages#.first     - деактивировано
		erb :visit
	end
end

# =============================================
# показ данных(наверно будет для админских зон)
# =============================================

get '/showusers' do
	@active = 'showusers'
	@clients = Client.order("created_at DESC")
	erb :showusers
end