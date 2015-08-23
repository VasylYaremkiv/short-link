require 'test_helper'

class ShortUrlTest < ActiveSupport::TestCase

  def test_perform_returns_short_links_with_defined_url_key
    FactoryGirl.create_list(:short_url, ShortKeyGenerator::CHARSET.length - 3)
    10.times do
      uniq_key = ShortKeyGenerator.new.perform
      refute ShortUrl.exists?(url_key: uniq_key)	
    end
  end

end