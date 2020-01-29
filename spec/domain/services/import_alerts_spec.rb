require_relative '../../../domain/services/import_alerts'
require_relative '../../../domain/value_objects/feed_item'
require_relative '../../../domain/entities/alert'

describe ImportAlerts do
  subject(:service) { described_class.new(reader: reader, repository: repository, observers: actions) }

  let(:reader) { instance_double('reader', read: feed_items) }
  let(:feed_items) { nil }
  let(:repository) { instance_double(AlertRepository) }
  let(:actions) { [action1, action2] }
  let(:action1) { instance_double('action1', on_success: true, on_failure: true) }
  let(:action2) { instance_double('action2', on_success: true, on_failure: true) }

  describe '#perform' do
    it 'reads the feed' do
      service.perform
      expect(reader).to have_received(:read)
    end

    context 'when the feed is unavailable' do
      let(:feed_items) { nil }

      before { service.perform }

      it 'notifies observers of failure' do
        actions.each do |action|
          expect(action).to have_received(:on_failure).with(no_args)
        end
      end
    end

    context 'when the feed is available' do
      let(:feed_items) { [feed_item1, feed_item2] }
      let(:feed_item1) { instance_double(FeedItem) }
      let(:feed_item2) { instance_double(FeedItem) }
      let(:alerts) { [alert1, alert2] }
      let(:alert1) { instance_double(Alert) }
      let(:alert2) { instance_double(Alert) }

      before do
        allow(repository).to receive(:create_from_feed_item).and_return(alert1, alert2)
        service.perform
      end

      it 'creates an Alert for each item in the feed' do
        feed_items.each do |feed_item|
          expect(repository)
            .to have_received(:create_from_feed_item)
            .with(feed_item)
        end
      end

      it 'notifies observers of success' do
        actions.each do |action|
          expect(action).to have_received(:on_success).with(alerts)
        end
      end
    end
  end
end
