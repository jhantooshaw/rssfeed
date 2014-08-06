# rake feed:fetch
namespace :feed do  
  desc "fetch feeds for given feed url."
  task :fetch => :environment do 
    log = "#{Rails.root}/tmp/fetch_#{Date.today.strftime("%Y%m%d")}.log"
    @log = Logger.new(log) 
    @log.debug("******************Fetch starting at |--> #{Time.now}******************")
    p "******************Fetch starting at |--> #{Time.now}******************"
    FeedUrl.find_each(:batch_size => 10) do |feed_url|
      @log.debug("Feed url   |--> #{feed_url.title}")      
      @log.debug("Started at |--> #{Time.now}")
      p "Feed url   |--> #{feed_url.title}"
      p "Started at |--> #{Time.now}"
      FeedRss.fetch_feed(feed_url)
      @log.debug("Ended at   |--> #{Time.now}")
      p "Ended at   |--> #{Time.now}"
    end
    @log.debug("******************Fetch ending at |--> #{Time.now}******************")
    p "******************Fetch ending at |--> #{Time.now}******************"
  end
end