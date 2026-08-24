describe Watch do
  subject { described_class.new(*targets, interval:) }

  let(:targets)  { [] }
  let(:interval) { nil }
  let(:watcher)  { instance_double Watchly::Watcher }
  let(:changes) do
    instance_double(
      Watchly::Changeset,
      modified: ['modified file'],
      added:    ['added file'],
      removed:  ['removed file']
    )
  end

  before do
    allow(Watchly::Watcher).to receive(:new).and_return(watcher)
    allow(watcher).to receive(:on_change).and_yield(changes)
  end

  describe '#on_change' do
    it 'watches the current directory with the configured interval' do
      expect(Watchly::Watcher).to receive(:new).with('.', interval: 2.0)

      subject.on_change { |_| nil }
    end

    it 'passes normalized changes to the block' do
      received_changes = nil

      subject.on_change { |payload| received_changes = payload }

      expect(received_changes).to eq({
        modified: ['modified file'],
        added:    ['added file'],
        removed:  ['removed file'],
      })
    end

    context 'with custom targets and interval' do
      let(:targets)  { %w[lib spec] }
      let(:interval) { 0.25 }

      it 'passes them through to Watchly' do
        expect(Watchly::Watcher).to receive(:new).with(*targets, interval:)

        subject.on_change { |_| nil }
      end
    end

    context 'when the watch is interrupted' do
      it 're-raises as Bashly::Interrupt' do
        allow(watcher).to receive(:on_change).and_raise(Interrupt)

        expect { subject.on_change { |_| nil } }.to raise_error(Bashly::Interrupt)
      end
    end

    context 'when no block is provided' do
      it 'raises ArgumentError' do
        expect { subject.on_change }.to raise_error(ArgumentError, 'block required')
      end
    end
  end
end
