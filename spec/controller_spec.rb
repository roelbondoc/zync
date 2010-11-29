require 'spec_helper'

class FooController < Zync::Controller

  def index
    render "bar"
    close
  end

end

describe Zync::Controller do
  include EM::Spec


end