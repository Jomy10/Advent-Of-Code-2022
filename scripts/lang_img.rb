require 'cairo'
require 'yaml'

# Canvas constants
W=750
H=150
S=25 # spacing
BAR_W=W-2*S
BAR_H=S
TEXT_SIZE=25
TEXT_S=TEXT_SIZE # text spacing
HOR_TEXT_S=15

# Drawing
surface = Cairo::ImageSurface.new(W, H)
ctx = Cairo::Context.new(surface)

ctx.set_source_rgb(255, 255, 255)
ctx.rectangle(S, S, BAR_W, BAR_H)
ctx.fill()

# fetch repo languages
languages = `github-linguist`.split("\n").map do |v|
  v = v.split(" ")
  [
    # v[0][0..v[0].size-2].to_f, # We will recompute percentages because we add C3 to the list
    v[1].to_i, # size
    v[2] # lang name
  ]
end
languages << [Dir.glob("**/*.c3").map { |filename| File.size filename }.sum, "C3"]
languages << [Dir.glob("**/*.noot").map { |filename| File.size filename }.sum, "Nootlang"]
total_language_size = languages.map { |lang| lang[0] }.sum.to_f
languages = languages
  .map { |lang| [lang[0] / total_language_size, lang[1]] } # Calculate percentage
  .sort_by { |v| v[0] }.reverse

# Fetch language colors
colors = YAML.load(`curl "https://raw.githubusercontent.com/github/linguist/712a1ee719675c98be4edd5337c71862c50c4e30/lib/linguist/languages.yml"`)

# Draw bar and text
ctx.select_font_face("Fira Sans", Cairo::FONT_SLANT_NORMAL, Cairo::FONT_WEIGHT_NORMAL)
ctx.set_font_size(TEXT_SIZE)
text_height = ctx.text_extents("H").height

barpos = S # hor pos
base_text_h = S + S + TEXT_S + 10
text_pos = S # hor pos
text_row = 0 # vert pos
languages.each do |lang|
  # set language color
  lang_info = colors[lang[1]]
  if lang_info.nil?
    case lang[1]
    when "C3"
      lang_info = {"color" => "#2A2A2A"}
    when "Nootlang"
      lang_info = {"color" => "#AD042E"}
    else
      puts "Language #{lang[1]} does not exist in github"
    end
  end
  color = lang_info["color"]
  # convert hex color to rgba array
  color = color[1..].chars.each_slice(2).map { |v| v.join("").hex / 255.0 }

  ctx.set_source_rgba(color[0], color[1], color[2])

  # Draw bar
  ctx.move_to 0, 0
  lang_w = BAR_W * lang[0]
  ctx.rectangle(barpos, S, lang_w, BAR_H)
  ctx.fill()
  barpos += lang_w

  # Draw text
  ext = ctx.text_extents lang[1]
  if text_pos + ext.width >= W - S
    text_pos = S
    text_row += 1
  end

  ctx.move_to text_pos, base_text_h + (text_height + TEXT_S) * text_row
  
  ctx.show_text lang[1]

  text_pos += ext.width + HOR_TEXT_S
end

ctx.target.write_to_png("assets/languages.png")
