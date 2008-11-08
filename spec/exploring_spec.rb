require File.dirname(__FILE__) + '/spec_helper'

describe "Explore validates_existence_of" do
  before(:all) do
    class Assoc < ActiveRecord::Base
    end
    class Model < ActiveRecord::Base
      belongs_to :assoc
      validates_existence_of :assoc
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
  it "should not call Assoc.exists?(nil)" do
    Assoc.should_not_receive(:exists?).with(nil)
    Model.create!(existence_validated(:assoc))
  end
  
  describe "with 2 associates" do
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
    it "should not call Assoc.exists?(nil)" do
      Assoc.should_not_receive(:exists?).with(nil)
      Model.create!(existence_validated([:assoc, :other_assoc]))
    end
    it "should not call Assoc.exists?(nil) [2]" do
      #Assoc.should_not_receive(:exists?).with(nil)
      lambda {Model.create!(existence_validated([:assoc, :other_assoc], :other_assoc => nil))}.should raise_error(%r(Other assoc does not exist))
    end
  end
end