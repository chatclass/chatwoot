class Whatsapp::Providers::Whatsapp360DialogCloudApiService < Whatsapp::Providers::BaseService
  def send_message(phone_number, message)

    Rails.logger.info "Send message #{message}"

    content = JSON.parse(message.content)
        
    if message.attachments.present?
      Rails.logger.info "Send Message Attachment"
      send_attachment_message(phone_number, message)
    elsif message.content_type == 'input_select'
      Rails.logger.info "Send interactive text"
      send_interactive_text_message(phone_number, message)
    #elsif message.contentontent_type == "interactive" 
    #  Rails.logger.info "Send interactive bot"
    #  send_interactive_custom_message(phone_number, message)     
    else
      Rails.logger.info "Send text message"
      send_text_message(phone_number, message)
    end

  end

  def send_template(phone_number, template_info)
    response = HTTParty.post(
      "#{api_base_path}/messages",
      headers: api_headers,
      body: {
        messaging_product: 'whatsapp',
        to: phone_number,
        template: template_body_parameters(template_info),
        type: 'template'
      }.to_json
    )

    process_response(response)
  end

  def sync_templates
    # ensuring that channels with wrong provider config wouldn't keep trying to sync templates
    whatsapp_channel.mark_message_templates_updated
    response = HTTParty.get("#{api_base_path}/v1/configs/templates", headers: api_headers)
    whatsapp_channel.update(message_templates: response['waba_templates'], message_templates_last_updated: Time.now.utc) if response.success?
  end

  def validate_provider_config?    
    response = HTTParty.post(
      "#{api_base_path}/waba_webhook",
      headers: { 'D360-API-KEY': whatsapp_channel.provider_config['api_key'], 'Content-Type': 'application/json' },
      body: {
        url: "#{ENV.fetch('FRONTEND_URL', nil)}/webhooks/whatsapp/message"
      }.to_json
    )
    response.success?
  end

  def api_headers
    { 'D360-API-KEY' => whatsapp_channel.provider_config['api_key'], 'Content-Type' => 'application/json' }
  end

  def media_url(media_id)
    "#{api_base_path}/media/#{media_id}"
  end

  private

  def api_base_path
    # provide the environment variable when testing against sandbox : 'https://waba-sandbox.360dialog.io/v1'
    ENV.fetch('360DIALOG_BASE_URL', 'https://waba-v2.360dialog.io')
  end

  def send_text_message(phone_number, message)

    if message.content.start_with("{")

      #json_content = JSON.parse(message.content)
      json_content = '{
        "interactive": {
            "type": "button",
            "header": {
                "type": "text",
                "text": "Header"
            },
            "body": {
                "text": "Detalhes da sua convocação"
            },
            "action": {
                "buttons": [
                    {
                        "type": "reply",
                        "reply": {
                            "id": "idbutton",
                            "title": ":x: Aceitar convocação"
                        }
                    },
                    {
                        "type": "reply",
                        "reply": {
                            "id": "button id 2",
                            "title": ":x: Recusar convocação"
                        }
                    }
                ]
            }
        }
      }'


      response = HTTParty.post(
        "#{api_base_path}/messages",
        headers: api_headers,
        body: {
          messaging_product: 'whatsapp',
          recipient_type: 'individual',
          to: phone_number,
          interactive: JSON.parse(json_content),
          type: 'interactive'
        }.to_json
      )
    else
      response = HTTParty.post(
        "#{api_base_path}/messages",
        headers: api_headers,
        body: {
          messaging_product: 'whatsapp',
          recipient_type: 'individual',
          to: phone_number,
          text: { body: message.content },
          type: 'text'
        }.to_json
      )
    end


    response = HTTParty.post(
      "#{api_base_path}/messages",
      headers: api_headers,
      body: {
        messaging_product: 'whatsapp',
        recipient_type: 'individual',
        to: phone_number,
        text: { body: message.content },
        type: 'text'
      }.to_json
    )

    process_response(response)
  end

  def send_attachment_message(phone_number, message)
    attachment = message.attachments.first
    type = %w[image audio video].include?(attachment.file_type) ? attachment.file_type : 'document'
    type_content = {
      'link': attachment.download_url
    }
    type_content['caption'] = message.content unless %w[audio sticker].include?(type)
    type_content['filename'] = attachment.file.filename if type == 'document'
    response = HTTParty.post(
      "#{api_base_path}/messages",
      headers: api_headers,
      body: {
        messaging_product: 'whatsapp',
        'to' => phone_number,
        'type' => type,
        type.to_s => type_content
      }.to_json
    )

    process_response(response)
  end

  def process_response(response)
    if response.success?
      response['messages'].first['id']
    else
      Rails.logger.error response.body
      nil
    end
  end

  def template_body_parameters(template_info)
    {
      name: template_info[:name],
      namespace: template_info[:namespace],
      language: {
        policy: 'deterministic',
        code: template_info[:lang_code]
      },
      components: [{
        type: 'body',
        parameters: template_info[:parameters]
      }]
    }
  end

  def send_interactive_text_message(phone_number, message)
    payload = create_payload_based_on_items(message)

    response = HTTParty.post(
      "#{api_base_path}/messages",
      headers: api_headers,
      body: {
        messaging_product: 'whatsapp',
        to: phone_number,
        interactive: payload,
        type: 'interactive'
      }.to_json
    )

    process_response(response)
  end

  def send_interactive_custom_message(phone_number, message)
    
    response = HTTParty.post(
      "#{api_base_path}/messages",
      headers: api_headers,
      body: {
        messaging_product: 'whatsapp',
        to: phone_number,
        interactive: JSON.Parse(message.content).content,
        type: 'interactive'
      }.to_json
    )

    process_response(response)
  end
  
end
