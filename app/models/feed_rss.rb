class FeedRss < ActiveRecord::Base
  
  attr_accessible :guid, :name, :published_at, :url
  belongs_to :feed_url

  default_scope order('published_at desc')

  def self.fetch_feed(feed_url)
    feed = Feedjira::Feed.fetch_and_parse(feed_url.url)
    add_feeds(feed.entries, feed_url) if feed && feed.entries
  end
  
  private
  def self.add_feeds(feeds, feed_url)
    feeds.each do |feed|
      params ={
        :name         => feed.title,
        :url          => feed.url,
        :published_at => feed.published,
        :guid         => feed.id
      }
      feed_rss = feed_url.feed_rsses.where(:guid => feed.id).first_or_initialize
      feed_rss.update_attributes(params)
    end
  end
  
end
