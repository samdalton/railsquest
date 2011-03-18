require 'rainbow'
require 'pathname'

module Railsquest::Commands

  def check_git!
    if (version = `git --version`.strip) =~ /git version 1\.[12345]/
      abort "You have #{version}, you need at least 1.6"
    end
  end
  
  def check_git_config!
    config_message = lambda {|key, example| "You haven't set your #{key} in your git config yet. To set it: git config --global #{key} '#{example}'"}
    abort(config_message["user.name", "My Name"]) if config.name.empty?
    abort(config_message["user.email", "name@domain.com"]) if config.email.empty?
  end

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

  def serve_git!
    puts "* Starting " + "#{git_uri}".foreground(:yellow)
    fork { exec "git daemon --base-path=#{quests_path} --export-all" }
  end
  
  def advertise!
    fork { Railsquest::Bonjour::Advertiser.new.go! }
  end
  
  def add!(dir, name = nil)
    dir = Pathname(dir)

    unless dir.join(".git").directory?
      abort "Can't init project #{dir}, no .git directory found."
    end

    if name.nil?
      default_name = dir.basename.to_s
      print "Project Name?".foreground(:yellow) + " [#{default_name}] "
      name = (STDIN.gets || "").strip
      name = default_name if name.empty?
    end

    repo = Railsquest::Quest.for_name(name)

    if repo.exist?
      abort "You've already a project #{repo}."
    end

    repo.init!
    Dir.chdir(dir) { `git remote add quest #{repo.path.expand_path}` }
    puts init_success_message(repo.dirname)

    repo
  end
  
  def init_success_message(repo_dirname)
    plain_init_success_message(repo_dirname).gsub("git push quest master", "git push quest master".foreground(:yellow))
  end
  
  def plain_init_success_message(repo_dirname)
    "Railsquest quest #{repo_dirname} initialised and remote quest added.\nNext: git push quest master"
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