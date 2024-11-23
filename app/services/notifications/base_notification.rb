module Notifications
  class BaseNotification
    def send(ticket, notification_time)
      raise NotImplementedError, "Subclasses must implement the 'send' method"
    end
  end

end
