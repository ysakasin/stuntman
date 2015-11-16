class CreateMarkovs < ActiveRecord::Migration
  def change
    create_table :markovs do |t|
      t.string :head, :index => true
      t.string :middle
      t.string :tail
    end
  end
end
