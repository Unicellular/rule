require 'sinatra'
require 'json'
require 'slim'
require 'bootstrap-sass'

get '/' do
  @rule = JSON.parse( File.open( "./rule.json", "r" ).read )
  slim :index unless @rule.nil?
end

get '/stylesheets/*.css' do |style|
  content_type 'text/css', :charset => 'utf-8'
  scss style.to_sym, :views => "#{settings.root}/assets/stylesheets"
end