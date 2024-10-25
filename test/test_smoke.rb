require 'open3'
require 'test/unit'

$data = "#{__dir__}/data"
$src  = File.absolute_path "#{__dir__}/.."

ENV['GMAKEPOD_TEST_SECURERANDOM'] = '123456'
$make = ENV['GMAKEPOD_MAKE'] || 'make'
ENV['GMAKEPOD_TEST_HISTORY'] = "#{__dir__}/smoke.history.txt"

def feeds; File.read("#{__dir__}/smoke.feeds") % ([$data]*4); end
def enclosures; File.read "#{__dir__}/smoke.enclosures"; end
def files; File.read "#{__dir__}/smoke.files"; end
def files_new; File.read "#{__dir__}/smoke.files.new"; end
def download_mk; File.read("#{__dir__}/smoke.download.mk").sub('__src__', $src); end
def download_j1_mk; File.read("#{__dir__}/smoke.download_j1.mk").sub('__src__', $src); end

class Smoke < Test::Unit::TestCase
  # ruby ../ini-parse.rb data/subscriptions.ini.erb | sed 's|/home/alex/lib/software/alex/gmakepod/test/data|%s|'> smoke.feeds
  def test_feeds
    assert_equal `ruby #{$src}/ini-parse.rb #{$data}/subscriptions.ini.erb`, feeds
  end

  # sed 's|%s|/home/alex/lib/software/alex/gmakepod/test/data|' smoke.feeds | xargs make -f ../feed-parse.mk
  def test_feed_parse_mk
    props, log = Open3.capture3 "xargs #{$make} -f #{$src}/feed-parse.mk", stdin_data: feeds
    assert_equal log.split("\n")[0..4], ["Processing test_", "Processing Photography", "Processing Ruby_Rogues", "Processing Stack_Overflow", "Processing invalid"]
    assert_equal props, enclosures
  end

  # GMAKEPOD_TEST_SECURERANDOM=123456 xargs ruby ../enclosures-print.rb < smoke.enclosures
  def test_enclosures_print_rb
    props, _ = Open3.capture3 "xargs ruby #{$src}/enclosures-print.rb", stdin_data: enclosures
    assert_equal props, files
  end

  # GMAKEPOD_TEST_HISTORY=smoke.history.txt xargs make -f ../enclosures-reject.mk < smoke.files
  def test_enclosures_reject_mk
    props, _ = Open3.capture3 "xargs #{$make} -f #{$src}/enclosures-reject.mk", stdin_data: files
    assert_equal props, files_new
  end

  def test_downloads_mk
    props, _ = Open3.capture3 "xargs #{$make} j=1 -f #{$src}/generate.mk", stdin_data: files_new
    assert_equal props, download_j1_mk

    props, _ = Open3.capture3 "xargs #{$make} -f #{$src}/generate.mk", stdin_data: files_new
    assert_equal props, download_mk
  end
end
