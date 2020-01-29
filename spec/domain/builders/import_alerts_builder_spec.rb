require_relative '../../../domain/builders/import_alerts_builder'
require_relative '../../../domain/value_objects/feed'
require_relative '../../../domain/entities/user'

describe ImportAlertsBuilder do
  subject(:builder) { described_class.new(reader: reader) }

  let(:reader) { instance_double('reader') }

  describe '#with_change_log' do
    subject(:with_change_log) { builder.with_change_log(logger: logger, user: user, feed: feed) }

    let(:logger) { instance_double('logger') }
    let(:user) { instance_double(User) }
    let(:feed) { Feed.new(type: feed_type, address: address) }
    let(:feed_type) { :rss }
    let(:address) { 'https://some.feed.rss' }

    it 'adds a change log action to the list of actions' do
      with_change_log
      expect(builder.actions[0]).to be_a(LogChangesAction)
    end

    it 'returns itself' do
      expect(with_change_log).to eq(builder)
    end
  end

  describe '#with_http_response' do
    subject(:with_http_response) { builder.with_http_response(controller: controller) }

    let(:controller) { instance_double('controller') }

    it 'adds a change log action to the list of actions' do
      with_http_response
      expect(builder.actions[0]).to be_a(HttpResponseAction)
    end

    it 'returns itself' do
      expect(with_http_response).to eq(builder)
    end
  end

  describe '#with_subscriber_notification' do
    subject(:with_subscriber_notification) { builder.with_subscriber_notification(factory: factory) }

    let(:factory) { instance_double('factory') }

    it 'adds a change log action to the list of actions' do
      with_subscriber_notification
      expect(builder.actions[0]).to be_a(NotifySubscribersAction)
    end

    it 'returns itself' do
      expect(with_subscriber_notification).to eq(builder)
    end
  end

  describe '#build' do
    it 'creates a new import alerts service' do
      expect(builder.build).to be_a(ImportAlerts)
    end

    it 'has a reader' do
      expect(builder.build.reader).to eq(reader)
    end

    context 'when actions are configured' do
      let(:factory) { instance_double('factory') }

      before do
        builder.with_subscriber_notification(factory: factory)
      end

      it 'has actions' do
        expect(builder.build.observers).to include(a_kind_of(NotifySubscribersAction))
      end
    end
  end
end
