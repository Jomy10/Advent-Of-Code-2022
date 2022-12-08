#!/usr/bin/env ruby

require 'beaver'

SRC_DIR="src"
OUT_DIR="out"
CC="clang"
C_FLAGS="-g -Og"

command :build do
  $beaver.call :build_obj
  $beaver.call :build_exec
end

command :build_obj, src: "#{SRC_DIR}/**/*.c", target_dir: OUT_DIR, target_ext: ".o" do |src, target|
  sys "#{CC} #{C_FLAGS} #{src} -c -o #{target.gsub("src/", "")}"
end

command :build_exec, src: "#{OUT_DIR}/**/*.o", target: "#{OUT_DIR}/day8" do |srcs, target|
  sys "#{CC} #{C_FLAGS} #{srcs} -o #{target}"
end

command :run do
  $beaver.call :build
  sys "./#{OUT_DIR}/day8"
end

$beaver.end
