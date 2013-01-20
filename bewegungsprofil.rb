# encoding: utf-8

require 'exifr'
require 'googlestaticmap'

coordinates = []
olddir = Dir.pwd
images = []

Dir.chdir(ARGV[0])
Dir.glob("*.{jpg,jpeg,JPG,JPEG}") { |file|
				   image = EXIFR::JPEG.new(file)
                                  if image.exif? then
				      images << image
				      puts "#{file}: Erstellt: #{image.date_time}, Long. #{image.gps.longitude} Lat. #{image.gps.latitude}"
                                  else
				      puts "#{file}: no exif information found"
                                  end
                                  }

Dir.chdir(olddir)

#sort by creation time
images.sort! {|x,y| x.date_time <=> y.date_time}

#create the static map
map = GoogleStaticMap.new(:maptype => "sattelite", :format => "jpg", :width => 1024, :height => 768, :scale => 2)
poly = MapPolygon.new(:color => "red")

i='A'
images.each { |image|
                   location = MapLocation.new(:longitude => image.gps.longitude, :latitude => image.gps.latitude)
                 poly.points << location
                 map.markers << MapMarker.new(:location => location, :label => i)
                 i=i.succ
                 }
map.paths << poly
map.get_map("bewegungsprofil.jpg");

puts "Created movement profile: bewegungsprofil.jpg"
puts "\nUrl: #{map.url}"

