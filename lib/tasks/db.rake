# frozen_string_literal: true

require 'active_record'
require 'active_record/migration'

MIGRATIONS_PATH = 'db/migrations'

namespace :db do
  desc 'Подготовить рабочее окружение'
  task :setup do
    ActiveRecord::MigrationContext.new([MIGRATIONS_PATH]).migrate
  end

  desc 'Прогнать новые миграции'
  task :migrate do
    ActiveRecord::MigrationContext.new([MIGRATIONS_PATH]).migrate
  end

  desc 'Откатить последнюю миграцию'
  task :rollback do
    ActiveRecord::MigrationContext.new([MIGRATIONS_PATH]).rollback(1)
  end
end
