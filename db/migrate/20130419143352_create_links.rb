class CreateLinks < ActiveRecord::Migration
  def change
    # create_table :links, :id => false do |t|
    create_table :links do |t|

      t.integer :source_id
      t.integer :target_id
      t.float :strength

      t.timestamps
    end

  	add_index :links, [:source_id, :target_id], :unique => true
  end
end
