class CreateSubscribes < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribes do |t|
      t.references :user, index: true
      t.references :question, index: true
      t.timestamps
    end
  end
end
