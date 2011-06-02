window.addEvent('domready', function() {
  $$('.reply_link').each(function(link) {
    link.addEvent('click', function(e) {
      e.stop();
      
      comment_id = link.id.split('_')[2];
      el = $('reply_form_' + comment_id);
      
      $$('.reply_form').setStyle('display', 'none');
      if(el.style.display == 'none') {
        el.style.display = '';
      } else {
        el.style.display = 'none';
      }
      
      $$('.reply_link').setStyle('display', '');
      link.setStyle('display', 'none');
    });
  });
});
