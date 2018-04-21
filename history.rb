require 'pstore'
require 'date'

fail "usage: #{$0} add|del|get|list http://example.com/file.mp3 ..." if ARGV.size < 2

store = PStore.new 'history.pstore', true
mode = ARGV.shift
ARGV.each do |url|
  case mode
  when 'add'
    store.transaction { store[url] = DateTime.now.strftime '%s' }
  when 'del'
    store.transaction { store.delete url }
  when 'list' # all
    store.transaction { store.roots.each {|k| puts "#{k} #{store[k]}" } }
  else
    r = nil
    store.transaction(true) { r = store[url] }
    r ? puts(r) : exit(1)
  end
end
