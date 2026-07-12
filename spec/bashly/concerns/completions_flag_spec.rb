describe Script::Flag do
  subject { described_class.new fixtures[fixture] }

  let(:fixtures) { load_fixture 'script/flags' }
  let(:fixture) { :basic_flag }
  let(:command) { 'some command' }

  describe '#completion_data' do
    context 'when the flag has allowed defined' do
      let(:fixture) { :completions_allowed }

      it 'returns a data structure for completely with the allowed list' do
        expect(subject.completion_data(command).to_yaml).to match_approval('completions/flag-allowed')
      end
    end

    context 'when the flag has completions defined' do
      let(:fixture) { :completions_completions }

      it 'returns a data structure for completely with the completions list' do
        expect(subject.completion_data(command).to_yaml).to match_approval('completions/flag-completions')
      end
    end

    context 'when the flag does not have allowed or completions' do
      it 'returns an empty hash' do
        expect(subject.completion_data(command)).to eq({})
      end
    end
  end

  describe '#completion_option_entry' do
    context 'when the flag has aliases' do
      let(:fixture) { :aliases }

      it 'includes all aliases in the option entry' do
        expect(subject.completion_option_entry('name')).to eq '--container|-c|--pod|-p <name>'
      end
    end
  end
end
