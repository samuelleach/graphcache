class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.integer :id
      t.integer :followers_count
      t.integer :friends_count
      t.integer :statuses_count
      t.date :created_at
      t.text :profile_image_url_https
      t.text :description
      t.text :location
      t.text :name
      t.boolean :protected
      t.integer :group_id

      t.timestamps
    end
  end
end
