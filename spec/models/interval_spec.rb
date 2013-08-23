require 'spec_helper'

describe Interval do
  context "moving past the last week in the year" do
    subject(:interval) { Interval.new(2013, 52) }
    let(:new_interval) { interval.next }

    it "moves to the next year"  do
      expect(new_interval.year).to eq(2014)
    end

    it "moves to the first week" do
      expect(new_interval.week).to eq(1)
    end
  end

  context "moving before first week in the year" do
    subject(:interval) { Interval.new(2013, 1) }
    let(:new_interval) { interval.previous }

    it "moves to the next year"  do
      expect(new_interval.year).to eq(2012)
    end

    it "moves to the first week" do
      expect(new_interval.week).to eq(52)
    end
  end

  describe "#to_s" do
    subject(:interval) { Interval.new(2013, 5) }

    it "outputs leading zeros" do
      expect(interval.to_s).to eq("201305")
    end
  end
end
