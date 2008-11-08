require File.dirname(__FILE__) + '/spec_helper'

describe "existence_validated" do
  
  before(:all) do
    class Assoc < ActiveRecord::Base
    end
    class Model < ActiveRecord::Base
      belongs_to :assoc
    end
    unless Model.table_exists?
      ActiveRecord::Migration.create_table :models do |t|
        t.integer :assoc_id
        t.string :name
      end
    end
    unless Assoc.table_exists?
      ActiveRecord::Migration.create_table :assocs do |t|
      end
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
        @mock = mock_model(Assoc)
        stub!(:mock_model).and_return(@mock)
      end
      
      it "should create an assoc mock_model" do
        should_receive(:mock_model).with(Assoc).and_return(@mock)
        existence_validated([:assoc])
      end
      
      it "should stub calls to Model.find with mock_id and return the mock" do
        existence_validated(:assoc)
        Assoc.find(@mock.id).should eql(@mock)
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
      
      it "should work with a single argument" do
        Model.create!(existence_validated(:assoc))
      end
      
      it "should not persist" do
        existence_validated(:assoc)
        lambda {Model.create!}.should raise_error
      end
      
      describe "with options" do
        it "should not create a mock if one is passed" do
          should_not_receive(:mock_model)
          existence_validated([:assoc], :assoc => @mock)[:assoc].should == @mock
        end
        
        describe ":assoc => nil" do
          it "should not create a mock and not return an assoc_id" do
            should_not_receive(:mock_model)
            return_value = existence_validated([:assoc], :assoc => nil)
            return_value[:assoc].should be_nil
            return_value[:assoc_id].should be_nil
          end
        end
        
      end
    end
  
    describe "and another assoc: OtherAssoc" do
      before(:all) do
        class OtherAssoc < ActiveRecord::Base
        end
        unless OtherAssoc.table_exists?
          ActiveRecord::Migration.create_table :other_assocs do |t|
          end
        end
        Model.instance_eval do 
          belongs_to :other_assoc
          validates_existence_of :other_assoc
        end
      end
      
      it "should fail if one of the required associations is not in place[1]" do
        lambda{Model.create!(existence_validated([:other_assoc]))}.should raise_error(/Assoc/)
      end
      
      it "should fail if one of the required associations is not in place[2]" do
        lambda{Model.create!(existence_validated([:assoc]))}.should raise_error(/Other/)
      end
      
      
      
      describe "existence_validated([:assocs, :other_assoc])" do
        
        it "should return ids and mocks" do
          return_value = existence_validated([:assoc, :other_assoc])
          return_value[:assoc].class.should == Assoc
          return_value[:other_assoc].class.should == OtherAssoc
          return_value[:other_assoc_id].should be_close(1000,30)
          return_value[:assoc_id].should be_close(1000,30)
        end
        
        it "should not fail if both required assocs are provided" do
          Model.create!(existence_validated([:assoc, :other_assoc]))
        end
        
        it "should fail if both required assocs are provided, but one is nilified in the options[1]" do
          lambda {Model.create!(existence_validated([:assoc, :other_assoc], :assoc => nil))}.should raise_error(/Assoc/)
        end
        
        it "should fail if both required assocs are provided, but one is nilified in the options[2]" do
          lambda {Model.create!(existence_validated([:assoc, :other_assoc], :other_assoc => nil))}.should raise_error(/Other/)
        end
        
        it "should not fail if both required assocs are provided, but one is specified in the options[1]" do
          Model.create!(existence_validated([:assoc, :other_assoc], :other_assoc => mock_model(OtherAssoc)))
        end
        
        it "should not fail if both required assocs are provided, but one is specified in the options[2]" do
          Model.create!(existence_validated([:assoc, :other_assoc], :assoc => mock_model(Assoc)))
        end
        
        it "should work any number of times" do
          model = Model.create!(existence_validated([:assoc, :other_assoc]))
          model.should be_valid
          model.should be_valid
        end
        
        it "should work with before_save callback" do
          Model.instance_eval {before_save {puts "Hello Horst"}}
          Model.create!(existence_validated([:assoc, :other_assoc]))
        end
      end
    end
  end


end