class AddAssociations < ActiveRecord::Migration
  def up
    add_column :items, :feed_id, :integer
  end

  def down
  end
end
