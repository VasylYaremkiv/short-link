require 'test_helper'

class ShortUrlsControllerTest < ActionController::TestCase

  def setup
    @origin_url = 'http://google.com'    
  end

  def test_show_redirect_user_to_origin_url
    short_url = FactoryGirl.create(:short_url, origin_url: @origin_url)

    assert_difference -> { short_url.reload.count_click }, +1 do
      get :show, id: short_url.url_key
    end
    assert_redirected_to @origin_url
  end

  def test_show_raise_error_if_short_url_not_found
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: 'incorrect'
    end
  end

  def test_create_returns_new_short_url_if_origin_url_valid
    post :create, short_url: { origin_url: @origin_url }

    assert_response :success
    result = JSON.parse response.body
    assert result['success']
    assert result['short_url']
  end

  def test_create_returns_existing_short_url_if_origin_url_is_present_in_database
    short_url = FactoryGirl.create(:short_url, origin_url: @origin_url)
    post :create, short_url: { origin_url: @origin_url }

    assert_response :success
    result = JSON.parse response.body
    assert result['success']
    assert_equal short_url_url(short_url), result['short_url']
  end

  def test_create_returns_error_if_origin_url_is_not_present
    post :create, short_url: { origin_url: '' }

    assert_response :success
    result = JSON.parse response.body
    refute result['success']
    assert_equal ["Origin url can't be blank"], result['errors']
  end

  def test_delete_removes_existing_short_url
    short_url = FactoryGirl.create(:short_url, origin_url: @origin_url)

    assert_difference -> { ShortUrl.count }, -1 do
      delete :destroy, id: short_url.url_key
    end
  end

end
