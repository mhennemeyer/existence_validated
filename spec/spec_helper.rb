require 'rubygems'
require 'activerecord'
require File.dirname(__FILE__) + "/../lib/existence_validated.rb"
require File.dirname(__FILE__) + "/../validates_existence/lib/validates_existence.rb"

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)



ActiveRecord::Migration.create_table :models do |t|
  t.integer :assoc_id
  t.string :name
end
ActiveRecord::Migration.create_table :assocs do |t|
end