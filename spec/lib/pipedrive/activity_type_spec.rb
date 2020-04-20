require 'spec_helper'

RSpec.describe ::Pipedrive::ActivityType do
  subject { described_class.new(api_token: 'token') }
  context '#entity_name' do
    subject { super().entity_name }
    it { is_expected.to eq('activityTypes') }
  end
end
