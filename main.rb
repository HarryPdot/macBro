require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'bcrypt'
require 'httparty'

get '/' do
  conn = PG.connect(dbname: 'macbro')
  sql = 'select * from macro'
  result = conn.exec(sql)
  conn.close


  erb :index, locals: {
    dishes: result
  }
end

get '/macbro/:id'do
  conn = PG.connect(dbname: 'macbro')
  sql = "select * from macro where id=#{params['id']}"
  result = conn.exec(sql)[0]
  conn.close


  erb :show, locals: {
    name: result["name"],
    calorie: result["calorie"],
    protein: result["protein"],
    carbs: result["carbs"],
    fat: result["fat"]
  }
end

get '/macbro' do
  calorie = params["calorie"]
  protein = params["protein"]
  carbs = params["carbs"]
  fat = params["fat"]
  result = HTTParty.get("https://api.spoonacular.com/recipes/complexSearch?maxCalories=#{calorie}&maxProtein=#{protein}&maxCarbs=#{carbs}&maxFat=#{fat}&number=10&apiKey=6538b6a6b40e4e4394641e7dec3cae15")




  erb :list, locals: {
    result: result,
  }
end



