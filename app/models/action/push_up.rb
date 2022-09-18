# frozen_string_literal: true

class Action::PushUp < Action
  validates :quantity, comparison: { greater_than_or_equal_to: 0 }
end
