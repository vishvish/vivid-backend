require 'test_helper'
require "minitest/autorun"

describe MeshService do
  subject { MeshService.new }

  it "has the correct credentials" do
    MeshService.authenticate().must_equal 200
    MeshService.class_variable_get("@@token").wont_be_empty
  end

  it "has the incorrect credentials" do
    MeshService.authenticate(false).must_equal 401
    MeshService.class_variable_get("@@token").must_be_nil
  end

  it "authenticates if there is no token" do
    MeshService.token.wont_be_empty
  end

end
