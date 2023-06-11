require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'barbershop.db' }

class Client < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :datestamp, presence: true
  validates :color, presence: true
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

get '/visit' do
  @active = 'visit'
  @c = Client.new
	erb :visit
end

post '/visit' do
  @active = 'visit'
	@c = Client.new params[:client] 

  if @c.save 
		erb "<p>Thank you!</p>"
	else
    @error = @c.errors.full_messages.first
		erb :visit
	end
end