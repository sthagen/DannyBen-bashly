describe LibrarySourceConfig do
  fixtures = Dir['spec/fixtures/libraries_validation/*.yml']
  subject { described_class.new path }

  let(:path) { 'spec/fixtures/libraries/libraries.yml' }

  describe '#validated_data' do
    it 'returns the data after validating it' do
      expect(subject).to receive(:validate)
      expect(subject.validated_data).to eq subject.data
    end
  end

  describe '#validate' do
    fixtures.each do |path|
      context "with #{File.basename(path)}" do
        let(:fixture_name) { File.basename(path, '.yml') }
        let(:config)       { described_class.new(path) }

        it 'raises an error' do
          expect { config.validate }
            .to raise_approval("libraries_validation/#{fixture_name}")
        end
      end
    end
  end
end
