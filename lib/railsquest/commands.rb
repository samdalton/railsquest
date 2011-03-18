require 'rainbow'
require 'pathname'

module Railsquest::Commands

  # Start sinatra app.
  def serve_web!
    puts "* Starting " + web_uri.foreground(:yellow)
    fork do
      ENV["RACK_ENV"] ||= "production"
      require "railsquest/../../sinatra/app"
      Sinatra::Application.set :port, web_port
      Sinatra::Application.set :server, "thin"
      Sinatra::Application.run!
    end
  end

  # todo serve their server!
  def serve_git!
    puts "* Starting " + "#{git_uri}".foreground(:yellow)
    fork { exec "git daemon --base-path=#{quests_path} --export-all" }
  end
  
  def advertise!
    fork { Railsquest::Bonjour::Advertiser.new.go! }
  end
  
  def add!(port, name = nil)
         
    if name.nil?
      default_name = "My Awesome Quest"
      print "Quest Name?".foreground(:yellow) + " [#{default_name}] "
      name = (STDIN.gets || "").strip
      name = default_name if name.empty?
    end

    quest = Railsquest::Quest.for_name(name)
    quest.port = port

    if quest.exist?
      abort "You've already a quest #{quest}."
    end
    
    quest.init!
    
    puts init_success_message(quest.dirname)

    quest
  end
  
  def init_success_message(quest_dirname)
    plain_init_success_message(quest_dirname)
  end
  
  def plain_init_success_message(quest_dirname)
    "Railsquest quest #{quest_dirname} created."
  end
  
end