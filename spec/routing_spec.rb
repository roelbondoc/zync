require 'spec_helper'

describe "Zync Routing" do

  stub_controllers do |routes|
    Routes = routes
    Routes.draw do
      match '/sports' => 'sports#index'
    end
  end

  # Rack Application
  def app
    Routes
  end

  # Perform a Mock requeset
  def get(path)
    request = Rack::MockRequest.new(app)
    yield request.get(path)
  end

  describe "match" do

    it "routes to explcit controller/action" do
      get '/sports' do |response|
        response.body.should == "sports#index"
      end
    end

  end

  context "Route does not exist" do

    it "returns a 404 response" do
      get '/foobar' do |response|
        response.status.should == 404
        response.body.should == "Not found"
      end
    end

  end

end
