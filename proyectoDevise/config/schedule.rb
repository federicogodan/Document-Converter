# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, { :standard => "/Logs/log.log", :error => "/Logs/errors.log" }

 every 1.minutes do
   runner "ConverterDocumentController.delete_old_files"
 end

# Learn more: http://github.com/javan/whenever
