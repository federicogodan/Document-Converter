class ConverterDocumentController < ApplicationController
  def self.delete_old_files
    @converter_document = ConverterDocument.find()
    @converter_document.destroy
  end
end
