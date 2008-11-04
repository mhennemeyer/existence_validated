require File.dirname(__FILE__) + '/spec_helper'

describe "existence_validated" do
  
  before(:all) do
    class Assoc < ActiveRecord::Base
    end
    class Model < ActiveRecord::Base
      belongs_to :assoc
    end
  end
  
  def valid_attributes(options={})
    {
      :name => "Name"
    }.update(existence_validated([:assoc], options)).update(options)
  end
  
  it "should not fail " do
    Model.create!(valid_attributes)
  end
end