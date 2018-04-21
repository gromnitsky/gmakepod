require 'pstore'

# input: media/foo.m4a!http://example.com/file.m4a!.mp3
while (line = gets)
  _name, url, _ext = line.split '!'
  puts line if `ruby #{ENV['mk.root']}/history.rb get "#{url}"` == ""
end
