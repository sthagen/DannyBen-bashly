describe Script::EnvironmentVariable do
  subject do
    options = load_fixture('script/env_vars')[fixture]
    described_class.new options
  end

  let(:fixture) { :basic_env_var }

  describe 'composition' do
    it 'includes the necessary modules' do
      modules = [Script::Introspection::Visibility, Script::Introspection::Validate]
      modules.each do |mod|
        expect(described_class.ancestors).to include(mod)
      end
    end
  end

  describe '#usage_string' do
    it 'returns a string suitable to be used as a usage pattern' do
      expect(subject.usage_string).to eq 'BUILD_DIR'
    end

    context 'with extended: true' do
      context 'when the flag is optional' do
        it 'returns the same string as it does without extended' do
          expect(subject.usage_string(extended: true)).to eq subject.usage_string
        end
      end

      context 'when the flag is also required' do
        let(:fixture) { :required }

        it 'appends (required) to the usage string' do
          expect(subject.usage_string(extended: true)).to eq "#{subject.usage_string} (required)"
        end
      end
    end
  end
end
