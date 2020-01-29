require_relative '../../../domain/services/notify_subscribers'
require_relative '../../../adapters/factories/notifier_factory'
require_relative '../../../domain/repositories/subscriber_repository'
require_relative '../../../domain/entities/subscriber'

describe NotifySubscribers do
  subject(:service) { described_class.new(alerts: alerts, factory: factory, repository: repository, observers: actions) }

  let(:alerts) { [alert1, alert2, alert3] }
  let(:alert1) { instance_double(Alert, active?: active) }
  let(:alert2) { instance_double(Alert, active?: active) }
  let(:alert3) { instance_double(Alert, active?: false) }
  let(:factory) { class_double(NotifierFactory) }
  let(:notifier) { instance_double('notifier', notify: true) }
  let(:repository) { instance_double(SubscriberRepository, find_all: subscribers) }
  let(:subscribers) { [] }
  let(:actions) { [action1, action2] }
  let(:action1) { instance_double('action', on_success: true) }
  let(:action2) { instance_double('action', on_success: true) }

  describe '#perform' do
    subject(:perform) { service.perform }

    context 'when there are no active alerts' do
      let(:active) { false }

      before { perform }

      it 'does not notify subscribers' do
        expect(notifier).not_to have_received(:notify)
      end

      it 'does not notify observers of success' do
        actions.each { |action| expect(action).not_to have_received(:on_success)}
      end
    end

    context 'when there are active alerts' do
      let(:active) { true }

      context 'and there are no subscribers' do
        let(:subscribers) { [] }

        before { perform }

        it 'does not notify subscribers' do
          expect(notifier).not_to have_received(:notify).with(alerts)
        end

        it 'does not notify observers of success' do
          actions.each { |action| expect(action).not_to have_received(:on_success)}
        end
      end

      context 'and there are suscribers' do
        let(:subscribers) { [subscriber1, subscriber2] }
        let(:subscriber1) { instance_double(Subscriber) }
        let(:subscriber2) { instance_double(Subscriber) }
        let(:active_alerts) { alerts.select(&:active?) }
        let(:notifier1) { instance_double('notifier1', notify: true) }
        let(:notifier2) { instance_double('notifier2', notify: true) }

        before do
          allow(factory).to receive(:build).with(subscriber1).and_return(notifier1)
          allow(factory).to receive(:build).with(subscriber2).and_return(notifier2)

          perform
        end

        it 'notifies each subscriber of the active alerts' do
          expect(factory).to have_received(:build).with(subscriber1)
          expect(factory).to have_received(:build).with(subscriber2)
          expect(notifier1).to have_received(:notify).with(active_alerts)
          expect(notifier2).to have_received(:notify).with(active_alerts)
        end

        it 'notifies each observer of success for each subscriber' do
          expect(action1).to have_received(:on_success).with(subscriber1)
          expect(action1).to have_received(:on_success).with(subscriber2)
        end
      end
    end
  end
end