module PostsHelper
  def format_date(date)
    content_tag('time', :datetime => date.strftime('%Y-%m-%dT%H:%M')) do
      date.strftime('%Y.%m.%d | %H:%M')
    end
  end
end
