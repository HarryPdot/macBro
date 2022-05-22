require 'pg'
require 'bcrypt'

puts "creating dummy user..."

#hard code the email and password
email = "test2@ga.co"
password = "test2"


# connect to db
conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'macbro'})

#exec an insert statement to create a new user
password_digest = BCrypt::Password.create(password)

sql = "insert into users (email, password_digest) values ('#{email}','#{password_digest}');"

# execute an insert statement to create a new user
conn.exec(sql)
conn.close

puts "done!"

