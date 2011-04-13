#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'

def nmap_polycom_command(ip_24)
  "nmap -p 5060 #{ip_24}.1-255"
end

def ip_24(eth="eth0")
  # eth0      Link encap:Ethernet  HWaddr 00:E0:4D:C4:52:15  
  #          inet addr:192.168.0.50  Bcast:192.168.0.255  Mask:255.255.255.0
  data  = `ifconfig #{eth}`
  m     = /inet addr:(\d+)\.(\d+)\.(\d+)\.(\d+)/.match(data)
  "#{m[1]}.#{m[2]}.#{m[3]}"
end

def get_ips(eth="eth0")
  cmd = nmap_polycom_command(ip_24)
  parse_nmap(`#{cmd}`)
end

def format_mac(mac)
  mac.split(/:/).join.downcase
end

def extract_phone_data(lines)
  # Interesting ports on 192.168.0.107:
  # PORT     STATE SERVICE
  # 5060/tcp open  sip
  # MAC Address: 00:04:F2:24:5B:04 (Polycom)
  return if lines.nil? || lines.empty?
  return nil unless /\(Polycom\)/ =~ lines.last
  ip  = /(\d+\.\d+\.\d+\.\d+)/.match(lines.first)[1]
  mac = /([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2})/.match(lines.last)[1]
  [format_mac(mac), ip]
end

def parse_nmap(data)
  devices = data.split(/\n\n/)
  devices.map! { |item| 
    a = item.split(/\n/).map do |line|
      /^(Interesting|PORT|506|MAC)/ =~ line ? line : nil
    end
    a.compact!
    a
  }
  devices.collect! { |device| extract_phone_data(device) }
  devices.map! { |device| device.nil? || device.empty? ? nil : device }
  devices.compact!
  
  devices
end

def find_mac_ext(mac)
  file = File.read("#{mac}.cfg")
  x = /(x\d\d\d)\.cfg/.match(file)
  x[1]
  rescue
  "none"
end

mac_ext = {}
phones = get_ips
phones.each { |mac, ip| mac_ext[mac] = [find_mac_ext(mac), ip] }
puts mac_ext.to_yaml
mac_ext.to_a.sort_by { |a| a[1][0] }.each { |row|
  puts "#{row[1][0]}\t#{row[1][1]}\t#{row[0]}"
}
