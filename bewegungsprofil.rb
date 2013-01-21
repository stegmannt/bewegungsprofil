# encoding: utf-8

require 'exifr'
require 'googlestaticmap'

coordinates = []
olddir = Dir.pwd
images = []

module EXIFR
  class JPEG
    attr_accessor :filename
  end
end

Dir.chdir(ARGV[0])
Dir.glob("*.{jpg,jpeg,JPG,JPEG}") { |file|
				   image = EXIFR::JPEG.new(file)
                                  image.filename = file
                                  if image.exif? then
				      images << image
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
		  puts "#{i} #{image.filename}: created: #{image.date_time}, long. #{image.gps.longitude} lat. #{image.gps.latitude}"
                 location = MapLocation.new(:longitude => image.gps.longitude, :latitude => image.gps.latitude)
                 poly.points << location
                 map.markers << MapMarker.new(:location => location, :label => i)
                 i=i.succ
                 }
map.paths << poly
map.get_map("bewegungsprofil.jpg");

puts "Created movement profile: bewegungsprofil.jpg"
puts "\nUrl: #{map.url}"

