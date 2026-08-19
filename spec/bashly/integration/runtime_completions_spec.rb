describe 'runtime completions', :slow do
  workspaces = Dir['spec/fixtures/completions/*'].select { |path| File.directory? path }

  workspaces.each do |workspace|
    context File.basename(workspace) do
      examples = YAML.trusted_load_file "#{workspace}/examples.yml"
      cli = File.expand_path 'spec/tmp/cli'

      before(:context) do
        Settings.completions = 'minimal'
        reset_tmp_dir
        FileUtils.cp_r Dir["#{workspace}/*"], 'spec/tmp'
        Commands::Generate.new.execute %w[generate --quiet]
      end

      after(:context) do
        Settings.completions = nil
      end

      examples.each do |name, example|
        describe name do
          it 'works' do
            stdout, stderr, status = Open3.capture3(
              cli, '__complete', *example['words']
            )

            expect(status).to be_success
            expect(stderr).to be_empty
            expected = example['expected'] + [":options=#{example['options']}"]
            expect(stdout.lines(chomp: true)).to eq expected
          end
        end
      end
    end
  end

end
