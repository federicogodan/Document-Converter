#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, { :standard => "whenever_log.log", :error => "whenever_errors.log" }

 every 1.minute do
   runner "ConvertedDocumentController.delete_old_files"
 end