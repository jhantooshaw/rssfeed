class FeedUrl < ActiveRecord::Base
  attr_accessible :url, :title

  default_scope order('updated_at desc')

  validates :url, :presence => true, :uniqueness => {:case_sensitive => false},
    :format => { :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix}
  #validates_format_of :url, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  before_validation :format_url, :add_title
  has_many  :feed_rsses, :dependent => :nullify
  before_update :nullify_feed_rss
  after_save :fetch_feed

  private
  def format_url
    self.url = "http://#{url}" unless self.url[/^https?/]
  end

  def add_title
    begin
      feed = Feedjira::Feed.fetch_and_parse url
      self.title = (feed.present? && feed.title.present?) ? feed.title : ""
    rescue Exception => e
      self.errors.add(:url, "not a valid feed url")
      return false
    end
  end

  def fetch_feed
    FeedRss.fetch_feed(self)
  end

  def nullify_feed_rss
    feed_rsses.update_all(:feed_url_id => nil)
  end
end