require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    subject { create(:user) }
   # Model Validations test
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_inclusion_of(:send_due_date_reminder).in_array([true, false]) }
    it { is_expected.to validate_presence_of(:due_date_reminder_interval) }
    it { is_expected.to validate_inclusion_of(:time_zone).in_array(ActiveSupport::TimeZone.all.map(&:name)) }

    context 'when send_due_date_reminder is true' do
      it 'validates presence of due_date_reminder_time' do
        user = build(:user, send_due_date_reminder: true, due_date_reminder_time: nil)
        expect(user).not_to be_valid
        expect(user.errors[:due_date_reminder_time]).to include("can't be blank")
      end
    end

    context 'when send_due_date_reminder is false' do
      it 'does not validate presence of due_date_reminder_time' do
        user = build(:user, send_due_date_reminder: false, due_date_reminder_time: nil)
        expect(user).to be_valid
      end
    end
  end

  # Model Associations test
  describe 'Associations' do
    it { is_expected.to have_many(:tickets).with_foreign_key('assigned_user_id') }
  end
  
  # Model Methods test
  describe 'Instance Methods' do
    describe '#due_date_reminders_enabled?' do
      let(:user) { build(:user, send_due_date_reminder: send_due_date_reminder) }

      context 'when send_due_date_reminder is true' do
        let(:send_due_date_reminder) { true }

        it 'returns true' do
          expect(user.due_date_reminders_enabled?).to be true
        end
      end

      context 'when send_due_date_reminder is false' do
        let(:send_due_date_reminder) { false }

        it 'returns false' do
          expect(user.due_date_reminders_enabled?).to be false
        end
      end
    end
  end
end
