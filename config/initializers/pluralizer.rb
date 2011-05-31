module I18n::Backend::Pluralization
  def pluralize(locale, entry, n)
    return entry unless entry.is_a?(Hash) && n
    if n == 0 && entry.has_key?(:zero)
      key = :zero
    else
      if n % 10 == 1 && n % 100 != 11
        key = :one
      elsif [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100)
        key = :few
      elsif n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) || [11, 12, 13, 14].include?(n % 100)
        key = :many
      else
        key = :other
      end
    end
    raise InvalidPluralizationData.new(entry, n) unless entry.has_key?(key)
    entry[key]
  end
end
 
I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
