require 'spec_helper'

describe Zync::Util do

  describe ".symbolize_keys" do

    let(:collection) { { "zync" => "async", :nested_hash => { "toronto" => "nulayer" } } }

    it "symbolizes keys" do
      subject.symbolize_keys(collection).each { |key, value| key.should be_kind_of(Symbol) }
    end
    
    it "symbolizes nested hash keys" do
      symbolized_hash = subject.symbolize_keys(collection)
      symbolized_hash[:nested_hash].each { |key, value| key.should be_kind_of(Symbol) }
    end
    
  end

end
