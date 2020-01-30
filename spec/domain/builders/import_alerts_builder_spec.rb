require_relative '../../../domain/builders/import_alerts_builder'
require_relative '../../../domain/value_objects/feed'
require_relative '../../../domain/entities/user'

describe ImportAlertsBuilder do
  subject(:builder) { described_class.new(logger: logger, user: user, reader: reader, feed: feed) }

  let(:logger) { instance_double('logger') }
  let(:user) { instance_double(User) }
  let(:reader) { instance_double('reader') }
  let(:feed) { instance_double(Feed)}

  describe '#with_http_response' do
    subject(:with_http_response) { builder.with_http_response(controller: controller) }

    let(:controller) { instance_double('controller') }

    it 'adds an HTTP response action to the list of actions' do
      with_http_response
      expect(builder.actions).to include(a_kind_of(HTTPResponseAction))
    end

    it 'returns itself' do
      expect(with_http_response).to eq(builder)
    end
  end

  describe '#with_notification' do
    subject(:with_notification) do
      builder.with_notification(factory: factory)
    end

    let(:factory) { instance_double('factory') }

    it 'adds a notification action to the list of actions' do
      with_notification
      expect(builder.actions).to include(a_kind_of(NotificationAction))
    end

    it 'returns itself' do
      expect(with_notification).to eq(builder)
    end
  end

  describe '#build' do
    it 'creates a new import alerts service' do
      expect(builder.build).to be_a(ImportAlerts)
    end

    it 'has a reader' do
      expect(builder.build.reader).to eq(reader)
    end

    it 'has a logger' do
      expect(builder.build.observers).to include(a_kind_of(LogAction))
    end

    context 'when actions are configured' do
      let(:factory) { instance_double('factory') }

      before { builder.with_notification(factory: factory) }

      it 'has actions' do
        expect(builder.build.observers).to include(a_kind_of(NotificationAction))
      end
    end
  end
end
