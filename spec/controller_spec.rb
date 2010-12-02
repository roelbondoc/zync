require 'spec_helper'

class FooController < Zync::Controller

  def index
    render "bar"
    close
  end

end

describe Zync::Controller do
  include Zync::Test::ControllerHelper

  let(:app) { FooController }

  it "returns correct headers" do
    get '/' do |status, headers, body|
      status.should == 200
      headers["Content-Type"].should == "text/html"
      body.should be_kind_of(EM::Deferrable)
      stop
    end
  end

  it "returns correct body" do
    get_body '/' do |body_chunk|
      body_chunk.should == 'bar'
      stop
    end
  end

end
