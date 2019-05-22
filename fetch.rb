require 'net/http'
require 'io/console'

# Parse the given html to find the video links
def find_video_links(webpageHTML)
  expression = /(https:\/\/baseballsavant.mlb.com\/sporty-videos.*?)" target="/
  webpageHTML.scan expression
end

# Use youtube-dl to download a given url to a given filename in the vids subfolder
def download_video(url, name)
  command = "youtube-dl #{url[0]} -o vids/#{name}.mp4"
  puts command
  result = `#{command}`
end

# Read in a given filename and return the whole thing
def read_file(filename)
  file_data = File.open(filename).read
  file.close
  return file_data
end

# Date format: 2019-05-05
startingDate = '2019-05-05'
endingDate = '2019-05-11'
searchURL = "https://baseballsavant.mlb.com/statcast_search?hfPT=&hfAB=&hfBBT=&hfPR=&hfZ=&stadium=&hfBBL=&hfNewZones=&hfGT=R|&hfC=&hfSea=2019|&hfSit=&player_type=batter&hfOuts=&opponent=&pitcher_throws=&batter_stands=&hfSA=&game_date_gt=#{startingDate}&game_date_lt=#{endingDate}&hfInfield=&team=&position=&hfOutfield=&hfRO=&home_road=&batters_lookup[]=545361&hfFlag=is\.\.last\.\.pitch|&hfPull=&metric_1=&hfInn=&min_pitches=0&min_results=0&group_by=name&sort_col=pitches&player_event_sort=h_launch_speed&sort_order=desc&min_pas=0#results"

webpage = File.read('Statcast Search _ baseballsavant.com')

matches = find_video_links webpage
puts "total instances: " + matches.length.to_s
i = 1
matches.each do |match|
  download_video(match, i)
  i += 1
end


