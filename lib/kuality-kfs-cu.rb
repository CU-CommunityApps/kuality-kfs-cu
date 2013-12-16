require 'kuality-kfs'

Dir["#{File.dirname(__FILE__)}/kuality-kfs-cu/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/kuality-kfs-cu/page_objects/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/kuality-kfs-cu/page_objects/*/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/kuality-kfs-cu/data_objects/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/kuality-kfs-cu/data_objects/*/*.rb"].alphabetize.each {|f| require f }
