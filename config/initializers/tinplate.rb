Tinplate.configure do |config|
  config.public_key  = ENV['TINEYE_PUBLIC']
  config.private_key = ENV['TINEYE_SECRET']
  config.test        = false
end