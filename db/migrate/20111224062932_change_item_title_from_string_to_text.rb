class ChangeItemTitleFromStringToText < ActiveRecord::Migration
  def up
    change_column :items, :title, :text
  end

  def down
  end
end
