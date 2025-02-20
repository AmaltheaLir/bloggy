require 'sequel'

DB = Sequel.sqlite('storage/app.db')

posts = DB[:posts]

DB.alter_table :posts do
  add_column :date_added,
  String, default: 'Sometime in the Past - or Future?'
end

# DB.alter_table :posts do
#   drop_column :date_added
# end