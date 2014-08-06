class CreateFeedRsses < ActiveRecord::Migration
  def change
    create_table :feed_rsses do |t|
      t.references  :feed_url
      t.string      :name     
      t.string      :guid
      t.string      :url
      t.datetime    :published_at
      t.timestamps
    end
  end
end
