
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAI5XVTWY2S636HMWQ',       # required
    :aws_secret_access_key  => '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',                        # required
    #:region                 => 'sa-east-1'                  # optional, defaults to 'us-east-1'
    #:host                   => 's3.amazonaws.com',             # optional, defaults to nil
    #:endpoint               => 'http://physiotec-rails.s3.amazonaws.com/' # optional, defaults to nil
  }

  config.fog_directory  = 'magicrepository'                                 # required
  #config.fog_public     = true                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  #storage :fog
end