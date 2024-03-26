class ActionCableBroadcastJob < ApplicationJob
  queue_as :critical

  def perform(members, event_name, data)
    Rails.logger.info('Action Cable Perform')
    members.each do |member|
      ActionCable.server.broadcast(member, { event: event_name, data: data })
    end
  end
end
