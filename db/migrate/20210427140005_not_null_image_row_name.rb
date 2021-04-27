class NotNullImageRowName < ActiveRecord::Migration[6.1]
  def change
    change_column_null :image_rows, :name, false
    change_column_null :image_rows, :is_deleted, false
    change_column_default :image_rows, :is_deleted, false
  end
end
