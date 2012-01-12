class AddErrorToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :error, :string
  end
end
