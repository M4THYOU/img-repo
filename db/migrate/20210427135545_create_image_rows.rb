class CreateImageRows < ActiveRecord::Migration[6.1]
  def change
    create_table :image_rows do |t|
      t.string :name
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
