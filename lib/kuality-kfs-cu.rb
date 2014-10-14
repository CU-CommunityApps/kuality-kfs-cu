require 'kuality-kfs'

spec = Gem::Specification.find_by_name('kuality-kfs')
gem_root = spec.gem_dir
Dir["#{gem_root}/features/step_definitions/**/*.rb"].alphabetize.each {|f| require f }

cwd = File.symlink?(__FILE__) ? File.dirname(File.readlink(__FILE__)) : File.dirname(__FILE__)
Dir["#{cwd}/kuality-kfs-cu/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/page_objects/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/page_objects/*/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/page_objects/*/*/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/page_objects/*/*/*/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/data_objects/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/data_objects/*/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/data_objects/*/*/*.rb"].alphabetize.each {|f| require f }
Dir["#{cwd}/kuality-kfs-cu/data_objects/*/*/*/*.rb"].alphabetize.each {|f| require f }