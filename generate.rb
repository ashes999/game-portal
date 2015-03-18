#!/bin/ruby

require 'json'
# Primary structure: categories (in order) with games
# Each category is a hash (name, games)

categories = JSON.parse(File.read('data.json'))['categories']
MISSING_IMAGE_NAME = 'no-screenshot.png'

html = ''
categories.each do |c|
  html += "<h1>#{c['name']}</h1>\n"
  c['games'].each do |g|
    # Name: downcase, eliminate dots, turn spaces into hyphens, and append .png to get the image name
    name = g['name']
    url = g['url']
    image_name = "#{name.downcase.gsub(/[\.\"\']+/, '').gsub(' ', '-')}.png"
    if !File.exist?("images/#{image_name}")
      puts "Warning: Image '#{image_name}' is missing for '#{name}' (under '#{c['name']}')"
      image_name = MISSING_IMAGE_NAME
    end
    html += "<a href='#{url}' alt='#{name}'><img src='images/#{image_name}' /></a>\n"
  end
end

index_page = File.read('index.html')
index_page.sub!(/<body>.*<\/body>/imx, "<body>#{html}</body>")
File.write('index.html', index_page)

puts "Index.html regenerated."
