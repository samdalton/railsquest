require 'grit'
require 'pathname'

module Railsquest
  class Quest
      
      attr_accessor :name, :port
      
    def self.for_name(name)
        n = name.gsub(' ', '_')
        q = new(Railsquest.quests_path.join(n + ".quest"))
        q.name = n
        q
    end
    
    def self.html_id(name)
      name.gsub(/[^A-Za-z-]+/, '').downcase
    end
    def initialize(path)
      @path = Pathname(path)
    end
    def ==(other)
      other.respond_to?(:path) && self.path == other.path
    end
    attr_reader :path
    def exist?
      path.exist?
    end
    
    def init!
      Dir.chdir(Railsquest.quests_path) { `echo #{port} >> #{path}` }
    end
    
    def uri
        Railsquest.git_uri.gsub(/\/$/, '') + ':' + File.open(path) { |f| f.gets }
    end
    
    def name
      dirname.sub(".quest",'')
    end
    def html_id
      self.class.html_id(name)
    end
    def dirname
      path.split.last.to_s
    end
    def to_s
      name
    end

    def web_uri
      Railsquest.web_uri + "#" + html_id
    end
   
    def remove!
      path.rmtree
    end
    def to_hash
      {
        "name" => name,
        "url" => url,
        "host_name" => Railsquest.host_name
      }
    end
  end
end