shared_examples_for 'API nestable links' do
  describe "when check links" do
    it "returns list of comments" do
      expect(resource_response['links'].size).to eq links.size
    end

    it "returns all public fields" do
      links_public_fields.each do |attr|
        expect(resource_response['links'].first[attr]).to eq resource.links.first.send(attr).as_json
      end
    end
  end
end