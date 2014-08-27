require 'spec_helper'

describe SwarmField do
  describe 'being created' do
    it 'should set its field_code correctly' do
      s = SwarmField.create(:field_name => 'What is your postcode?')
      expect(s.field_code).to eq('what_is_your_postcode')
    end
  end
end
