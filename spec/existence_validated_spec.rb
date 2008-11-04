require File.dirname(__FILE__) + '/spec_helper'

describe "existence_validated" do
  
  before(:all) do
    class Model < ActiveRecord::Base
      belongs_to :assoc
      validates_existence_of :assoc
    end
  end
  
  def valid_attributes(options={})
    {
      :name => "Name"
    }.update(existence_validated([:assoc], options)).update(options)
  end
  
  it "should not fail" do
    Model.create!(valid_attributes)
  end
end