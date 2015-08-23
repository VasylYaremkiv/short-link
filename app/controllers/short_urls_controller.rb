class ShortUrlsController < ApplicationController

  before_action :retrieve_short_url, only: %w(show destroy)
  

  def index
    @short_urls = ShortUrl.all  
  end

  def show
  	@short_url.increment! :count_click
  	redirect_to @short_url.origin_url
  end

  def create
  	short_url = ShortUrl.find_or_initialize_by(short_url_params)
  	if short_url.save
      render json: { success: true, short_url: short_url_url(short_url) }
  	else
      render json: { success: false, errors: short_url.errors.full_messages }
  	end
  end

  def destroy
  	@short_url.destroy
  	redirect_to short_urls_path
  end
  
  private

  def short_url_params
    params.require(:short_url).permit(:origin_url)
  end

  def retrieve_short_url
    @short_url = ShortUrl.find_by(url_key: params[:id]) || raise(ActiveRecord::RecordNotFound)
  end

end