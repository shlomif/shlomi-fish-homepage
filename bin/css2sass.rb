require 'rubygems'
require "sass/css"

puts Sass::CSS.new(IO.read(ARGV[0])).render(:sass);
