# @author Eric Weinstein <eric.q.weinstein@gmail.com>

require 'spec_helper'

describe Ruumba::Analyzer do
  let(:analyzer) { Ruumba::Analyzer.new }

  describe '#run' do
    it 'analyzes the provided ERB files' do
      allow(Kernel).to receive(:system).and_return('success')
      expect(analyzer).to receive(:system)

      analyzer.run(['foo'])
    end
  end

  describe '#extract' do
    it 'extracts one line of Ruby code from an ERB template' do
      one = "<%= puts 'Hello, world!' %>"
      allow(File).to receive(:read).with('one.erb') { one }

      expect(analyzer.extract('one.erb')).to eq("puts 'Hello, world!'")
    end

    it 'extracts many lines of Ruby code from an ERB template' do
      many = "<%= puts 'foo' %>\n<%= puts 'bar' %>\n<% baz %>"
      allow(File).to receive(:read).with('many.erb') { many }

      expect(analyzer.extract('many.erb')).to eq("puts 'foo'\nputs 'bar'\nbaz")
    end

    it 'extracts multiple interpolations per line' do
      multi = "<%= puts 'foo' %> then <% bar %>"
      allow(File).to receive(:read).with('multi.erb') { multi }

      expect(analyzer.extract('multi.erb')).to eq("puts 'foo'\nbar")
    end

    it 'does not extract code from lines without ERB interpolation' do
      none = "<h1>Dead or alive, you're coming with me.</h1>"
      allow(File).to receive(:read).with('none.erb') { none }

      expect(analyzer.extract('none.erb')).to eq('')
    end
  end
end
