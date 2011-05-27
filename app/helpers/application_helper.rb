module ApplicationHelper
  def textilize(text)
    sanitize(RedCloth.new(text).to_html) unless text.blank?
  end
end
