require 'dnssd'

class Railsquest::Bonjour::Advertiser
  def initialize
    @services = []
  end
  def go!
    register_app
    register_quests
  end
  private
    def register_app
      STDOUT.puts "Registering #{Railsquest.web_uri}"
      tr = DNSSD::TextRecord.new
      tr["name"] = Railsquest.config.name
      tr["email"] = Railsquest.config.email
      tr["uri"] = Railsquest.web_uri
      tr["gravatar"] = Railsquest.gravatar
      tr["version"] = Railsquest::VERSION
      DNSSD.register("#{Railsquest.config.name}'s railsquest", "_http._tcp,_railsquest", nil, Railsquest.web_port, tr)
    end
    def register_quests
      loop do
        stop_old_services
        register_new_quests
        sleep(1)
      end
    end
    def stop_old_services
      old_services.each do |old_service|
        STDOUT.puts "Unregistering #{old_service.quest.uri}"
        old_service.stop
        @services.delete(old_service)
      end
    end
    def old_services
      @services.reject {|s| Railsquest.quests.include?(s.quest)}
    end
    def register_new_quests
      new_quests.each do |new_quest|
        STDOUT.puts "Registering #{new_quest.uri}"
        tr = DNSSD::TextRecord.new
        tr["name"] = new_quest.name
        tr["uri"] = new_quest.uri
        tr["bjour-name"] = Railsquest.config.name
        tr["bjour-email"] = Railsquest.config.email
        tr["bjour-uri"] = Railsquest.web_uri
        tr["bjour-gravatar"] = Railsquest.gravatar
        tr["bjour-version"] = Railsquest::VERSION
        service = DNSSD.register(new_quest.name, "_git._tcp,_railsquest", nil, 9877, tr)
        service.class.instance_eval { attr_accessor(:quest) }
        service.quest = new_quest
        @services << service
      end
    end
    def new_quests
      Railsquest.quests.select {|quest| !@services.any? {|s| s.quest == quest } }
    end
end
