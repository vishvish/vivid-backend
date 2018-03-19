require 'rails_helper'

RSpec.describe "schemas/edit", type: :view do
  before(:each) do
    VCR.use_cassette("schema_view_edit_create") do
      @schema = assign(:schema, Schema.create!(
        :name => [*('A'..'Z')].sample(8).join,
        :container => false,
        :description => "MyString",
        :displayField => "",
        :fields => [],
        :urlFields => []
      ))
    end
  end

  it "renders the edit schema form" do
    render
    assert_select "form[action=?][method=?]", edit_schema_path(@schema.uuid), "post" do
      assert_select "input[name=?]", "schema[name]"
      assert_select "input[name=?]", "schema[container]"
      assert_select "input[name=?]", "schema[description]"
      assert_select "input[name=?]", "schema[displayField]"
      assert_select "textarea[name=?]", "schema[fields]"
      assert_select "input[name=?]", "schema[segmentField]"
      assert_select "input[name=?]", "schema[urlFields]"
    end
  end
end
