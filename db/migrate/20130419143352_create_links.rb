class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :source_id
      t.integer :target_id
      t.float :strength

      t.timestamps
    end
  end
end
