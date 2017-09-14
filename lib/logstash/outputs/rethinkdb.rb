# frozen_string_literal: true
# encoding: utf-8

require 'logstash/outputs/base'
require 'logstash/namespace'

require 'rethinkdb'

class LogStash::Outputs::Rethinkdb < LogStash::Outputs::Base
  include RethinkDB::Shortcuts
  # include Stud::Buffer

  config_name 'rethinkdb'
  concurrency :shared
  default :codec, 'json'
  # attr_accessor :logger

  # Hostname of RethinkDB server
  config :host, validate: :string, default: 'localhost'
  # Driver connection port of RethinkDB server
  config :port, validate: :number, default: 28_015
  # Auth key of RethinkDB server (don't provide if nil)
  config :auth_key, validate: :string, default: ''
  # Which tables to watch for changes
  config :table, validate: :string
  config :database, validate: :string
  # ssl support
  config :ca_certs, default: nil
  # Credentials as of RethinkDB v2.3.x
  config :user, validate: :string, default: 'admin'
  config :password, validate: :string, default: ''

  # used in https://github.com/logstash-plugins/logstash-output-redis
  # which we may want to work in here too

  # # If true, we send an RPUSH every "batch_events" events or
  # # "batch_timeout" seconds (whichever comes first).
  # # Only supported for `data_type` is "list".
  # config :batch, :validate => :boolean, :default => false

  # # If batch is set to true, the number of events we queue up for an RPUSH.
  # config :batch_events, :validate => :number, :default => 50

  # # If batch is set to true, the maximum amount of time between RPUSH commands
  # # when there are pending events to flush.
  # config :batch_timeout, :validate => :number, :default => 5

  def register
    @codec.on_event(&method(:send_to_rethink))

    create_table
  end
  
  def close
    connection.close
  end

  def create_table
    return false if self.database.table_list.run(self.connection).include?(@table)
    self.database.table_create(@table).run(self.connection)
  end

  def receive(event)
    return if event == LogStash::SHUTDOWN
    @codec.encode(event)
  rescue LocalJumpError
    # This LocalJumpError rescue clause is required to test for regressions
    # for https://github.com/logstash-plugins/logstash-output-redis/issues/26
    # see specs. Without it the LocalJumpError is rescued by the StandardError
    raise
  rescue StandardError => e
    @logger.warn('Error encoding event', exception: e,
                                         event: event)
  end

  def multi_receive(events)
    if @receives_encoded
      self.multi_receive_encoded(codec.multi_encode(events))
    else
      events.each {|event| receive(event) }
    end
  end
  def send_to_rethink(event, payload)
    puts 'payload:'
    pp payload
    result = table.insert(JSON.parse(payload, symbolize_names: true)).run(self.connection)
    p [:result, result]
  rescue => e
    pp e
    @logger.warn('Failed to send event to Redis', event: event,
                                                  identity: identity, exception: e,
                                                  backtrace: e.backtrace)
    sleep @reconnect_interval
    @redis = nil
    retry
  end

  def connection
    @connection ||= begin
            ssl = ({ ca_certs: @ca_certs } if @ca_certs)
            if @auth_key == ''
              r.connect(
                host: @host,
                port: @port,
                user: @user,
                password: @password,
                ssl: ssl
              )
            else
              r.connect(
                host: @host,
                port: @port,
                auth_key: @auth_key,
                ssl: ssl
              )
            end
          end
  end

  def database
    r.db(@database)
  end

  def table
    r.table(@table)
  end

  # A string used to identify a RethinkDB instance in log messages
  def identity
    # "redis://#{@password}@#{@current_host}:#{@current_port}/#{@db} #{@data_type}:#{@key}"
    'rethinkdb://TODO'
  end
end
