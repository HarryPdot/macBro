require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'bcrypt'
require 'httparty'
require_relative 'models/recipe.rb'


enable :sessions

def logged_in?()
  if session[:user_id]
   return true
  else 
   return false
  end
 end

def current_user()

  conn = PG.connect(dbname: 'macbro')
  sql = "select * from users where id = #{session[:user_id]};"
  result = conn.exec(sql)
  user = result[0]
  conn.close
  return OpenStruct.new(user)
end

get '/' do
  result = all_recipes()
  random_index = []
  result_length = result.count
  j=0
  if result_length > 5
    while j < 6
      random_index.push(rand(result.count)+1)
      j += 1
    end
  else  
    result_length.times do
    random_index.push(rand(result.count)+1)
    end
  end

  erb :index, locals: {
    dishes: result,
    index: random_index
  }
end

get '/macbro/about' do
  

  erb :about
end

get '/macbro/contact' do
  

  erb :contact
end

get '/macbro/new' do
  redirect '/login' unless logged_in?

  erb :new
end

get '/macbro/list' do
  redirect '/login' unless logged_in?
  conn = PG.connect(dbname: 'macbro')
  sql = "select * from macro where user_id = #{current_user().id}"
  result = conn.exec(sql)
  conn.close

  erb :user_list, locals: {
    result: result,
  }
end

post '/macbro' do
  create_recipe(params['name'], params['calorie'], params['protein'], params['carbs'], params['fat'], params['dish_img'], params['recipe'], current_user().id)
  redirect '/'
end

get '/macbro/:id'do
  apiResult = HTTParty.get("https://api.spoonacular.com/recipes/#{params["id"]}/information?includeNutrition=true&apiKey=5897cea122e748178c8ff383bb8fd236")
  result = select_recipe_id([params['id']])
  if result.count > 0
    erb :show, locals: {
      name: result[0]["name"],
      calorie: result[0]["calorie"],
      protein: result[0]["protein"],
      carbs: result[0]["carbs"],
      fat: result[0]["fat"],
      image_url: result[0]["dish_img"],
      recipe: result[0]["recipe"]
    } else
    name_res = apiResult["title"]
    calories_res = apiResult["nutrition"]["nutrients"][0]['amount']
    fat_res = apiResult["nutrition"]["nutrients"][1]['amount']
    carbs_res = apiResult["nutrition"]["nutrients"][3]['amount']
    protein_res = apiResult["nutrition"]["nutrients"][8]['amount']
    dish_img = apiResult['image']
    recipe_res = apiResult['sourceUrl']

    create_recipe_api(params['id'], name_res, calories_res.to_i, protein_res.to_i, carbs_res.to_i, fat_res.to_i, dish_img, recipe_res)

    erb :show, locals: {
      name: name_res,
      calorie: calories_res,
      protein: protein_res,
      carbs: carbs_res,
      fat: fat_res,
      image_url: dish_img,
      recipe: recipe_res
    }
  end
end

get '/macbro' do
  calorie = params["calorie"]
  protein = params["protein"]
  carbs = params["carbs"]
  fat = params["fat"]
  ingredients = params["ingredients"]
  result = HTTParty.get("https://api.spoonacular.com/recipes/complexSearch?maxCalories=#{calorie}&maxProtein=#{protein}&maxCarbs=#{carbs}&maxFat=#{fat}&includeIngredients=#{ingredients}&number=10&apiKey=5897cea122e748178c8ff383bb8fd236")

  erb :list, locals: {
    result: result,
  }
end

get '/macbro/:id/edit' do
  sql = "select * from macro where id= $1"
  result = db_query(sql, [params['id']])[0]

  erb :edit, locals: {
    result: result
  }
end

put '/macbro/:id' do
  update_recipe(params['name'], params['calorie'], params['protein'], params['carbs'], params['fat'], params['dish_img'], params['recipe'], params['id'])
  redirect '/macbro/list'
end

get '/login' do
  

  erb :login
end

post '/session' do

  email = params["email"]
  password = params["password"]
  conn = PG.connect(dbname: 'macbro')
  sql = "select * from users where email = '#{email}';"
  result = conn.exec(sql)
  conn.close
  # if user exist in db
  if result.count > 0 && BCrypt::Password.new(result[0]['password_digest']).==(password)
    session[:user_id] = result[0]['id'] #its a hash / session for a single user
    redirect '/'
  else
   erb :login
  end
end

delete '/macbro' do
  conn = PG.connect(dbname: 'macbro')
  sql = "delete from macro where id=#{params['recipe_id']}"
  conn.exec(sql)
  conn.close

  redirect '/macbro/list'
end


delete '/session' do
  session[:user_id] = nil
  redirect "/login"

end


# https://api.spoonacular.com/recipes/complexSearch?titleMatch=pasta-with-tuna&addRecipeNutrition=true&apiKey=503ea3d989674393a4c80c01a257e8be
# https://api.spoonacular.com/recipes/complexSearch?maxCalories=500&maxProtein=200&maxCarbs=300&maxFat=50&includeIngredients=chicken&number=10&apiKey=5897cea122e748178c8ff383bb8fd236
# https://api.spoonacular.com/recipes/715415/information?includeNutrition=true&apiKey=5897cea122e748178c8ff383bb8fd236
# https://api.spoonacular.com/recipes/complexSearch?maxCalories=#{calorie}&maxProtein=#{protein}&maxCarbs=#{carbs}&maxFat=#{fat}&includeIngredients=#{ingredients}&number=10&apiKey=5897cea122e748178c8ff383bb8fd236