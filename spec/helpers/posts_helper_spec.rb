require 'spec_helper'

describe PostsHelper do
  describe "#format_date" do
    it "correctly formats a given date" do
      source = Time.new(2011, 6, 1, 02, 0, 0)
      result = '<time datetime="2011-06-01T02:00">2011.06.01 | 02:00</time>'
      helper.format_date(source).should == result
    end
  end
end
