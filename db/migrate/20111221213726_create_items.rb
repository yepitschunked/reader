class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :original_location
      t.text :content

      t.timestamps
    end
  end
end
