# https://docs.360dialog.com/whatsapp-api/whatsapp-api/media
# https://developers.facebook.com/docs/whatsapp/api/media/
# FIX: D360V2 CLOUD API

class Whatsapp::IncomingMessageService < Whatsapp::IncomingMessageBaseService
    private

    LOOKASIDE_URL = "https://lookaside.fbsbx.com"

    def processed_params
        @processed_params ||= params[:entry].try(:first).try(:[], 'changes').try(:first).try(:[], 'value')
    end

    def download_attachment_file(attachment_payload)
        url_response = HTTParty.get(inbox.channel.media_url(attachment_payload[:id]), headers: inbox.channel.api_headers)
        # This url response will be failure if the access token has expired.
        inbox.channel.authorization_error! if url_response.unauthorized?

        d360_media_url = url_response.parsed_response['url'].gsub(LOOKASIDE_URL, inbox.channel.api_url)

        Down.download(d360_media_url, headers: inbox.channel.api_headers) if url_response.success?
    end

end
