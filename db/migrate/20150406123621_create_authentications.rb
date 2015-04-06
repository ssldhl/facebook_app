class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :image
      t.string :token
      t.datetime :expires_at
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :authentications, :users
  end
end
