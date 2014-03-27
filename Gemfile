source 'https://rubygems.org'

group :test do
  gem 'chef', '>= 11.4.4'
  gem 'minitest'
  gem 'flog'
  gem 'rake'
  gem 'reek', '>= 1.3.1'
  gem 'rubocop'
  gem 'coveralls', require: false
end

group :integration do
  gem 'test-kitchen', git: 'git://github.com/opscode/test-kitchen.git', branch: 'master'
  gem 'busser'
  gem 'busser-minitest'
  gem 'kitchen-vagrant'
  gem 'vagrant-berkshelf'
end

group :generate_resources do
  gem 'bluecloth'
  gem 'cabin'
  gem 'stud'
end
