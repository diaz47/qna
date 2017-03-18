class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :value, default: 0
      t.references :votable, polymorphic: true, index: true
      t.references :user, index: true
      
      t.timestamps
    end
  end
end
