require 'net/http'
require 'io/console'

# Parse the given html to find the video links
def find_video_links(webpageHTML)
  expression = /"(\/sporty-v.*?)" target/
  webpageHTML.scan expression
end

# Use youtube-dl to download a given url to a given filename in the vids subfolder
def download_video(url, name)
  command = "youtube-dl https://baseballsavant.mlb.com#{url[0]} -o vids/#{name}.mp4"
  result = `#{command}`
end

# Downloads the list of given URLs with youtbe-dl
def download_all_matches(matches)
  i = 1
  matches.each do |match|
    puts "Downloading video #{i} of #{matches.length} with url: https://baseballsavant.mlb.com#{match[0]}"
    download_video(match, i)
    i += 1
  end
end

# Expects date in the format 2019-05-11
def get_search_results(startDate, endDate)
  results = `bash get.sh #{startDate} #{endDate}`
  File.open("output").read
end

# Get the search results for the given dates
webpage = get_search_results("2019-05-05", "2019-05-11")

# Find matches and download them
matches = find_video_links(webpage)
if matches.length <= 1
  puts "ERROR, 0 matches found in request"
end
download_all_matches(matches)

# Create text file for ffmpeg
text = ""
(1..matches.length).reverse_each do |x|
  text += "file 'vids/#{x}.mp4'\n"
end
ffmpegFile = File.open('files.txt', 'w') { |f| f.write(text) }

# Concatate with ffmpeg
result = `ffmpeg -f concat -i files.txt -c copy out.mp4`