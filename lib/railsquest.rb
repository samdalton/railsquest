libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'railsquest/quest'
require 'railsquest/grit_extensions'
require 'railsquest/version'
require 'railsquest/bonjour'
require 'railsquest/helpers'
require 'railsquest/commands'

require 'ostruct'
require 'socket'
require 'pathname'

module Railsquest
  
  class << self

    include DateHelpers
    include GravatarHelpers
    include Commands
    
    def setup?
      quests_path.exist?
    end
    
    def setup!
      quests_path.mkpath
    end
    
    def path
      Pathname("~/.railsquest").expand_path
    end
    
    def quests_path
      path + "quests"
    end


    
    def config
      @config ||= begin
        OpenStruct.new
      end
    end
    
    def web_port
      9876
    end
    
    def web_uri
      "http://#{host_name}:#{web_port}/"
    end
    
    def host_name
      hn = get_git_global_config("railsquest.hostname")
      unless hn.nil? or hn.empty?
        return hn
      end

      hn = Socket.gethostname

      # if there is more than one period in the hostname then assume it's a FQDN
      # and the user knows what they're doing
      return hn if hn.count('.') > 1

      if hn =~ /\.local$/
        hn
      else
        hn + ".local"
      end
    end
    
    def git_uri
      "git://#{host_name}/"
    end

    def quests
      quests_path.children.map {|r| Quest.new(r)}.sort_by {|r| r.name}
    end
    
    def quest(name)
      quests.find {|r| r.name == name}
    end
    
    def to_hash
      {
        "name" => config.name,
        "email" => config.email,
        "uri"  => web_uri,
        "git-uri" => git_uri,
        "gravatar" => Railsquest.gravatar,
        "version" => Railsquest::VERSION,
        "quests" => quests.collect do |r|
          {"name" => r.name, "uri" => r.uri}
        end
      }
    end
    
  end
  
end
