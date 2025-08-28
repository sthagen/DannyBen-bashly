describe Script::Introspection::Validate do
  subject do
    Script::Flag.new fixtures[fixture]
  end

  let(:fixtures) { load_fixture 'script/arguments' }
  let(:fixture) { :basic_argument }

  describe '#validate' do
    context 'with a string value' do
      let(:fixture) { :validate_string }

      it 'returns it as an array' do
        expect(subject.validate).to eq ['file_exists']
      end
    end

    context 'with an array value' do
      let(:fixture) { :validate_array }

      it 'returns it as is' do
        expect(subject.validate).to eq ['file_exists', 'file_is_writable']
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
