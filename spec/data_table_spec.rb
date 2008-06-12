require File.dirname(__FILE__) + '/spec_helper'

describe "a data_table" do
  
  uses_data_table
    
  it "should define a data_table method" do
    self.should respond_to(:data_table)
  end
  
  it "should have optional sorting" do
    data_table(:cars) do |table|
      table.sort_spec do |s|
        s.default 'make'
        s.option  'year', 'desc'
      end
    end
    @cars = data_table(:cars)
    @cars.should_not be_nil
    @cars.sort.should_not be_nil
    @cars.sort.options.should have_at_least(2).things
    @cars.filter.should be_nil
  end
  
  it "should have optional filtering" do
    data_table(:cars) do |table|
      table.filter_spec do |f|
        f.element(:color) do |e|
          e.default "All"
          e.option  "Blue"
          e.option  "Red"
          e.option  "Silver"
          e.option  "Black"
          e.option  "Other"
        end
      end
    end
    @cars = data_table(:cars)
    @cars.should_not be_nil
    @cars.filter.should_not be_nil
    @cars.filter.elements.should have_at_least(1).things
    @cars.sort.should be_nil
  end
  
  it "should provide options suitable for will_paginate integration"
  
  describe "fully specced" do
    before(:each) do
      data_table(:cars) do |table|
        table.sort_spec do |s|
          s.default 'make'
          s.option  'year', 'desc'
        end
        table.filter_spec do |f|
          f.element(:color) do |e|
            e.default "All"
            e.option  "Blue"
            e.option  "Red"
            e.option  "Silver"
            e.option  "Black"
            e.option  "Other"
          end
        end
      end
      @cars = data_table(:cars)
      @opts = opts = {:remote => {:url => '/cars/hottest_sellers', :update => 'hotBox'},
                            :with => [:tab] }
    end
    
    it "should be able to have sort and filter specifications" do
      @cars.should_not be_nil
      @cars.sort.should_not be_nil
      @cars.sort.options.should have_at_least(2).things
      @cars.filter.should_not be_nil
      @cars.filter.elements.should have_at_least(1).things
    end
    
    describe "with no additional parameters" do
            
      it "should be able to expose parameters that should be used by other libraries" do
        @cars.exposed_params.should == {}
      end
      
      it "should be able to store remote form submission parameters" do
        @cars.form_options = @opts
        @cars.form_options.should == @opts
      end

      it "should be able to generate a hash of all known form data, including full current state" do
        @cars.form_options = @opts
        @cars.all_options.should == @opts
      end

    end
    
    describe "when sorted" do
      before(:each) do
        @parms = {:cars => {:sort_key => "year", :sort => "asc"}}
        @sorted_cars = data_table(:cars).with(@parms)
      end
      
      it "should be able to expose parameters that should be used by other libraries" do
        @sorted_cars.exposed_params.should == @parms.flatten_one_level
      end

      
      it "should be able to store remote form submission parameters" do
        @sorted_cars.form_options = @opts
        @sorted_cars.form_options.should == @opts
      end

      it "should be able to generate a hash of all known form data, including full current state" do
        @sorted_cars.form_options = @opts
        @sorted_cars.all_options.should == @opts.merge(@parms.flatten_one_level)
      end
      
    end
    
    describe "when filtered" do
      before(:each) do
        @parms = {:cars => {:color => "blue"}}
        @filtered_cars = data_table(:cars).with(@parms)
      end
      
      it "should be able to expose parameters that should be used by other libraries" do
        @filtered_cars.exposed_params.should == @parms.flatten_one_level
      end

      
      it "should be able to store remote form submission parameters" do
        @filtered_cars.form_options = @opts
        @filtered_cars.form_options.should == @opts
      end

      it "should be able to generate a hash of all known form data, including full current state" do
        @filtered_cars.form_options = @opts
        @filtered_cars.all_options.should == @opts.merge(@parms.flatten_one_level)
      end
      
    end
    
    describe "when sorted and filtered" do
      before(:each) do
        @parms = {:cars => {:sort_key => "year", :sort => "asc", :color => "blue"}}
        @sorted_and_filtered_cars = data_table(:cars).with(@parms)
      end
      
      it "should be able to expose parameters that should be used by other libraries" do
        @sorted_and_filtered_cars.exposed_params.should == @parms.flatten_one_level
      end

      
      it "should be able to store remote form submission parameters" do
        @sorted_and_filtered_cars.form_options = @opts
        @sorted_and_filtered_cars.form_options.should == @opts
      end

      it "should be able to generate a hash of all known form data, including full current state" do
        @sorted_and_filtered_cars.form_options = @opts
        @sorted_and_filtered_cars.all_options.should == @opts.merge(@parms.flatten_one_level)
      end
      
    end
    
  end
  
end