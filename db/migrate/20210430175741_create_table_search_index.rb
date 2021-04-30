class CreateTableSearchIndex < ActiveRecord::Migration[6.1]
  def change
    create_table :table_search_indices do |t|
      t.references :record,   null: false, index: true
      t.string :filename, null: false, index: true
      t.string :content_type, index: true
      t.bigint :height, index: true
      t.bigint :width, index: true
      t.bigint :byte_size, null: false, index: true
      t.datetime :created_at, null: false, index: true
    end
  end
end
