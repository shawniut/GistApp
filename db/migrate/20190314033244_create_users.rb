class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :github_oauth_token
      t.string :provider
      t.string :uid

      t.timestamps
    end
    add_index :users, :email,                unique: true
  end
end
