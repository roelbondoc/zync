require 'spec_helper'

describe Zync::Logging::MongoDBLogAdapter do
  include EM::SpecHelper

  let(:db) do
    EM::Synchrony::ConnectionPool.new(:size => 1) do
      EM::Mongo::Connection.new.db('zync_log_test')
    end
  end

  let(:collection) { db.collection('messages') }

  subject { Zync::Logging::MongoDBLogAdapter.new(:db => db)}


  it "writes a log message to a mongo db" do
    message = 'Foo Bar'
    time = Timecop.freeze(Time.now)
    em do
      collection.remove({})
      subject.add(Zync::Logger::DEBUG, message)
      collection.first({}) do |result|
        result.should be
        result['severity'].should == Zync::Logger::DEBUG
        result['text'].should == message
        result['created_at'].should be_within(1.second).of(time.utc)
        Timecop.return
        done
      end
    end
  end

end
