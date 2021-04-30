class ChangeIndexTableName < ActiveRecord::Migration[6.1]
  def change
    rename_table :table_search_indices, :image_search_indices
  end
end
