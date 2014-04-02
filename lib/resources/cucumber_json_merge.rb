#!/usr/bin/env ruby
#
# This script can be used to merge JSON files produced by the JSON output format
# used by Cucumber (or, probably, any JSON files, really).
# It allows you to split up your run using the parallel_tests gem, produce JSON
# results for each split, and recombine those result files into something the
# Cucumber Reports plugin will recognize.
#
# Example:
# parallel_cucumber features/ -o '-p parallel_master_no_nightly'
# cucumber_json_merge.rb -o ../kuality-kfs-cu-output.json ../kuality-kfs-cu-output.split*.json

require 'rubygems'
require 'optparse'
require 'json'

flags = {
  output:  %w('-o', '--output FILENAME'),
  verbose: %w('-v', '--verbose'),
  help:    %w('-h', '--help')
}
options = {}
options[:output_file] = 'kuality-kfs-cu-output.json'

opt_parser = OptionParser.new do |opt|

  opt.program_name = 'cucumber_json_merge.rb'
  opt.banner = 'Usage: cucumber_json_merge.rb [options] <file.json>...'
  opt.separator 'Options:'

  opt.on(*flags[:output], "output filename (default: ./#{options[:output_file]})") do |filename|
    if filename.empty? || flags.values.flatten.any? { |other_opt| filename == other_opt}
      puts "ERROR: Output filename flag (-o) specified, but no filename was provided!\n#{opt_parser}"
      exit 1
    end
    options[:output_file] = filename unless filename.nil?
  end

  opt.on(*flags[:verbose], 'print status info') do
    options[:verbose] = true
  end

  opt.on(*flags[:help], 'help') do
    puts opt
    exit 0
  end
end
opt_parser.parse!
if ARGV.empty?
  puts "ERROR: There are no filenames specified!\n#{opt_parser}"
  exit 1
end

File.open(options[:output_file], 'w') do |out_file|
  out_file.write(ARGV.collect { |in_file| JSON.parse(File.read(in_file)) }.flatten.to_json)
end
