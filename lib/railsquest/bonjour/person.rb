class Railsquest::Bonjour::Person

  attr_accessor :name, :email, :uri , :gravatar

  def initialize(name, email, uri, gravatar)
    @name, @email, @uri, @gravatar = name, email, uri, gravatar
  end
  
  def ==(other)
    self.uri == other.uri
  end
  
  def hash
    to_hash.hash
  end
  
  def to_hash
    {"name" => name, "email" => email, "uri" => uri, "gravatar" => gravatar}
  end
  
  def host_name
    uri.gsub(/http:\/\//, '').gsub(/:9876/, '')
  end
  
end
