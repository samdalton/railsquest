module Railsquest::Bonjour
class RailsquestBrowser

  def initialize
    @browser = Browser.new('_http._tcp,_railsquest')
  end

  def railsquests
    @browser.replies.map do |reply|
      Person.new(
        reply.text_record["name"],
        reply.text_record["email"],
        reply.text_record["uri"],
        reply.text_record["gravatar"]
      )
    end
  end
  
  def other_railsquests
    railsquests.reject {|b| b.uri == Railsquest.web_uri}
  end
  
end
end
