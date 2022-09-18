# frozen_string_literal: true

require 'active_record'

require_relative '../app/models/user'
require_relative '../app/models/action'
require_relative '../app/models/action/push_up'
require_relative '../app/models/action/wake_up'
require_relative '../app/models/action/go_to_sleep'

APP_ENV = ENV['APP_ENV'] || 'development'

ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.logger.info "APP_ENV: #{APP_ENV}"
ActiveRecord.default_timezone = :local

require_relative "environments/#{APP_ENV}"

Dir["#{Dir.pwd}/initializers/**/*.rb"].each { |file| require file }

def logger
  ActiveRecord::Base.logger
end
