#encoding:UTF-8

require_relative 'test.rb'

#=begin
puts "Please input the size and min supported"
size = gets.chomp
size = size.to_i
supported = gets.chomp
supported = supported.to_i
a = Apriori.new(size,supported)
a.getItem

a.find_freitem
