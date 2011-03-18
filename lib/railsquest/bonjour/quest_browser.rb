module Railsquest::Bonjour
class QuestBrowser

  def initialize
    @browser = Browser.new('_git._tcp,_railsquest')
  end

  def quests
    @browser.replies.map do |reply|
      Quest.new(
        reply.text_record["name"],
        reply.text_record["uri"],
        Person.new(
          reply.text_record["bjour-name"],
          reply.text_record["bjour-email"],
          reply.text_record["bjour-uri"],
          reply.text_record["bjour-gravatar"]
        )
      )
    end
  end
  
  def other_quests
    quests.reject {|r| Railsquest.quests.any? {|my_rep| my_rep.name == r.name}}
  end
  
  def quests_similar_to(quest)
    quests.select {|r| r.name == quest.name}
  end
  
  def quests_for(person)
    quests.select {|r| r.person == person}
  end
  
end
end
