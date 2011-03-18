require 'logger'
Thread.abort_on_exception = true

logger = Logger.new('development.log')
logger.level = Logger::DEBUG

$:.unshift File.dirname(__FILE__) + "/lib"

require "railsquest"

require 'sinatra'
require 'haml'
require 'json'

require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/array'

set :server, 'thin'
set :haml, {:format => :html5, :attr_wrapper => '"'}
set :logging, false
set :root, File.dirname(__FILE__)

require "mock_browsers" if Sinatra::Application.development?

set :railsquest_browser, Railsquest::Bonjour::RailsquestBrowser.new
set :quest_browser, Railsquest::Bonjour::QuestBrowser.new

require "diff_helpers"
helpers DiffHelpers

require "railsquest/helpers"
helpers Railsquest::GravatarHelpers, Railsquest::DateHelpers

helpers do
  def railsquest_browser() options.railsquest_browser end
  def quest_browser() options.quest_browser end
  def json(body)
    content_type "application/json"
    params[:callback] ? "#{params[:callback]}(#{body});" : body
  end
  def local?
    [
      "0.0.0.0",
      "127.0.0.1",
      Socket.getaddrinfo(request.env["SERVER_NAME"], nil).map {|a| a[3]}
    ].flatten.include? request.env["REMOTE_ADDR"]
  end
  def pluralize(number, singular, plural)
    "#{number} #{number == 1 ? singular : plural}"
  end
end

get "/" do
  @my_quests     = Railsquest.quests
  @my_quest      = false
  @other_repos_by_name = quest_browser.other_quests.group_by {|r| r.name}
  @people              = railsquest_browser.other_railsquests
  haml :home
end

get "/:quest/readme" do
  @quest      = Railsquest::Quest.for_name(params[:quest])
  readme_file      = @quest.readme_file
  @rendered_readme = @quest.rendered_readme
  @plain_readme    = readme_file.data
  haml :readme
end

get "/:quest/:commit" do
  @quest = Railsquest::Quest.for_name(params[:quest])
  @commit     = @quest.grit_quest.commit(params[:commit])
  haml :commit
end

get "/index.json" do
  json Railsquest.to_hash.to_json
end

get "/:quest.json" do
  response = Railsquest::Quest.for_name(params[:quest]).to_hash
  response["recent_commits"].map! { |c| c["committed_date_pretty"] = time_ago_in_words(Time.parse(c["committed_date"])).gsub("about ","") + " ago"; c }
  json response.to_json
end