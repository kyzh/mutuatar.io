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
  erb "hello"
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
  erb :loan, :locals => { :mortgage => request.POST }
end

get '/moar' do
    erb :result, :locals => { :username => request.GET.to_s }
end
