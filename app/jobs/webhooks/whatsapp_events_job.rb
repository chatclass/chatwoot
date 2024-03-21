class Webhooks::WhatsappEventsJob < ApplicationJob
  queue_as :low

  def perform(params = {})
    Rails.logger.info "Perform PARAMS"
    channel = find_channel_from_whatsapp_business_payload(params)
    return if channel_is_inactive?(channel)

    Rails.logger.info "Perform PARAMS 2"

    #case channel.provider
    #when 'whatsapp_cloud'
      Rails.logger.info "Perform Whatsapp Cloud PARAMS 3"
      Whatsapp::IncomingMessageWhatsappCloudService.new(inbox: channel.inbox, params: params).perform
    #when '360dialogCloudAPI'
    #  Whatsapp::IncomingMessageService.new(inbox: channel.inbox, params: params).perform
    #else
    #  Rails.logger.info "Perform D360 PARAMS 3"
    #  Whatsapp::IncomingMessageService.new(inbox: channel.inbox, params: params).perform
    #end
  end

  private

  def channel_is_inactive?(channel)
    
    return true if channel.blank?
    return true if channel.reauthorization_required?
    return true unless channel.account.active?

    false
  end

  def find_channel_by_url_param(params)
    return unless params[:phone_number]

    Channel::Whatsapp.find_by(phone_number: params[:phone_number])
  end

  def find_channel_from_whatsapp_business_payload(params)
    # for the case where facebook cloud api support multiple numbers for a single app
    # https://github.com/chatwoot/chatwoot/issues/4712#issuecomment-1173838350
    # we will give priority to the phone_number in the payload
    return get_channel_from_wb_payload(params) if params[:object] == 'whatsapp_business_account'

    find_channel_by_url_param(params)
  end

  def get_channel_from_wb_payload(wb_params)
    phone_number = "+#{wb_params[:entry].first[:changes].first.dig(:value, :metadata, :display_phone_number)}"
    phone_number_id = wb_params[:entry].first[:changes].first.dig(:value, :metadata, :phone_number_id)
    Rails.logger.info "GET CHANNEL phone_number #{phone_number} phone_number_id #{phone_number_id}" 
    channel = Channel::Whatsapp.find_by(phone_number: phone_number)

    Rails.logger.info "CHANNEL PHONE NUMBER ID #{channel.phone_number}"
    # validate to ensure the phone number id matches the whatsapp channel
    #return channel if channel && channel.provider_config['phone_number_id'] == phone_number_id
    return channel
  end
end
