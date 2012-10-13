class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :status
      t.string :notes

      t.timestamps
    end
  end
end
