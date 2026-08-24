describe YAML do
  describe '::trusted_load' do
    it 'does not override YAML.load for other gems' do
      expect(described_class.load('name: bashly')).to eq 'name' => 'bashly'
    end

    it 'falls back to YAML.load when unsafe_load is not available' do
      allow(described_class).to receive(:respond_to?).and_call_original
      allow(described_class).to receive(:respond_to?).with(:unsafe_load).and_return false

      expect(described_class.trusted_load('name: bashly')).to eq 'name' => 'bashly'
    end
  end

  describe '::trusted_load_file' do
    let(:path) { 'spec/fixtures/script/commands.yml' }

    it 'loads a trusted YAML file' do
      expect(described_class.trusted_load_file(path)).to include :basic_command
    end
  end

  describe '::load_erb_file' do
    let(:path) { 'spec/fixtures/erb/simple.yml' }

    it 'pre-processes the loaded YAML file with ERB' do
      expect(described_class.load_erb_file(path).to_yaml).to match_approval('extensions/yaml/load-erb-file')
    end
  end
end
