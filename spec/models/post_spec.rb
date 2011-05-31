require 'spec_helper'

describe Post do
  def error_for(error_id)
    base = 'activerecord.errors.models.post.attributes.'
    I18n.t("#{base}.#{error_id}")
  end
  
  it { should validate_presence_of(:title).with_message(error_for 'title.blank') }
  it { should validate_presence_of(:body).with_message(error_for 'body.blank') }
end
