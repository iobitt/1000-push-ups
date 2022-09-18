# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :actions
  has_many :push_ups, class_name: 'Action::PushUp'
  has_many :wake_ups, class_name: 'Action::WakeUp'
  has_many :go_to_sleeps, class_name: 'Action::GoToSleep'
end
