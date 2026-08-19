describe 'Zsh completion script', :slow do
  def complete_with_zsh(*words, trace_files: false)
    completion_words = words.map { |word| Shellwords.shellescape word }.join ' '
    file_trace = if trace_files
      <<~ZSH
        _files() {
          if [[ "$1" == "-/" ]]; then
            shift
            compadd "$@" -- apricot
          else
            compadd "$@" -- apple.txt apricot
          fi
        }
      ZSH
    end

    Open3.capture3(
      'zsh', '-f', '-c', <<~ZSH
        cd ./spec/tmp
        compdef() { true }
        eval "$(bash -c 'source ./cli; send_completions zsh')"
        typeset -A completion_test_seen=()
        compadd() {
          local no_space=false
          if [[ "$1" == "-S" ]]; then
            [[ -z "$2" ]] && no_space=true
            shift 2
          fi
          [[ "$1" == "--" ]] && shift
          [[ $no_space == true ]] && print 'option no-space'
          local candidate
          for candidate in "$@"; do
            if [[ -z "${completion_test_seen[$candidate]:-}" ]]; then
              printf 'candidate %s\n' "$candidate"
              completion_test_seen[$candidate]=1
            fi
          done
        }
        #{file_trace}
        words=(./cli #{completion_words})
        CURRENT=#{words.length + 1}
        _cli_completions
      ZSH
    )
  end

  context 'generation' do
    let(:cli) { File.expand_path 'spec/tmp/cli' }

    before(:context) do
      Settings.enable_completions = 'always'
      reset_tmp_dir
      FileUtils.cp_r Dir['spec/fixtures/completions/core/*'], 'spec/tmp'
      Commands::Generate.new.execute %w[generate --quiet]
    end

    after(:context) do
      Settings.enable_completions = 'never'
    end

    it 'prints Zsh completions' do
      stdout, stderr, status = Open3.capture3(
        'bash', '-c', "source #{cli}; send_completions zsh"
      )

      expect(status).to be_success
      expect(stderr).to be_empty
      expect(stdout).to start_with "#compdef cli\n"
      expect(stdout).to include '_cli_completions() {'
      expect(stdout).to end_with "compdef _cli_completions cli\n"
    end

    it 'completes commands' do
      stdout, stderr, status = complete_with_zsh 'd'

      expect(status).to be_success
      expect(stderr).to be_empty
      expect(stdout.lines(chomp: true)).to eq ['candidate deploy']
    end

    it 'preserves an empty current word' do
      stdout, stderr, status = complete_with_zsh 'server', ''

      expect(status).to be_success
      expect(stderr).to be_empty
      expect(stdout.lines(chomp: true)).to include 'candidate start'
    end
  end

  context 'configured options' do
    before(:context) do
      Settings.enable_completions = 'always'
      reset_tmp_dir
      FileUtils.cp_r Dir['spec/fixtures/completions/configured/*'], 'spec/tmp'
      Commands::Generate.new.execute %w[generate --quiet]
    end

    after(:context) do
      Settings.enable_completions = 'never'
    end

    it 'preserves literal candidates' do
      stdout, stderr, status = complete_with_zsh 'static', '', trace_files: true

      expect(status).to be_success
      expect(stderr).to be_empty
      expect(stdout.lines(chomp: true)).to include(
        'candidate two words', 'candidate $literal', 'candidate :options=files'
      )
    end

    it 'adds files when requested' do
      stdout, stderr, status = complete_with_zsh 'files', 'a', trace_files: true

      expect(status).to be_success
      expect(stderr).to be_empty
      expect(stdout.lines(chomp: true)).to contain_exactly(
        'candidate apple.txt', 'candidate apricot'
      )
    end

    it 'adds only directories when requested' do
      stdout, stderr, status = complete_with_zsh 'directories', 'a', trace_files: true

      expect(status).to be_success
      expect(stderr).to be_empty
      expect(stdout.lines(chomp: true)).to eq ['candidate apricot']
    end

    it 'applies no-space to candidates and files' do
      stdout, stderr, status = complete_with_zsh 'combined', 'a', trace_files: true

      expect(status).to be_success
      expect(stderr).to be_empty
      expect(stdout.lines(chomp: true)).to contain_exactly(
        'option no-space', 'candidate apple.txt', 'candidate apricot'
      )
    end
  end
end
