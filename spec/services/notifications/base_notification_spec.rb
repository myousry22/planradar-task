require 'rails_helper'

module Notifications
  RSpec.describe BaseNotification do
    describe '#send' do
      # should raise an error since it's an abstract method cant called direct from the base notification class
      it 'raises NotImplementedError' do
        expect { BaseNotification.new.send(nil, nil) }.to raise_error(NotImplementedError)
      end
    end
  end
end
