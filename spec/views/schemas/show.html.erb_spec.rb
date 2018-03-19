require 'rails_helper'

RSpec.describe "schemas/show", type: :view do
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

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@schema.name}/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
