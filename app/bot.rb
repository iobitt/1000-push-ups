# frozen_string_literal: true

require 'telegram/bot'

class Bot 
  attr_reader :client, :update, :current_user 

  def initialize(token)
    @client = Telegram::Bot::Client.new(token)
    client.logger = logger
  end

  def run
    client.listen do |update|
      next unless update.instance_of?(Telegram::Bot::Types::Message)
      
      @update = update

      quantity = update.text.downcase.scan(/отжимания \+(\d+)/).flatten.first.to_i
      if quantity > 0
        current_user.push_ups.create!(quantity: quantity)
        total = current_user.push_ups.where('created_at > ? and created_at < ?', Date.today, Date.tomorrow).sum(:quantity).to_i
        client.api.send_message(chat_id: update.chat.id, text: "#{current_user.first_name} отжимания +#{quantity}. Всего: #{total}")
      end

      if update.text.downcase.scan(/я проснулся/).first
        wake_up = current_user.wake_ups.create!
        client.api.send_message(chat_id: update.chat.id, text: "Проснулись в #{wake_up.created_at.strftime('%H:%M')}. Записал")
      end

      if update.text.downcase.scan(/я ложусь спать/).first
        go_to_sleep = current_user.go_to_sleeps.create!
        client.api.send_message(chat_id: update.chat.id,
                                text: "Ложитесь спать в #{go_to_sleep.created_at.strftime('%H:%M')}. Записал")
      end

      if update.text == '/rating'
        text = "Отжиманий за сегодня:\n#{push_ups_rating.join("\n")}"
        client.api.send_message(chat_id: update.chat.id, text: text)
      elsif update.text == '/rating_yesterday'
        text = "Отжиманий за вчерашний день:\n#{push_ups_rating(Date.yesterday, Date.today).join("\n")}"
        client.api.send_message(chat_id: update.chat.id, text: text)
      end
    rescue StandardError => e
      logger.error(e)
    end
  end

  def current_user
    @current_user = User.find_by(user_id: update.from.id) || create_user
  end

  def create_user
    User.create!(user_id: update.from.id, username: update.from.username, first_name: update.from.first_name,
                 last_name: update.from.last_name)
  end

  def push_ups_rating(start_at = Date.today, end_at = Date.tomorrow)
    push_ups = Action::PushUp.group(:user_id)
                             .where('created_at > ? and created_at < ?', start_at, end_at)
                             .order('sum(quantity) desc')
                             .sum(:quantity)
    users = User.where(id: push_ups.keys).pluck(:id, :first_name).to_h
    push_ups.map { |user_id, quantity| "#{users[user_id]}: #{quantity.to_i}" }
  end
end
