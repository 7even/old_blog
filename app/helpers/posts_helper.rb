module PostsHelper
  def format_date(date)
    content_tag 'time', :datetime => date.strftime('%Y-%m-%dT%H:%M') do
      date.strftime('%Y.%m.%d | %H:%M')
    end
  end
  
  def nested_comments(comments)
    comments.map do |comment, sub_comments|
      render(comment) + content_tag(:div, nested_comments(sub_comments), :class => "nested_comments")
    end.join.html_safe
  end
  
  def links(post)
    links = [] << link_to(
      t('posts.common.to_index'),
      posts_path
    )
    
    links << link_to(
      t('posts.common.edit'),
      edit_post_path(@post)
    ) if can? :update, @post
    
    links << link_to(
      t('posts.common.delete'),
      @post,
      method: :delete,
      confirm: t('posts.common.confirm_delete')
    ) if can? :delete, @post
    
    links.join(' | ').html_safe
  end
end
