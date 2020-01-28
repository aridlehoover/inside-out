require_relative '../../../adapters/builders/import_alerts_builder'
require_relative '../../../domain/value_objects/feed'
require_relative '../../../domain/entities/user'

describe ImportAlertsBuilder do
  subject(:builder) { described_class.new(feed: feed, user: user) }

  let(:feed) { Feed.new(type: feed_type, address: address) }
  let(:user) { instance_double(User) }
  let(:feed_type) { :rss }
  let(:address) { 'https://some.feed.rss' }

  describe '#with_change_log' do
    it 'adds a change log action to the list of actions' do
      builder.with_change_log(user, feed: feed)
      expect(builder.actions[0]).to be_a(LogChangesAction)
    end

    it 'returns itself' do
      expect(builder.with_change_log(user, feed: feed)).to eq(builder)
    end
  end

  describe '#with_http_response' do
    let(:controller) { instance_double('controller') }

    it 'adds a change log action to the list of actions' do
      builder.with_http_response(controller)
      expect(builder.actions[0]).to be_a(HttpResponseAction)
    end

    it 'returns itself' do
      expect(builder.with_http_response(controller)).to eq(builder)
    end
  end

  describe '#with_subscriber_notification' do
    it 'adds a change log action to the list of actions' do
      builder.with_subscriber_notification
      expect(builder.actions[0]).to be_a(NotifySubscribersAction)
    end

    it 'returns itself' do
      expect(builder.with_subscriber_notification).to eq(builder)
    end
  end

  describe '#build' do
    it 'creates a new import alerts service' do
      expect(builder.build).to be_a(ImportAlerts)
    end
  end
end
