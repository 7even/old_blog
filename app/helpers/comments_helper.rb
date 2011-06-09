module CommentsHelper
  def comment_links(comment)
    links = [] << link_to(
      t('posts.show.reply'),
      '#',
      id: "reply_link_#{comment.id}",
      class: 'reply_link'
    )
    
    links << link_to(
      t('common.delete'),
      destroy_comment_post_path(comment),
      :method => :delete,
      confirm: t('common.confirm_delete')
    ) if can? :delete, comment
    
    links.join(' ').html_safe
  end
end