# frozen_string_literal: true
# encoding: utf-8

require 'logstash/outputs/base'
require 'logstash/namespace'

class LogStash::Outputs::Rethinkdb < LogStash::Outputs::Base
  config_name 'rethinkdb'

  def register; end # def register

  def receive(event)
    p event
    'Event received'
  end
end
