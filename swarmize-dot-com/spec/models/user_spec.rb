require 'spec_helper'

describe User do
  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end

  describe "being saved" do
    it "should ensure its email is stored downcase" do
      user = FactoryGirl.build(:user, :email => 'BOB@TEST.com')
      user.save
      expect(user.email).to eq('bob@test.com')
    end
  end

  describe 'being created from an info hash' do
    it "should set its attributes correctly from the info hash" do
      info_hash = {'email' => 'tom@infovore.org',
                   'name' => 'Tom Armitage',
                   'image' => 'https://lh3.googleusercontent.com/-PgrxxJsXdX0/AAAAAAAAAAI/AAAAAAAAABA/KGZmoHx_8tc/photo.jpg?sz=50'
      }

      expect(User).to receive(:find_or_create_by).with({:email => 'tom@infovore.org',
                   :name => 'Tom Armitage',
                   :image_url => 'https://lh3.googleusercontent.com/-PgrxxJsXdX0/AAAAAAAAAAI/AAAAAAAAABA/KGZmoHx_8tc/photo.jpg?sz=50'
      })

      u = User.find_or_create_from_info_hash(info_hash)
    end
  end

  describe 'being created' do
    it 'should set any access permissions created for its email address to being it' do
      access_permission = AccessPermission.create(:swarm_id => 1,
                                                  :email => 'bob@example.com') 
      bob = User.create(name: 'Bob',
                        email: 'bob@example.com')

      access_permission.reload

      expect(access_permission.user).to eq(bob)
    end
  end
end


