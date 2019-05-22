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
  result = `#{command}`
end

# Read in a given filename and return the whole thing
def read_file(filename)
  file_data = File.open(filename).read
  file.close
  return file_data
end

def download_all_matches(matches)
  i = 1
  matches.each do |match|
    puts "Downloading video #{i} of #{matches.length}"
    download_video(match, i)
    i += 1
  end
end

# Prompt user to download webpage
puts "Go to baseball savant search, and do the search you want. After clicking search, make sure to expand the result by clicking on the player. Right click -> save as a complete page with the default name. Press enter when done"
gets

# Read in the manually saved webpage
webpage = File.read('Statcast Search _ baseballsavant.com')

# Find matches and download them
matches = find_video_links(webpage)
download_all_matches(matches)

# Create text file for ffmpeg
text = ""
(1..matches.length).reverse_each do |x|
  text += "file 'vids/#{x}.mp4'\n"
end
ffmpegFile = File.open('files.txt', 'w') { |f| f.write(text) }

# Concatate with ffmpeg
result = `ffmpeg -f concat -i files.txt -c copy out.mp4`