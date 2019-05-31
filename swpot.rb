module Network_pb
class Honeypot_pb
def initialize()

require "socket"

puts ""
title "*******___SHAWPOT___*******"
puts ""
warning "C3i Shawpot should be run with root privilages.\n"
puts ""
puts " Select option."
puts ""
puts "1- Setup Honeypot"
puts "2- Setup Honeypot with advanced option"
puts ""
print "-> "
configuration = gets_pb.chomp

def honeyconfig(port, msgOf, isfile, sound, log, logname) 
	begin
		tcpserver = TCPServer.new("", port)
		if tcpserver
			puts ""
			puts "  HONEYPOT ACTIVATED ON PORT #{port} (#{Time.now.to_s})"
			puts ""
			if log == "y" || log == "Y"

				begin
					File.open(logname, "a") do |logf|
						logf.puts "#################### PenTBox Honeypot log"
						logf.puts ""
						logf.puts "  HONEYPOT ACTIVATED ON PORT #{port} (#{Time.now.to_s})"
						logf.puts ""
					end
				rescue Errno::ENOENT
					puts ""
					puts " Saving log error: No such file or directory."
					puts ""
				end
			end
			loop do
				socket = tcpserver.accept
				sleep(1) 
				if socket
					Thread.new do
						remotePort, remoteIp = Socket.unpack_sockaddr_in(socket.getpeername) 
						puts ""
						puts "  INTRUSION ATTEMPT DETECTED! from #{remoteIp}:#{remotePort} (#{Time.now.to_s})"
						puts " -----------------------------"
						reciv = socket.recv(1000).to_s
						puts reciv
						if sound == "y" || sound == "Y"
							puts "\a\a\a"
						end
						if log == "y" || log == "Y"
							begin
								File.open(logname, "a") do |logf|
									logf.puts ""
									logf.puts "  INTRUSION ATTEMPT DETECTED! from #{remoteIp}:#{remotePort} (#{Time.now.to_s})"
									logf.puts " -----------------------------"
									logf.puts reciv
								end
							rescue Errno::ENOENT
								puts ""
								puts " Saving log error: No such file or directory."
								puts ""
							end
						end
						sleep(2) 
						if isfile == "y" || isfile == "Y"
							f = File.read(msgOf)
							socket.write(f)
						else
							socket.write(msgOf)
						end
						socket.close
					end
				end
			end
		end
	rescue Errno::EACCES
		puts ""
		puts " Error: Honeypot requires root privileges."
		puts ""
	rescue Errno::EADDRINUSE
		puts ""
		puts " Error: Port in use."
		puts ""
	rescue
		puts ""
		puts " Unknown error."
		puts ""
	end
end

case configuration
	when "1"
			honeyconfig(80, "index.html","Y", "N", "N", "")
	when "2"
		puts ""
		puts " Insert port to Open."
		puts ""
		print "   -> "
		port = gets_pb.chomp
		puts ""
		puts " Insert false message/file name to show (File only works for port 80)."
		puts ""
		print "   -> "
		message = gets_pb.chomp
		puts ""
		puts " Is the above input file?"
		puts ""
		print " (y/n)   -> "
		fl = gets_pb.chomp
		puts ""
		puts " Save a log with intrusions?"
		puts ""
		print " (y/n)   -> "
		log = gets_pb.chomp
		if log == "Y" || log == "y"
			puts ""
			puts " Log file name? (incremental)"
			puts ""
			puts "Default: */pentbox/other/log_honeypot.txt"
			puts ""
			print "   -> "
			logname = gets_pb.chomp.gsub("\"", "").gsub("'", "")
			if logname == ""
				logname = "#{File.dirname(__FILE__)}/../../other/log_honeypot.txt"
			end
		end
		puts ""
		puts " Activate beep() sound when intrusion?"
		puts ""
		print " (y/n)   -> "
		sound = gets_pb.chomp
		honeyconfig(port, message, fl, sound, log, logname)
	else
		puts ""
		puts "Invalid option."
		puts ""
end

end
end
end
