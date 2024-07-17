shared_examples_for 'API nestable files' do
  describe "when check files" do
    it "returns list of files" do
      expect(resource_response['files'].size).to eq files.size
    end
  end
end