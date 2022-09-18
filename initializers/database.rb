# frozen_string_literal: true

require 'erb'

DB_CONFIG = YAML.safe_load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(DB_CONFIG[APP_ENV])
