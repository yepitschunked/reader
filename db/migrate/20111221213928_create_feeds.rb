class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :description
      t.string :original_location

      t.timestamps
    end
  end
end
