# frozen_string_literal: true

class Action < ActiveRecord::Base
  belongs_to :user

  validates :type, presence: true
end
