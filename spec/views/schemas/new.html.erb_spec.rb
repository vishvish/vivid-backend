require 'rails_helper'

RSpec.describe "schemas/new", type: :view do
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

  it "renders new schema form" do
    render
    assert_select "form[action=?][method=?]", new_schema_path, "post" do
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
