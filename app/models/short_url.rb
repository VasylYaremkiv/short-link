class ShortUrl < ActiveRecord::Base

  AMBIGIOUS_CHARSET = %w(1 l I 0 O)
  CHARSET = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a - AMBIGIOUS_CHARSET

  scope :by_length, -> (length) { where('CHAR_LENGTH(url_key) = ?', length) }

  validates :origin_url, presence: true

  before_save :generate_url_key

  def to_param
    url_key
  end

  private
  
  def generate_url_key
  	 self.url_key ||= loop do
      random_url_key = (0...5).map{ CHARSET[rand(CHARSET.size)] }.join
      break random_url_key unless ShortUrl.exists?(url_key: random_url_key)
    end
  end

end