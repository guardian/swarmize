require 'spec_helper'

describe User do
  describe 'being created from an info hash' do
    it "should set its attributes correctly from the info hash" do
      info_hash = {'email' => 'tom@infovore.org',
                   'name' => 'Tom Armitage',
                   'image' => 'https://lh3.googleusercontent.com/-PgrxxJsXdX0/AAAAAAAAAAI/AAAAAAAAABA/KGZmoHx_8tc/photo.jpg?sz=50'
      }

      User.should_receive(:find_or_create_by).with({:email => 'tom@infovore.org',
                   :name => 'Tom Armitage',
                   :image_url => 'https://lh3.googleusercontent.com/-PgrxxJsXdX0/AAAAAAAAAAI/AAAAAAAAABA/KGZmoHx_8tc/photo.jpg?sz=50'
      })

      u = User.find_or_create_from_info_hash(info_hash)
    end
  end
end

describe "An email address being tested for validity" do
  it "should be valid if it is Tom" do
    expect(User.is_valid_email?('tom@infovore.org')).to be_truthy
  end

  it "should be valid if it is Graham's guardian.com email" do
    expect(User.is_valid_email?('graham.tackley@theguardian.com')).to be_truthy
  end

  it "should be valid if it is Matt" do
    expect(User.is_valid_email?('matt.mcalister@guardian.co.uk')).to be_truthy
  end

  it "shouldn't be valid if it is Bob" do
    expect(User.is_valid_email?('bob@example.org')).to be_falsey
  end
end
