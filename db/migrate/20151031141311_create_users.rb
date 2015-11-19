class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :screen_name, :index => true, :unique => true
      t.string :since_id, :default => 1
      t.string :access_token
      t.string :access_token_secret
    end
  end
end
