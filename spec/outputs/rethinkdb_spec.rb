# encoding: utf-8
# frozen_string_literal: true

require 'logstash/devutils/rspec/spec_helper'
require 'logstash/outputs/rethinkdb'
require 'logstash/codecs/plain'
require 'logstash/event'

describe LogStash::Outputs::Rethinkdb do
  let(:sample_event) { LogStash::Event.new }

  let(:extra_config) { Hash.new }
  let(:default_config) do
    {
      "database" => "test",
      "table" => "events"
    }
  end
  let(:redis_config) do
    default_config.merge(extra_config)
  end
  let(:rethinkdb_output) { described_class.new(redis_config) }

  before do
    rethinkdb_output.register
  end

  describe 'receive message' do
    subject { rethinkdb_output.receive(sample_event) }

    it 'returns a string' do
      expect(subject).to eq('Event received')
    end
  end
end
