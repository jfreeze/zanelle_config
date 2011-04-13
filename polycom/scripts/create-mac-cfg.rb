#!/usr/bin/env ruby

require 'fileutils'

TEMPLATE = "000000000000.cfg.tmpl"
OWNER    = "PlcmSpIp"

#ARGV => name(ext) office
unless ARGV.size == 3
 $stderr.puts "#{$PROGRAM_NAME} mac name(extension) office"
  exit 1
end

mac, name, office = ARGV
mac = mac.downcase

data = File.read(TEMPLATE)
sub  = {}; sub = { :mac => mac, :name => name, :office => office }
regex = /(%%name%%|%%office%%)/
data.gsub!(regex) { |m| sub[m[2..-3].to_sym] }

file = "#{mac}.cfg"
File.open(file, "w") { |f| f.puts data }
FileUtils.chown(OWNER,OWNER, file)

