require 'spec_helper'

describe EmailValidator do
  describe "testing an email address for validity" do
    it "should be valid if it is Tom" do
      expect(EmailValidator.is_valid_email?('tom@infovore.org')).to be_truthy
    end

    it "should be valid if it is Graham's guardian.com email" do
      expect(EmailValidator.is_valid_email?('graham.tackley@theguardian.com')).to be_truthy
    end

    it "should be valid if it is Matt's guardian.co.uk email" do
      expect(EmailValidator.is_valid_email?('matt.mcalister@guardian.co.uk')).to be_truthy
    end

    it "shouldn't be valid if it is Bob" do
      expect(EmailValidator.is_valid_email?('bob@example.org')).to be_falsey
    end
  end

  describe "normalising an email address" do
    it "should normalize guardian.com emails to guardian.co.uk emails" do
      expect(EmailValidator.normalize_email('SAMPLE@THEGUARDIAN.COM')).to eq('sample@guardian.co.uk')
    end
    it "should lowercase a non-lowercase email" do
      expect(EmailValidator.normalize_email('SAMPLE@GUARDIAN.CO.UK')).to eq('sample@guardian.co.uk')
    end
    it "should not alter tom's email" do
      expect(EmailValidator.normalize_email('tom@infovore.org')).to eq('tom@infovore.org')
      
    end
  end
end
