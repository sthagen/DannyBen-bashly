describe Script::EnvironmentVariable do
  subject do
    options = load_fixture('script/env_vars')[fixture]
    described_class.new options
  end

  let(:fixture) { :basic_env_var }

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

  describe '#validate' do
    context 'with a string value' do
      let(:fixture) { :validate_string }

      it 'returns it as an array' do
        expect(subject.validate).to eq ['dir_exists']
      end
    end

    context 'with an array value' do
      let(:fixture) { :validate_array }

      it 'returns it as is' do
        expect(subject.validate).to eq ['dir_exists', 'dir_is_writable']
      end
    end
  end

  describe '#validate?' do
    it 'returns false' do
      expect(subject.validate?).to be false
    end

    context 'when validations are defined' do      
      let(:fixture) { :validate_string }

      it 'returns true' do
        expect(subject.validate?).to be true
      end
    end
  end
end
