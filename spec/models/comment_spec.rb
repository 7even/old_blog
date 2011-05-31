require 'spec_helper'

describe Comment do
  it { should validate_presence_of(:content).with_message error_for('comment', 'content') }
end
