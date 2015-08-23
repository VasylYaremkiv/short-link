class ShortUrl < ActiveRecord::Base

  scope :by_length, -> (length) { where('CHAR_LENGTH(url_key) = ?', length) }

  validates :origin_url, presence: true
  validates :origin_url, format: { with: URI.regexp }, if: Proc.new { |a| a.origin_url.present? }

  before_save :generate_url_key

  def to_param
    url_key
  end

  private

  def generate_url_key
    self.url_key ||= loop do
      short_key = ShortKeyGenerator.new.perform
      break short_key unless ShortUrl.exists?(url_key: short_key)
    end
  end

end