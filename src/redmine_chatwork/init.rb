require 'redmine'

require File.expand_path('../lib/redmine_chatwork/listener', __FILE__)

Redmine::Plugin.register :redmine_chatwork do
  name 'Redmine Chatwork for Redmine5'
  author 'shogo nakamrua'
  url 'https://github.com/shona-l/redmine_chatwork'
  author_url 'https://github.com/shona-l/'
  description 'A Redmine plugin to notify updates to ChatWork rooms'
  version '0.3.0'

  requires_redmine :version_or_higher => '3.2.0'

  settings :default => {
      'room' => nil,
      'token' => nil,
      'post_updates' => '1',
      'post_wiki_updates' => '1'
  },
  :partial => 'settings/chatwork_settings'
end

if Rails.version > '6.0' && Rails.autoloaders.zeitwerk_enabled?
  Rails.application.config.after_initialize do
    unless Issue.included_modules.include? RedmineChatwork::IssuePatch
      Issue.send(:include, RedmineChatwork::IssuePatch)
    end
  end
else
  ((Rails.version > "5")? ActiveSupport::Reloader : ActionDispatch::Callbacks).to_prepare do
    require_dependency 'issue'
    unless Issue.included_modules.include? RedmineChatwork::IssuePatch
      Issue.send(:include, RedmineChatwork::IssuePatch)
    end
  end
end