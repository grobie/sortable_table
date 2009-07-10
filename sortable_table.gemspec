require 'rake'
spec = Gem::Specification.new do |s|
  s.version = '0.0.6'
  s.name = "sortable_table"
  s.summary = "Sort HTML tables in a Rails app."
  s.email = "dcroak@thoughtbot.com"
  s.homepage = "http://github.com/dancroak/sortable_table"
  s.description = "Sort HTML tables in a Rails app."
  s.authors = ["Dan Croak", "Joe Ferris", "Jon Yurek", "Boston.rb"]
  s.files = FileList["[A-Z]*", "{lib,rails}/**/*"]
end

