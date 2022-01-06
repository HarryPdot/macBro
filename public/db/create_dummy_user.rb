require 'pg'
require 'bcrypt'

puts "creating dummy user..."

#hard code the email and password
email = "test@ga.co"
password = "test"


# connect to db
conn = PG.connect(dbname: 'macBro')

#exec an insert statement to create a new user
password_digest = BCrypt::Password.create(password)

sql = "insert into users (email, password_digest) values ('#{email}','#{password_digest}');"

# execute an insert statement to create a new user
conn.exec(sql)
conn.close

puts "done!"