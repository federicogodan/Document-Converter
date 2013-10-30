class ConvertedDocumentController < ApplicationController
  
  def self.delete_old_files
    puts Time.now
    #remove expired documents from ConverterDocument model and S3
    @converter_document = ConvertedDocument.where('conversion_end_date <= ?', 1.day.ago)
    @converter_document.destroy_all
  end
end