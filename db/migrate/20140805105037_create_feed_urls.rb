class CreateFeedUrls < ActiveRecord::Migration
  def change
    create_table :feed_urls do |t|
      t.string      :url
      t.string      :title
      t.timestamps
    end
  end
end
