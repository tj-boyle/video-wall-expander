#!/usr/bin/ruby
#Run this ruby script with the first argument being a string of what videos you want to play. 
#All other arguments are each videos length, in seconds, in order.
#Example being - ruby vlcfs.rb "Intro.mp4 INK_Drops_4k.mp4" 17 183
#IF there is only one video to be played, then the argument with the number of seconds is not necessary
 
#Function to make the video fullscreen across all 4 screens
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
 
#Argument checking
if ARGV.length == 0
        puts "ERROR: MUST HAVE ARGUMENTS"
        exit
#If there is only one argument, then there should only be one video, so it plays the video and runs the make_fullscreen function
elsif ARGV.length == 1
        system("bash -c 'DISPLAY=:0 vlc #{ARGV[0]}  --extraintf http &> /dev/null &' &")
        make_fullscreen
#If there are multiple arguments, does the following
else
        num_videos = ARGV.length - 1
        #Begins VLC
        system("bash -c 'DISPLAY=:0 vlc #{ARGV[0]}  --extraintf http &> /dev/null &' &")
        #Does the following for the number of videos in playlist
        1.upto(ARGV.length - 1) do |x|
                ARGV[x] = ARGV[x].to_i
                sleep(3)
                #Makes the video fullscreen, and sleeps for the duration of the video
                make_fullscreen
                sleep(ARGV[x])
                 
                #If it is the last video being played, it will close vlc once done sleeping, and exit program
                if x == (ARGV.length - 1)
                        system("bash -c 'rm /home/user/VLC/index*'")
                        system("pkill vlc")
                        exit 1
                 
                #Else, it will do the following
                else
                        #If its a udp stream, it needs to manually be told to go to the next object in playlist, so it does so here
                        if ARGV[0].include? "udp://"
                                system("bash -c 'DISPLAY=:0 wget http://127.0.0.1:8080/?control=next'")
                        end
                        #Because VLC messes with windows when switching videos in playlists, 
			#it needs to be told to toggle fullscreen (which it does here), and then be put back into fullscreen
                        system("bash -c 'DISPLAY=:0 wget http://127.0.0.1:8080/?control=fullscreen'")
                end
        end
end
