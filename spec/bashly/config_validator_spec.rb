describe ConfigValidator do
  fixtures = load_fixture('script/validations')

  describe '#validate' do
    fixtures.each do |fixture, options|
      context "with :#{fixture}" do
        let(:validator) { described_class.new(options) }

        it 'raises an error' do
          expect { validator.validate }
            .to raise_approval("validations/#{fixture}")
        end
      end
    end
  end
end
