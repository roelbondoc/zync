require 'spec_helper'

describe "Zync Routing" do

  stub_controllers do |routes|
    Routes = routes
    Routes.draw do
      match '/sports', :to => 'sports#index'
      get '/team_stats(/:grouping)', :to => 'team_stats#index'
      resources :players
      
      resources :seasons do
        collection do
          get :current
        end
        
        member do
          get :statistics
        end
      end
      
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

    context "Resourceful route" do

      it "routes to index" do
        response = request.get('/players')
        response.body.should == "players#index"
      end

      it "routes to show" do
        response = request.get('/players/100') 
        response.body.should == "players#show"
      end

      context "collection nested" do
        
        it "creates a route for a nested collection" do
          response = request.get('/seasons/current')
          response.body.should == "seasons#current"
        end
        
      end
      
      context "member nested" do
        
        it "routes to a nested member" do
          response = request.get('/seasons/123/statistics')
          response.body.should == "seasons#statistics"
        end
        
      end

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
