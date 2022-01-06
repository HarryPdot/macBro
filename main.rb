require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'bcrypt'



get '/' do
  erb :index
end





