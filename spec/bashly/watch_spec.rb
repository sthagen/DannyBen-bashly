describe Watch do
  subject { described_class.new(*dirs, **options) }

  let(:dirs)     { [] }
  let(:options)  { {} }
  let(:listener) { double(start: nil, stop: nil) }
  let(:listen)   { class_double(Listen) }
  let(:changes)  { [['modified file'], ['added file'], ['removed file']] }

  before do
    allow(subject).to receive(:listen).and_return(listen)
    allow(listen).to receive(:to).and_yield(*changes).and_return(listener)
    allow(subject).to receive(:sleep) # prevent blocking
  end

  describe '#on_change' do
    it 'starts and stops the listener' do
      expect(listener).to receive(:start)
      expect(listener).to receive(:stop)

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

    it 'stops the listener if waiting raises' do
      allow(subject).to receive(:sleep).and_raise('boom')

      expect(listener).to receive(:stop)
      expect { subject.on_change { |_| nil } }.to raise_error('boom')
    end

    context 'with custom dirs and options' do
      let(:dirs)    { %w[lib spec] }
      let(:options) { { latency: 0.25 } }

      it 'passes them through to Listen' do
        expect(listen).to receive(:to) do |*passed_dirs, **passed_options|
          expect(passed_dirs).to eq(dirs)
          expect(passed_options[:latency]).to eq(options[:latency])
          expect(passed_options).to have_key(:force_polling)

          # instead of rspec's 'and_return' which cannot be used with a block
          listener
        end

        subject.on_change { |_| nil }
      end
    end

    context 'when the watch is interrupted' do
      it 'stops the listener and re-raises as Bashly::Interrupt' do
        allow(subject).to receive(:sleep).and_raise(Interrupt)

        expect(listener).to receive(:stop)
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
