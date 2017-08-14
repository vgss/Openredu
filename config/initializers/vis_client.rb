# -*- encoding : utf-8 -*-
VisClient.configure do |config|
 config.deliver_notifications = !(Rails.env.test? || Rails.env.development?)
 config.logger = Rails.logger
 config.endpoint = 'http://vis.openredu.com'
end
