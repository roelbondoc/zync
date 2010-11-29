require 'spec_helper'

describe Zync do
  describe "Environment" do

    it "defaults to development" do
      Zync.env.should == "development"
    end
    
  end

end
