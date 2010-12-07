require 'spec_helper'

describe "Zync Routing" do

  stub_controllers do |routes|
    Routes = routes
    Routes.draw do
      match '/sports', :to => 'sports#index'
      get '/team_stats(/:grouping)', :to => 'team_stats#index'
    end
  end

  let(:app) { Routes }
  let(:request) { Rack::MockRequest.new(app) }

  describe "Route Matches" do

    it "routes to explcit controller/action" do
      response = request.get('/sports')
      response.body.should == "sports#index"
      
      request.get('/team_stats').body.should == "team_stats#index"
    end
        
    it "accepts optional parameters" do
      response = request.get('/team_stats/year')
      response.body.should == "team_stats#index"
    end        

  end

  context "Route does not exist" do

    it "returns a 404 response" do
      response = request.get('/foobar', {})
      response.status.should == 404
      response.body.should == "Not Found"
    end

  end

end
