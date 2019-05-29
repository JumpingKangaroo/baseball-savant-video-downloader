require 'net/http'
require 'io/console'
require 'fileutils'

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

# Expects dates in the format 2019-05-11 and a playerID
def get_search_results(startDate, endDate, playerID, isLastPitch)
  flag = isLastPitch ? "is\\.\\.last\\.\\.pitch|" : ""
  results = `bash get.sh #{startDate} #{endDate} #{playerID} #{flag}`
  File.open("output") do |f|
    vals = f.read
    f.close
    return vals
  end
end

# Cleans up vids/ output and files.txt files after operations are complete
def cleanup_leftover_files()
  FileUtils.rm_rf('vids/')
  File.delete('files.txt') if File.exist?('files.txt')
  File.delete('output') if File.exist?('output')
end

# Expects date arguments in the format 2019-05-11
startDate = ARGV[0]
endDate = ARGV[1]

# Third argument of playerID
playerID = ARGV[2]

isLastPitch = ARGV[3].downcase == "true" ? ARGV[3] : false


# Get the search results for the given dates
webpage = get_search_results(startDate, endDate, playerID, isLastPitch)

# Find matches and download them
matches = find_video_links(webpage)
if matches.length <= 1
  puts "ERROR, 0 matches found in request"
  cleanup_leftover_files()
  exit
end
download_all_matches(matches)

# Create text file for ffmpeg
text = ""
(1..matches.length).reverse_each do |x|
  text += "file 'vids/#{x}.mp4'\n"
end
ffmpegFile = File.open('files.txt', 'w') { |f| f.write(text) }
ffmpegFile.close

# Concatate with ffmpeg
result = `ffmpeg -f concat -i files.txt -c copy out.mp4`

# Clean up files
cleanup_leftover_files()