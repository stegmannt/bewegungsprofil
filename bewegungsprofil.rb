# encoding: utf-8

require 'exifr'

Dir.chdir(ARGV[0])
Dir.glob("*.{jpg,jpeg,JPG,JPEG}") { |file|
					image = EXIFR::JPEG.new(file)
                                  if image.exif? then
				      puts "#{file}: Erstellt: #{image.date_time}, Long. #{image.gps.longitude} Lat. #{image.gps.latitude}"
                                  else
				      puts "#{file}: no exif information found"
                                  end
                                  }

