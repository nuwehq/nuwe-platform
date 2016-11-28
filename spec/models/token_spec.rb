require 'rails_helper'

describe Token do

  subject { FactoryGirl.create :token }

  it { should be_valid }

end
