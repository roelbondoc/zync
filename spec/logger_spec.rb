require 'spec_helper'
require 'tempfile'

describe Zync::Logger do
  include EM::SpecHelper

  let(:adapter) { double('Log Adapter') }
  subject { Zync::Logger.new adapter }

  context "with levels" do

    {:debug => 0, :info => 1, :warn => 2, :error => 3, :fatal => 4}.each do |level_type, value|
      it "write a #{level_type} type" do
        log_message = 'Foo Bar'
        adapter.should_receive(:add).with(value, log_message)
        em do
          subject.send(level_type, log_message)
          done
        end
      end
    end

    it "writes is able to write multiple messages" do
      adapter.should_receive(:add).with(Zync::Logger::INFO, 'Foo')
      adapter.should_receive(:add).with(Zync::Logger::INFO, 'Bar')
      em do
        subject.info('Foo')
        subject.info('Bar')
        done
      end
    end

  end

  context "with level set" do

    it "only writes to log if message serverity is greater than or equal to Logger level" do
      subject.level = Zync::Logger::INFO
      message = "Hello World"
      adapter.should_not_receive(:add).with(Zync::Logger::DEBUG, message)
      adapter.should_receive(:add).with(Zync::Logger::INFO, message)

      em do
        subject.debug(message)
        subject.info(message)
        done
      end
    end
  end

  context "with block passed" do

    it "allows for message to be created by a block" do
      adapter.should_receive(:add).with(Zync::Logger::DEBUG, 'foo bar')
      em do
        subject.debug do
          message = "Foo Bar"
          message.downcase
        end
        done
      end
    end

  end

end
