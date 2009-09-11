require File.join(File.dirname(__FILE__), "..", "helper.rb")

require "nitro"
require "nitro/application"


# Let's test.

describe "the application" do

  before do
    @a = Nitro::Application.new
  end
      
  it "reads environment variables" do
    ENV["NITRO_MODE"] = "lets_test_it"
    @a.read_environment
    Nitro.mode.should == :lets_test_it
  end

  it "can be accessed through Application.current" do
    Nitro::Application.current.should == @a
  end
  
end
