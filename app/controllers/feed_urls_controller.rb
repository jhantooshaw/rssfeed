class FeedUrlsController < ApplicationController
  before_filter :fetch_feed_urls, :except => [:feed_list]
  
  # list of all rss feed url
  def index    
    if params[:id]
      @feed_url  = FeedUrl.find(params[:id])
    else
      @feed_url  = FeedUrl.new
    end   
  end

  # create new feed url
  def create
    begin
      params[:feed_url][:url] = params[:feed_url][:url].strip
      @feed_url = FeedUrl.new(params[:feed_url])
      @feed_url.save!
      flash[:success] = "New feed url is created successfully."
      redirect_to feed_urls_path
    rescue Exception => e
      flash.now[:danger] = e.message
      render :index
    end
  end

  # update existing feed url
  def update
    begin
      params[:feed_url][:url] = params[:feed_url][:url].strip
      @feed_url = FeedUrl.find(params[:id])
      @feed_url.update_attributes!(params[:feed_url])
      flash[:success] = "Feed url is updated successfully."
      redirect_to feed_urls_path
    rescue Exception => e
      flash[:danger] = e.message
      render :index
    end
  end

  # destroy particular feed url
  def destroy
    begin
      @feed_url = FeedUrl.find(params[:id])
      @feed_url.destroy
      flash[:success] = "Feed url is deleted successfully."
      redirect_to feed_urls_path
    rescue Exception => e
      flash[:danger] = e.message
      render :index
    end
  end

  # get the list of all latest feeds
  def feed_list
    @feed_rsses = FeedRss.paginate(:page => params[:page])
  end

  private
  def fetch_feed_urls
    @feed_urls = FeedUrl.paginate(:page => params[:page])
  end
end