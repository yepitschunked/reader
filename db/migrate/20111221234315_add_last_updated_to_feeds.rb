class AddLastUpdatedToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :last_updated, :datetime
  end
end
