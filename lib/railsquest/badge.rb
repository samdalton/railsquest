require 'pathname'

module Railsquest
  class Badge

    attr_accessor :name

    def self.for_name(name)
      n = name.gsub(' ', '_')
      q = new(Railsquest.badges_path.join(n + ".badge"))
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

    def init!(signature, original_host)
        contents =  '{\"signature\" : \"' + signature + '\", \"original_host\" : ' + port +  '}'
        Dir.chdir(Railsquest.badges_path) { `echo #{contents} >> #{path}` }
    end

    def uri
      Railsquest.git_uri.gsub(/\/$/, '') + ':' + File.open(path) { |f| f.gets }
    end

    def name
      dirname.sub(".badge",'')
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
    
    def verified?
        RestClient.post
    end

    def to_hash
      {
        "name" => name
      }
    end
  end
end
