require 'spec_helper'
require 'zeitwerk'
require 'faker'
require 'uuidtools'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../src")
loader.setup

RSpec.configure do |config|
  Dir[File.join(__dir__, 'unit/**/*.rb')]
    .reject { |f| f =~ /_spec\.rb$/ }
    .sort
    .each { |f| require f }
end
