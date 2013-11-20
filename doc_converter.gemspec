Gem::Specification.new do |s|
  s.name        = "doc_converter"
  s.version     = "0.0.1"
  s.summary     = "convert your documents"
  s.date        = "2013-11-03"
  s.description = "This library allows you to convert documents into another with the format you desire"
  s.authors     = ["Gonzalo Avila"]
  s.email       = ["gonzaloavila16@gmail.com"]
  s.files       = ["lib/doc_converter.rb"]
  
  #s.add_runtime_dependency 'base64',[">= 0"]
  #s.add_development_dependency 'base64',[">= 0"]
  #s.add_runtime_dependency 'openssl',[">= 0"]
  #s.add_development_dependency 'openssl',[">= 0"]
  s.add_runtime_dependency 'rest-client',[">= 0"]
  s.add_development_dependency 'rest-client',[">= 0"]	
end