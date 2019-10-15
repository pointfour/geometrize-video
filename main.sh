mkdir raw
mkdir out
mkdir processed
ffmpeg -i bucket.mp4 raw/out%04d.jpg
ffmpeg -i bucket.mp4 audio.mp3
sips -Z 240 raw/*.jpg
for file in raw/*
do 
  name=$(basename "$file" ".jpg")
  ./geo -i "$file" -o out/"$name".svg -t triangle -s 100
done
rm -rf raw
for file in out/*
do 
  # inkscape -z -e processed/"$count".png -w 1024 -h 1024 "$file"
  name=$(basename "$file" ".svg")
  svgexport "$file" processed/"$name".png 1920:1080
done
rm -rf out
# ffmpeg -framerate 30 -pattern_type glob -i 'processed/*.png' -c:v libx264 -r 30 -pix_fmt yuv420p out.mp4
ffmpeg -framerate 30 -pattern_type glob -i 'processed/*.png' -i bucket.mp4 \
  -c:a copy -shortest -c:v libx264 -r 30 -pix_fmt yuv420p out.mp4
rm -rf processed