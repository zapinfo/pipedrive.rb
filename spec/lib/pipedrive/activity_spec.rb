require 'spec_helper'

RSpec.describe ::Pipedrive::Activity do
  subject { described_class.new(api_token: 'token') }
  context '#entity_name' do
    subject { super().entity_name }
    it { is_expected.to eq('activities') }
  end
end
