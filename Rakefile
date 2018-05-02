require 'rake/testtask'

task default: Rake::TestTask.new.name

desc 'start http server'
task(:server) { sh 'ruby -run -ehttpd . -p8000' }
