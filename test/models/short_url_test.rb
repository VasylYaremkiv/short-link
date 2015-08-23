require 'test_helper'

class ShortKeyGeneratorTest < ActiveSupport::TestCase

  def test_by_length_generate_new_uniq_key
    url_with_3_charaters = FactoryGirl.create(:short_url)
    url_with_3_charaters.update_column :url_key, 'ABC'
    url_with_2_charaters = FactoryGirl.create(:short_url)
    url_with_2_charaters.update_column :url_key, 'AB'

    assert_includes ShortUrl.by_length(3), url_with_3_charaters
    assert_not_includes ShortUrl.by_length(3), url_with_2_charaters
  end

  def test_create_url_key_with_min_length
    FactoryGirl.create_list(:short_url, ShortKeyGenerator::CHARSET.length - 1)

    assert_no_difference -> { ShortUrl.by_length(2).count } do
      assert_difference -> { ShortUrl.by_length(1).count }, +1 do
        FactoryGirl.create(:short_url)
      end
    end
  end
  
  def test_create_url_key_for_remove_short_url
    FactoryGirl.create_list(:short_url, ShortKeyGenerator::CHARSET.length)
    deleted_short_url = ShortUrl.order('RANDOM()').first
    FactoryGirl.create_list(:short_url, ShortKeyGenerator::CHARSET.length)
    deleted_url_key = deleted_short_url.url_key
    deleted_short_url.destroy

    assert_difference -> { ShortUrl.by_length(1).count }, +1 do
      short_url = FactoryGirl.create(:short_url)
      assert_equal deleted_url_key, short_url.url_key
    end
  end

  def test_validate_origin_url
    assert FactoryGirl.build(:short_url, origin_url: 'http://google.com').valid?
    assert FactoryGirl.build(:short_url, origin_url: 'https://google.com').valid?
    refute FactoryGirl.build(:short_url, origin_url: 'google.com').valid?
  end
end