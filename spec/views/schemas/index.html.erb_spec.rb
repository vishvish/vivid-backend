require 'rails_helper'

RSpec.describe "schemas/index", type: :view do
  it "renders a list of schemas" do
    VCR.use_cassette("schema_view_index_create") do
      assign(:schemas, [
        Schema.create!(
          :name => [*('A'..'Z')].sample(8).join,
          :container => false,
          :description => "MyString",
          :displayField => "",
          :fields => [],
          :urlFields => []
        ),
        Schema.create!(
          :name => [*('A'..'Z')].sample(8).join,
          :container => false,
          :description => "MyString",
          :displayField => "",
          :fields => [],
          :urlFields => []
        )
      ])
      render
      expect(rendered).to match /[A-Z]{8}\W/

      # assert_select "tr>td", :text => /^[A-Z]{8}\W/, :count => 2
      # assert_select "tr>td", :text => false.to_s, :count => 2
      # assert_select "tr>td", :text => "Description".to_s, :count => 2
      # assert_select "tr>td", :text => "".to_s, :count => 2
      # assert_select "tr>td", :text => "".to_s, :count => 2
      # assert_select "tr>td", :text => "".to_s, :count => 2
    end
  end
end
