# encoding: utf-8
# frozen_string_literal: true

require 'spec_helper'

describe LogStash::Outputs::Rethinkdb do
  let(:sample_event) { LogStash::Event.new }

  let(:extra_config) { {} }
  let(:default_config) do
    {
      'database' => 'test',
      'table' => 'events'
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
    subject(:result) { rethinkdb_output.receive(sample_event) }
    it 'inserts the records' do
      expect(result['inserted']).to eq 1
    end
  end
end
