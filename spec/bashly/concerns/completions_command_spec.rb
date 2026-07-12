describe Script::Command do
  subject { described_class.new fixtures[fixture] }

  let(:fixtures) { load_fixture('script/commands') }
  let(:fixture) { :completions_simple }
  let(:completion_generator) { instance_double Completely::Completions }

  describe '#completion_data' do
    it 'returns a data structure for completely' do
      expect(subject.completion_data.to_yaml).to match_approval('completions/simple')
    end
  end

  describe '#completion_function' do
    before do
      allow(Completely::Completions).to receive(:new)
        .with(subject.completion_data)
        .and_return completion_generator
      allow(completion_generator).to receive(:wrapper_function)
        .with('custom_name')
        .and_return 'wrapped completion script'
    end

    it 'returns the generated bash completion script wrapped in a function' do
      expect(subject.completion_function('custom_name'))
        .to eq 'wrapped completion script'
    end
  end

  context 'with a more complex command' do
    let(:fixture) { :completions_advanced }

    describe '#completion_data' do
      it 'returns a data structure for completely' do
        expect(subject.completion_data.to_yaml)
          .to match_approval('completions/advanced')
      end
    end

    describe '#completion_script' do
      before do
        allow(Completely::Completions).to receive(:new)
          .with(subject.completion_data)
          .and_return completion_generator
        allow(completion_generator).to receive(:script)
          .and_return 'completion script'
      end

      it 'returns the generated bash completion script' do
        expect(subject.completion_script)
          .to eq 'completion script'
      end
    end
  end

  context 'with a command that uses whitelist args' do
    let(:fixture) { :completions_whitelist }

    describe '#completion_data' do
      it 'returns a data structure that includes the whitelist' do
        expect(subject.completion_data.to_yaml)
          .to match_approval('completions/whitelist')
      end
    end
  end

  context 'with a command that uses pattern completion sources' do
    let(:fixture) { :completions_pattern_sources }

    describe '#completion_data' do
      it 'returns pattern config data with tokens and options' do
        expect(subject.completion_data.to_yaml)
          .to match_approval('completions/pattern_sources')
      end
    end
  end

  context 'with a command that has nested command aliases' do
    let(:fixture) { :nested_aliases }

    describe '#completion_data' do
      it 'returns a data structure that includes all command full names' do
        expect(subject.completion_data.to_yaml)
          .to match_approval('completions/nested_aliases')
      end
    end
  end

  context 'with a command that has global flags on the root command' do
    let(:fixture) { :completions_global_flags_root }

    describe '#completion_data' do
      it 'returns a data structure that includes all command full names' do
        expect(subject.completion_data.to_yaml)
          .to match_approval('completions/completion_global_flags_root')
      end
    end
  end

  context 'with a command that has global flags on a nested command' do
    let(:fixture) { :completions_global_flags_nested }

    describe '#completion_data' do
      it 'returns a data structure that includes all command full names' do
        expect(subject.completion_data.to_yaml)
          .to match_approval('completions/completion_global_flags_nested')
      end
    end
  end

  context 'with a command that has global flags on the root and a nested command' do
    let(:fixture) { :completions_global_flags }

    describe '#completion_data' do
      it 'returns a data structure that includes all command full names' do
        expect(subject.completion_data.to_yaml)
          .to match_approval('completions/completion_global_flags')
      end
    end
  end
end
