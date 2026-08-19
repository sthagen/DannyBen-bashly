describe Commands::Completions do
  subject { described_class.new }

  let(:completions_path) { File.expand_path 'lib/bashly/completions/bashly-completions.bash' }
  let(:completions_script) { File.read completions_path }

  describe 'completions --help' do
    it 'shows long usage' do
      expect { subject.execute %w[completions --help] }
        .to output_approval('cli/completions/help')
    end
  end

  describe 'completions' do
    it 'shows the completions script' do
      expect { subject.execute %w[completions] }
        .to output(completions_script).to_stdout
    end
  end

end
