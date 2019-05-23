## Baseball Savant Video Downloader

This downloads the last pitch of every at bat for a given player in the given date range. The videos will get concatenated into one "out.mp4".
### Requirements
This requires ruby and youtube-dl to be installed. As of now, it requires linux because the downloader uses a bash script. 

### How To Use
To run, do:
```
  $ ruby fetch.rb <startDate> <endDate> <playerID>
```
where startDate and endDate is the range of videos you are looking for in the format YEAR-MONTH-DAY (2019-05-11)
Player ID is the 6-digit identifier for a player. It can be found in the csv on [this](http://crunchtimebaseball.com/baseball_map.html) website. 
An example command to find the at bats of Mike Trout between 5/5 and 5/11:
```
  $ ruby fetch.rb 2019-05-05 2019-05-11 545361`
```
