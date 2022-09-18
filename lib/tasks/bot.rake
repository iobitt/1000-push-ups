# frozen_string_literal: true

require 'pry'
require_relative '../../app/bot'

namespace :bot do
  task :run do
    Bot.new(ENV['TAG_BOT_TOKEN']).run
  end

  task :console do
    pry
  end
end
