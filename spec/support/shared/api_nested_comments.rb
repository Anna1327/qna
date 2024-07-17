shared_examples_for 'API nestable comments' do
  describe "when check comments" do
    it "returns list of comments" do
      expect(resource_response['comments'].size).to eq comments.size
    end

    it "returns all public fields" do
      comments_public_fields.each do |attr|
        expect(resource_response['comments'].first[attr]).to eq resource.comments.first.send(attr).as_json
      end 
    end
  end
end