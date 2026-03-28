class AddViewsCountToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :views_count, :integer, default: 0
  end
end
