require 'test_helper'
require "minitest/autorun"

describe Mesh::Schemas do
  subject { Mesh::Schemas.new }
  let(:new_schema_template) { File.read("#{Rails.root}/lib/mesh/schemas/longform.json.erb") }

  it 'returns a list of schemas' do
    subject.list().must_be_kind_of Array
  end

  it 'creates and deletes a new schema' do
    @name = "test_#{Time.now.to_i}"
    schema = ERB.new(new_schema_template).result(binding)
    result = subject.create(schema)
    result.wont_equal 400
    result.wont_equal 401
    result.wont_equal 500
    result.must_be_kind_of String
    delete_result = subject.delete(result)
    delete_result.must_equal 204
  end
end
