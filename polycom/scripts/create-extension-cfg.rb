#!/usr/bin/env ruby

require 'fileutils'

TEMPLATE = "xEXT.cfg.tmpl"
OWNER    = "PlcmSpIp"

#ARGV => name(ext)
unless ARGV.size == 1
 $stderr.puts "#{$PROGRAM_NAME} name(extension)"
  exit 1
end

name = ARGV.shift

data = File.read(TEMPLATE)
sub  = {}; sub = { :name => name }
regex = /(%%name%%)/
data.gsub!(regex) { |m| sub[m[2..-3].to_sym] }

file = "x#{name}.cfg"
File.open(file, "w") { |f| f.puts data }
FileUtils.chown(OWNER,OWNER, file)

=begin
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!-- Per-phone configuration in this file -->
<reginfo>
  <reg reg.1.displayName="%%name%%" 
   reg.1.address="%%name%%" 
   reg.1.label="%%name%%"
   reg.1.auth.userId="%%user%%" 
   reg.1.auth.password="PlcmSpIp"/>
</reginfo>
=end
