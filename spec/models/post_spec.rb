require 'spec_helper'

describe Post do
  it { should validate_presence_of(:title).with_message error_for('post', 'title') }
  it { should validate_presence_of(:body).with_message error_for('post', 'body') }
end
