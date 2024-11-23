class NotificationSenderService

  ALLOWED_TYPES = %w[sms email].freeze
  def initialize(params)
    @ticket = params[:ticket]
    @type = params[:type]
    @user =  @ticket.user
    @notification_time = params[:notification_time]
  end

  def call
    raise "Unsupported notification type" unless ALLOWED_TYPES.include?(@type)
    notification_service = "Notifications::#{@type.capitalize}Notification".constantize.new
    notification_service.send(@ticket, @notification_time)
  end

end
