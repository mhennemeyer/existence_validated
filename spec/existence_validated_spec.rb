require File.dirname(__FILE__) + '/spec_helper'

describe "existence_validated" do
  
  before(:all) do
    class Assoc < ActiveRecord::Base
    end
    class Model < ActiveRecord::Base
      belongs_to :assoc
    end
  end
  
  it "should not fail with no validates_existence declared in Model" do
    Model.create!
  end
  
  describe "with validates_existence declared in Model" do
    before(:each) do
      Model.instance_eval{validates_existence_of :assoc}
    end
    it "should fail without required assoc" do
      lambda{Model.create!}.should raise_error(/Assoc/)
    end
    
    it "should pass with required assoc" do
      Model.create! :assoc => Assoc.create!
    end
    
    describe "and calling existence_validated([:assoc])" do
      
      before(:each) do
        @mock = mock("Assoc", :id => 1)
        stub!(:mock_model).and_return(@mock)
      end
      
      it "should create an assoc mock_model" do
        should_receive(:mock_model).with(Assoc).and_return(@mock)
        existence_validated([:assoc])
      end
      
      it "should return a hash with assoc mock id and assoc mock" do
        existence_validated([:assoc]).should  == {
          :assoc_id => @mock.id,
          :assoc => @mock
        }
      end
      
      it "should satisfy validates_existence_of :assoc" do
        Model.create!(existence_validated([:assoc]))
      end
    end
  end
end