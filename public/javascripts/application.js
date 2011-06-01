// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
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
    });
  });
});
