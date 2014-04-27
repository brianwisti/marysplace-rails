require 'spec_helper'
require 'pp'

describe PointsEntry do
  let (:points_entry) { create :points_entry }

  it "should have been added by a User" do
    entry = PointsEntry.create do |entry|
      entry.client            = points_entry.client
      entry.points_entry_type = points_entry.points_entry_type
      entry.points            = points_entry.points
      entry.performed_on      = points_entry.performed_on
    end

    expect(entry).to have(1).errors_on(:added_by_id)
  end

  it "should have a Location" do
    entry = PointsEntry.create do |entry|
      entry.client            = points_entry.client
      entry.added_by          = points_entry.added_by
      entry.points_entry_type = points_entry.points_entry_type
      entry.points            = points_entry.points
      entry.performed_on      = points_entry.performed_on
    end

    expect(entry).to have(1).errors_on(:location_id)
  end

  context "points multiple" do
    subject(:entry) { create :points_entry }
    it { should respond_to(:multiple) }
    it { should respond_to(:points_entered) }

    context "applied to a new entry" do
      subject(:entry) { build :points_entry }
      
      context  "when user ignores points_entered" do
        let(:points) { 100 }

        before do
          entry.points_entered = 0
          entry.points = points
          save_and_reload! entry
        end
        
        its(:points) { should eq(points) }
      end

      context "when user sets points_entered" do
        let(:points) { 75 }
        
        before do
          entry.points_entered = points
          entry.points = 0
          save_and_reload! entry
        end

        its(:points) { should eq(points) }
      end
      
      context "when multiple is set" do
        let(:points_entered) { 50 }
        let(:multiple) { 2 }
        let(:points) { points_entered * multiple }

        before do
          entry.update_attributes points: 0, multiple: 2, points_entered: 50
          save_and_reload! entry
        end
        
        its(:points) { should eq(points) }
      end

      context  "when user sets negative points_entered" do
        before do
          entry.update_attributes points: 0, multiple: 2, points_entered: -50
        end
        
        it { should have(1).errors_on(:multiple) }
      end
      
      context "negative multiples are not allowed" do
        before do
          entry.update_attributes points: 0, multiple: -2, points_entered: 50
        end

        it { should have(1).errors_on(:multiple) }
      end
    end
  end
    
  context "daily_count" do
    subject { PointsEntry }

    it { should respond_to(:daily_count) }

    context "starts at zero" do

      its(:daily_count) { should eq(0) }
    end

    context "registers new PointsEntry" do
      before { create :points_entry }
      its(:daily_count) { should eq(1) }
    end
  end
end
