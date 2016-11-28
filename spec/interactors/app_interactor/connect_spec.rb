require 'rails_helper'
require 'action_controller'

describe AppInteractor::Connect do

  let(:user)    { FactoryGirl.create :user }

  def auth_hash
    ({ provider: "humanapi",
      uid: "533d6415cded3069700017a8",
      info: {
        email: "me@example.com",
        created_at: '2014-04-03T13:37:25.300Z'
      },
      credentials: {
        token: "ICdv2FVIfvzIKnWv-dBQ3ytAxDM=30TbH0Tq701f6568696cf2bd13db16fd9b83fb5fc279a48fc5cc85a7a331f0f1f3ffa0e39f0f7d3c0a88a96ef22e8a9cbc88962f7730b971cdbee951b536872f393f923b288ecc85b782ce55d33ca30d14ce53ff898d4e41696829c69448b114866eb4c67e85bee2c13bed4f53645966eb4a50ecedd5e8245f476169213458c070fd3775",
        expires: false
      },
      user_id: user.id,
      state: user.tokens.first.id
    })
  end

  it "creates an app" do
    expect do
      described_class.call(auth_hash)
    end.to change(App, :count).by(1)
  end

  context "new app" do

    let(:app) { user.apps.first }

    it "stores the provider" do
      described_class.call(auth_hash)
      expect(app.provider).to eq(auth_hash[:provider])
    end

    it "stores the uid" do
      described_class.call(auth_hash)
      expect(app.uid).to eq(auth_hash[:uid])
    end

    it "emits the Pusher 'app-connected' event" do
      pusher_worker = class_spy("PusherWorker").as_stubbed_const
      described_class.call(auth_hash)
      expect(pusher_worker).to have_received(:perform_async)
    end

    it "puts HealthDataWorker to work" do
      health_data_worker = class_spy("HealthDataWorker").as_stubbed_const
      described_class.call(auth_hash)
      expect(health_data_worker).to have_received(:perform_async)
    end

    it "emits the Intercom 'connected_apps' event" do
      intercom_worker = class_spy("IntercomWorker").as_stubbed_const
      described_class.call(auth_hash)
      expect(intercom_worker).to have_received(:perform_async)
    end
  end

  context "existing app" do

    before do
      FactoryGirl.create :app, user: user, provider: auth_hash[:provider]
    end

    let(:app) { user.apps.first }

    it "emits the Pusher 'app-connected' event" do
      pusher_worker = class_spy("PusherWorker").as_stubbed_const
      described_class.call(auth_hash)
      expect(pusher_worker).to have_received(:perform_async)
    end

    it "puts HealthDataWorker to work" do
      health_data_worker = class_spy("HealthDataWorker").as_stubbed_const
      described_class.call(auth_hash)
      expect(health_data_worker).to have_received(:perform_async)
    end

    it "emits the Intercom 'connected_apps' event" do
      intercom_worker = class_spy("IntercomWorker").as_stubbed_const
      described_class.call(auth_hash)
      expect(intercom_worker).to have_received(:perform_async)
    end
  end

end
