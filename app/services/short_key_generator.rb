class ShortKeyGenerator

  AMBIGIOUS_CHARSET = %w(1 l I 0 O)
  CHARSET = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a - AMBIGIOUS_CHARSET

  def perform
    result = ''
    max_amount_keys = charset_length ** (min_length - 1)

    min_length.times do
      result += generate_next_character(result, max_amount_keys)
      max_amount_keys /= charset_length
    end

    result
  end

  private

  def generate_next_character(short_key, max_amount_keys)
    CHARSET.shuffle.each do |character|
      if ShortUrl.by_length(min_length).where("url_key LIKE ?", "#{short_key + character}%").count != max_amount_keys
        return character
      end
    end
  end

  def min_length
    @_min_length ||= begin
      length = 1 
      max_amount_keys = charset_length
      loop do
        if ShortUrl.by_length(length).count == max_amount_keys
          length += 1
          max_amount_keys *= charset_length
        else
          break length
        end
      end
    end
  end

  def charset_length
    CHARSET.length
  end

end