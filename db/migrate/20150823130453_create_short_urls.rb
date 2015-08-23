class CreateShortUrls < ActiveRecord::Migration
  
  def change
    create_table :short_urls do |t|
      t.string :url_key, null: false
      t.text :origin_url, null: false
      t.integer :count_click, null: false, default: 0
      t.timestamps null: false
    end

    add_index :short_urls, :url_key, unique: true
    add_index :short_urls, :origin_url, unique: true
  end

end
