require 'kuality-kfs'

cwd = File.symlink?(__FILE__) ? File.dirname(File.readlink(__FILE__)) : File.dirname(__FILE__)
Dir["#{cwd}/kuality-kfs-cu/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/page_objects/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/page_objects/*/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/data_objects/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/data_objects/*/*.rb"].alphabetize.each {|f| require f }