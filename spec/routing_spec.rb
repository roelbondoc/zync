require 'spec_helper'

describe "Zync Routing" do
  include Zync::Test::ControllerHelper

  let(:route_set) { Zync::Routing::RouteSet.new }

  before do
    route_set.draw do
      match '/sports' => 'sports#index'
    end
  end

  context "Route does not exist" do

    it "returns a 404 response" do
      request = Rack::MockRequest.new(route_set)
      response = request.get '/foobar'
      response.status.should == 404
      response.body.should == "Not found"
    end

  end

end