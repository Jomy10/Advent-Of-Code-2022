# usage
# vide_to_gif [video_path] [name]

out_folder = "../assets"
name = ARGV[1]

# Convert mp4 to gifi
f=4
`ffmpeg -i "#{ARGV[0]}" -pix_fmt rgb24 -r #{f} "#{out_folder}/#{name}.gif"`
