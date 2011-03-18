require 'grit'
require 'pathname'

module Railsquest
  class Quest
      
      attr_accessor :name, :uri
      
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
      Dir.chdir(Railsquest.quests_path) { `echo #{url} >> #{path}` }
    end
    
    def uri
        File.open(path) { |f| f.gets }
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
    def uri
      Railsquest.git_uri + dirname
    end
    def web_uri
      Railsquest.web_uri + "#" + html_id
    end
    def grit_quest
      @grit_quest ||= Grit::Repo.new(path)
    end
    def recent_commits
      @commits ||= grit_quest.commits(nil, 10)
    end
    def readme_file
      grit_quest.tree.contents.find {|c| c.name =~ /readme/i}
    end
    def rendered_readme
      case File.extname(readme_file.name)
      when /\.md/i, /\.markdown/i
        require 'rdiscount'
        RDiscount.new(readme_file.data).to_html
      when /\.textile/i
        require 'redcloth'
        RedCloth.new(readme_file.data).to_html(:textile)
      end
    rescue LoadError
      ""
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