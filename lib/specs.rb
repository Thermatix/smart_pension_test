# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'

require_relative 'log_parser.rb'

describe Log_Parser do
  subject { Log_Parser.new(log_file_path, args) }
  let(:log_file_path) { 'webserver.log' }
  let(:args) { {} }

  describe '#execute' do
    it 'will iterate over the file line by line'
    it 'will add each path to @paths'
  end

  describe '#add_path_to' do
    let(:path) { '/home' }
    let(:ip) { '184.123.665.067' }

    before do
      subject.send(:add_path_to, subject.paths[path], ip)
    end

    it 'will add a key/value to the @paths hash with the key being the path' do
      subject.paths.keys.must_equal [path]
    end

    it "will increase a path's `:total` value in @paths hash" do
      subject.paths[path][:total].must_equal 1
    end

    it 'will push a path into `:unique` array in @paths hash' do
      subject.paths[path][:unique].keys.must_equal [ip]
    end

    it 'will increase @stats `:total` value' do
      subject.stats[:total].must_equal 1
    end

    it 'will push a path into `:unique` array in @stats' do
      subject.stats[:unique].keys.must_equal [ip]
    end
  end

  describe '#to_s' do
    let(:path) { '/home' }
    let(:ip) { '184.123.665.067' }

    before do
      subject.send(:add_path_to, subject.paths['/home'], '184.123.665.067')
      subject.send(:add_path_to, subject.paths['/home'], '184.123.665.067')
      subject.send(:add_path_to, subject.paths['/about'], '184.123.665.067')
    end

    it 'will return a string containing total paths and  total unique views' do
      subject.to_s.must_equal 'Total: 3, Unique: 1'
    end

    describe 'with most flag' do
      let(:args) { { 'm' => nil } }
      it 'will return a stringified list of all paths and there total visits' do
        subject.to_s
               .must_equal "/home 2 visit(s)\n/about 1 visit(s)"
      end
    end

    describe 'with unique flag' do
      let(:args) { { 'u' => nil } }
      it 'will return a stringified list of all paths and there unique views' do
        subject.to_s
               .must_equal "/home 1 unique view(s)\n/about 1 unique view(s)"
      end
    end
  end

  describe '#sort' do
    let(:left_is_smaller) { -1 }
    let(:left_is_larger) { 1 }

    it 'will sort by descending order' do
      subject.send(:sort, 1, 2).must_equal left_is_larger
    end
    describe 'with inverse flag' do
      let(:args) { { 'i' => nil } }

      it 'will sort by acending order' do
        subject.send(:sort, 1, 2).must_equal left_is_smaller
      end
    end
  end
end
