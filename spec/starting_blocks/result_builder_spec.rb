require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::ResultBuilder do

  let(:parsed_output) { {} }
  let(:text)          { Object.new }
  let(:success)       { Object.new }
  let(:exit_code)     { Object.new }

  let(:output) do
    text_parser = Object.new
    input       = { 
                    text: text,
                    success: success,
                    exit_code: exit_code,
                  }

    StartingBlocks::TextParser.stubs(:new).returns text_parser
    text_parser.stubs(:parse).returns parsed_output

    StartingBlocks::ResultBuilder.new.build_from input
  end


  describe "returning results from the text parser" do

    it "should return the data from the text parser" do
      key, value         = Object.new, Object.new
      parsed_output[key] = value
      output[key].must_be_same_as value
    end

    it "should return the text as the text" do
      output[:text].must_be_same_as text
    end

    it "should return the success flag" do
      output[:success].must_be_same_as success
    end

    it "should return the exit code" do
      output[:exit_code].must_be_same_as exit_code
    end

  end

  describe "different output scenarios" do

    [:tests, :skips].to_objects {[
      [9, 1], [10, 2], [10, 3]
    ]}.each do |test|
      describe "yellow" do
        it "should have tests and skips" do
          parsed_output[:tests] = test.tests
          parsed_output[:skips] = test.skips
          output[:color].must_equal :yellow
        end
      end
    end

    [:tests, :failures, :errors, :skips].to_objects {[
      [1, 1,   nil, nil],
      [2, nil, 1,   nil],
      [3, nil, 2,   0],
      [4, 3,   nil, 0],
    ]}.each do |test|
      describe "red" do
        it "should return red" do
          parsed_output[:tests]    = test.tests
          parsed_output[:failures] = test.failures
          parsed_output[:errors]   = test.errors
          parsed_output[:skips]    = test.skips
          output[:color].must_equal :red
        end
      end
    end

    [:tests, :failures, :errors, :skips].to_objects {[
      [1, nil, nil, nil],
      [2, 0,   nil, nil],
      [3, nil, 0,   nil],
      [4, nil, nil, 0],
    ]}.each do |test|

      describe "green" do
        it "should set the color to red if there are tests and failures" do
          parsed_output[:tests]    = test.tests
          parsed_output[:failures] = test.failures
          parsed_output[:errors]   = test.errors
          parsed_output[:skips]    = test.skips
          output[:color].must_equal :green
        end
      end

    end

  end

end
