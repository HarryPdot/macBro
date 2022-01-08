#crud method for recipes
require 'pg'

def db_query(sql, params = [])
    conn = PG.connect(dbname: 'macbro')
  
    result = conn.exec_params(sql, params)
    conn.close
    return result
  end

def all_recipes()
  sql = "select * from macro;"
  db_query(sql)
end

def create_recipe(name, calorie, protein, carbs, fat, dish_img, recipe, user_id)
  sql = "insert into macro (name, calorie, protein, carbs, fat, dish_img, recipe, user_id) values ($1, $2, $3, $4, $5, $6, $7, $8);"
  db_query(sql, [name, calorie, protein, carbs, fat, dish_img, recipe, user_id])
end

def delete_recipe()
  sql = "delete from macro where id = $1;"
  db_query(sql, recipe)
end

def update_recipe(name, calorie, protein, carbs, fat, dish_img, recipe, id)
  sql = "update macro set name= $1, calorie = $2, protein = $3, carbs = $4, fat= $5, dish_img= $6, recipe= $7 where id= $8;"
  db_query(sql, [name, calorie, protein, carbs, fat, dish_img, recipe, id])
end

def update_recipe_api(id, name, calorie, protein, carbs, fat, dish_img, recipe)
  sql = "update macro set id= $1, name= $2, calorie = $3, protein = $4, carbs = $5, fat= $6, dish_img= $7, recipe= $8;"
  db_query(sql, [id, name, calorie, protein, carbs, fat, dish_img, recipe])
end

def create_recipe_api(id, name, calorie, protein, carbs, fat, dish_img, recipe)
  sql = "insert into macro (id, name, calorie, protein, carbs, fat, dish_img, recipe) values ($1, $2, $3, $4, $5, $6, $7, $8);"
  db_query(sql, [id, name, calorie, protein, carbs, fat, dish_img, recipe])
end

def select_recipe_id(id) 
  sql = "select * from macro where id= $1;"
  db_query(sql, id)
end