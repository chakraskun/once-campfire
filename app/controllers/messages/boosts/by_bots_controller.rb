class Messages::Boosts::ByBotsController < Messages::BoostsController
  include RawRequestBody

  allow_bot_access only: :create

  before_action :ensure_content_present

  def create
    @boost = @message.boosts.create!(boost_params)

    broadcast_create
    render :show, status: :created
  end

  private
    def set_message
      if room = Current.user.rooms.find_by(id: params[:room_id])
        @message = room.messages.find_by(id: params[:message_id])
      end

      head :not_found unless @message
    end

    def ensure_content_present
      if raw_request_body.blank?
        head :unprocessable_content
      end
    end

    def boost_params
      { content: raw_request_body }
    end
end
