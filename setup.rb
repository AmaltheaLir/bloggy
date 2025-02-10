require 'sequel'

# change to add the required details to generate a table
DB = Sequel.sqlite('storage/app.db')

DB.create_table :posts do
  primary_key :id
  String :title
  String :author
  String :content
end

posts = DB[:posts] # Create a dataset

# Populate the table
posts.insert(title: 'Holding Hands While Drowning', author: 'The IRS', content:'Text you will forget in 0.0346 seconds...')
posts.insert(title: 'Food Poisoning', author: 'The IRS', content:'Text you will forget in 0.0346 seconds...')
posts.insert(title: 'Teacups Are Cool', author: 'The IRS', content:'Text you will forget in 0.0346 seconds...')

# Print out the number of records
puts "Post count: #{posts.count}"

# Print out the average price
#puts "The average price is: #{items.avg(:price)}"