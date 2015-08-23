require 'test_helper'

class ShortUrlTest < ActiveSupport::TestCase

  def test_by_length_returns_short_links_with_defined_url_key
  	url_with_3_charaters = FactoryGirl.create(:short_url, url_key: 'ABC')
  	url_with_2_charaters = FactoryGirl.create(:short_url, url_key: 'AB')

  	assert_includes ShortUrl.by_length(3), url_with_3_charaters
  	assert_not_includes ShortUrl.by_length(3), url_with_2_charaters
  end

end
