describe CompletionBuilder do
  describe '#call' do
    load_fixture('completion_builder').each do |fixture, options|
      context "with :#{fixture}" do
        let(:command) { Script::Command.new options['command'] }
        let(:builder) do
          described_class.new command, with_version: options.fetch('with_version', true)
        end

        it 'returns pattern config data' do
          expect(builder.call.to_yaml)
            .to match_approval("completion_builder/#{fixture}")
        end
      end
    end
  end

  context 'with a default command' do
    let(:fixtures) { load_fixture('completion_builder') }
    let(:command) { Script::Command.new fixtures[:default_command]['command'] }
    let(:data) { described_class.new(command).call }

    it 'adds default command argument completions to the parent command route' do
      expect(data['patterns']).to include(
        'cli [root_get_default options] <package>',
        'cli get [get options] <get_package>'
      )

      expect(data['tokens']['package']).to eq %w[get hello world]
      expect(data['tokens']['get_package']).to eq %w[hello world]
    end
  end

  context 'with a negatable flag' do
    let(:command) do
      Script::Command.new(
        'name'  => 'cli',
        'flags' => [
          { 'long' => '--color', 'short' => '-c', 'negatable' => true },
        ]
      )
    end

    it 'adds the negated long option to the same option entry' do
      data = described_class.new(command).call

      expect(data['options']['root']).to include '--color|--no-color|-c'
    end
  end
end
