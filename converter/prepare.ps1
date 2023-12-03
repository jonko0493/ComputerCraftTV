Param(
  [string]$videoFile,
  [string]$channelDir,
  [string]$channel
)

mkdir $channelDir/$channel/audio
mkdir $channelDir/$channel/img256
mkdir $channelDir/$channel/img512

ffmpeg -i "$videoFile" -vf "fps=10,crop=1440:1080:240:0,scale=512:384,subtitles='$videoFile':si=0" $channelDir/$channel/img512/%05d.png
ffmpeg -i "$videoFile" -vf "fps=10,crop=1440:1080:240:0,scale=256:192,subtitles='$videoFile':si=0" $channelDir/$channel/img256/%05d.png
ffmpeg -i "$videoFile" -vn -f segment -segment_time 0.1 $channelDir/$channel/audio/%05d.wav
Get-ChildItem $channelDir/$channel/audio/ | ForEach-Object { ffmpeg -i $_ -ac 1 "$_.dfpwm" }
Remove-Item $channelDir/$channel/audio/*.wav