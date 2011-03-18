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
  
  def add!(url, name = nil)
      
      
    if name.nil?
      default_name = "My Awesome Quest"
      print "Quest Name?".foreground(:yellow) + " [#{default_name}] "
      name = (STDIN.gets || "").strip
      name = default_name if name.empty?
    end

    quest = Railsquest::Quest.for_name(name)
    quest.url = url

    if quest.exist?
      abort "You've already a quest #{quest}."
    end
    
    Dir.chdir(Railsquest.quests_path) { `echo #{quest.url} >> #{quest.path}` }
    puts init_success_message(quest.dirname)

    quest
  end
  
  def init_success_message(quest_dirname)
    plain_init_success_message(quest_dirname).gsub("git push quest master", "git push quest master".foreground(:yellow))
  end
  
  def plain_init_success_message(quest_dirname)
    "Railsquest quest #{quest_dirname} initialised and remote quest added.\nNext: git push quest master"
  end
  
  def clone!(url, clone_name)
    dir = clone_name || File.basename(url).chomp('.git')

    if File.exist?(dir)
      abort "Can't clone #{url} to #{dir}, the directory already exists."
    end

    `git clone #{url} #{dir}`
    if $? != 0
      abort "Failed to clone railsquest quest #{url} to #{dir}."
    else
      puts "Railsquest quest #{url} cloned to #{dir}."
      add!(dir, dir)
    end
  end

end