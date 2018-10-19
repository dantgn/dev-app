if Rails.env.test? || Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end
