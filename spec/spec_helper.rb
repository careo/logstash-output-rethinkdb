# frozen_string_literal: true

require 'logstash/devutils/rspec/spec_helper'
require 'logstash/outputs/rethinkdb'
require 'logstash/codecs/plain'
require 'logstash/event'

RSpec.configure do |config|
  config.before do
    RethinkHelper.clear_db
  end

  config.after(:suite) do
    RethinkHelper.clear_db
  end
end

class RethinkHelper
  include RethinkDB::Shortcuts

  def self.clear_db
    self.new.clear_db
  end

  def initialize
    @conn = r.connect(host: '127.0.0.1', port: 28_015, db: 'test')
  end

  def clear_db
    r.db('test').table('events').delete.run(@conn)
  end
end
