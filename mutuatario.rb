$LOAD_PATH.unshift *Dir["#{File.dirname(__FILE__)}/lib"]
require 'rubygems'
require 'sinatra'
require 'mortgage'
#require 'loan'

APP_ROOT = "#{File.dirname(__FILE__)}"

configure do
  set :root, APP_ROOT
  set :views, APP_ROOT + '/views'
  set :public_folder, APP_ROOT + '/static'
end

get '/' do
  #erb "Welcome on mutuatario the most efficient Mortgage calcultor on the web"
  redirect '/mortgage'
end

get '/mortgage' do 
  erb :mortgage_form
end

get '/loan' do   
  erb :loan_form
end

post '/mortgage' do
  erb :mortgage_form, :locals => { :mortgage => request.POST }
end

post '/loan' do
  erb :loan_form, :locals => { :mortgage => request.POST }
end

get '/about' do
   erb "<p>Why yet another mortgage calculator?</br> Because this one is ad-free and extensible!</br> Have a look at the source on <a href=\"https://github.com/kyzh/mutuatar.io\">github</a> </br> There is no guaranty that the numbers provided here are right.</br> Do _not_ use this tool as your only source of information.<p>"
end

