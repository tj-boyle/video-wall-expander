#!/usr/bin/ruby

def make_fullscreen()	
	#creates a list of VLC windows, and grabs only their index numbers
	wmgrlist = %x"bash -c 'DISPLAY=:0 wmctrl -l'"
	puts wmgrlist
	wmgrs = wmgrlist.split(/\n/)
	wmgrs.delete_if{|x| !x.include? "VLC"}
	wmgrs.map! do |x|
	   x[0, 10]
	end
	 
	#For each of the non main VLC windows, move to their appropriate location
	system("bash -c 'DISPLAY=:0 wmctrl -i -r " + wmgrs[1] + " -e 0,1080,0,1920,1080'")
	system("bash -c 'DISPLAY=:0 wmctrl -i -r " + wmgrs[2] + " -e 0,0,1100,1920,1080'")
	system("bash -c 'DISPLAY=:0 wmctrl -i -r " + wmgrs[3] + " -e 0,1080,1100,1920,1080'")
	 
	 
	#Calls the main VLC window and makes it fullscreen
	system("bash -c 'DISPLAY=:0 wget http://127.0.0.1:8080/?control=fullscreen'")	
end

if ARGV.length == 0
	puts "ERROR: MUST HAVE ARGUMENTS"
	exit
elsif ARGV.length == 1	
	system("bash -c 'DISPLAY=:0 wget http://127.0.0.1:8080/?control=fullscreen'")
	make_fullscreen
else
	num_videos = ARGV.length - 1 
	system("bash -c 'DISPLAY=:0 vlc #{ARGV[0]}  --extraintf http &> /dev/null &' &")
	1.upto(ARGV.length - 1) do |x|
		ARGV[x] = ARGV[x].to_i
		sleep(3)
		make_fullscreen
		sleep(ARGV[x])

		if x == (ARGV.length - 1)
			system("bash -c 'rm /home/user/VLC/index*'")
			system("pkill vlc")
			exit 1
		else
			if ARGV[0].include? "udp://"
				system("bash -c 'DISPLAY=:0 wget http://127.0.0.1:8080/?control=next'")
			end
			system("bash -c 'DISPLAY=:0 wget http://127.0.0.1:8080/?control=fullscreen'")
		end	
	end
end
