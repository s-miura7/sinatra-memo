# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @memos = begin
    File.open('data.json') { |file| JSON.parse(file.read) }
  rescue JSON::ParserError
    []
  end
  erb :top_view
end

get '/memos/new' do
  erb :new_view
end

post '/memos/new' do
  current_datas = begin
    File.open('data.json') { |file| JSON.parse(file.read) }
  rescue JSON::ParserError
    []
  end
  File.open('data.json', 'w') do |file|
    req_body = {}
    req_body['title'] = h(params[:title])
    req_body['text'] = h(params[:text])
    req_body['id'] = current_datas.empty? ? 1 : current_datas[-1]['id'] + 1
    current_datas.push(req_body)
    JSON.dump(current_datas, file)
  end
  redirect '/memos'
end

get '/memos/:id' do
  id = params['id'].to_i
  current_datas = begin
    File.open('data.json') { |file| JSON.parse(file.read) }
  rescue JSON::ParserError
    []
  end
  @memo = current_datas.filter { |data| data['id'].eql?(id) }[0]
  erb :show_view
end

delete '/memos/:id' do
  id = params['id'].to_i
  current_datas = begin
    File.open('data.json') { |file| JSON.parse(file.read) }
  rescue JSON::ParserError
    []
  end
  current_datas.delete_if { |data| data['id'].eql?(id) }
  File.open('data.json', 'w') { |file| JSON.dump(current_datas, file) }
  redirect '/memos'
end

get '/memos/:id/edit' do
  p params
  id = params['id'].to_i
  current_datas = begin
    File.open('data.json') { |file| JSON.parse(file.read) }
  rescue JSON::ParserError
    []
  end
  @memo = current_datas.filter { |data| data['id'].eql?(id) }[0]
  erb :edit_view
end

patch '/memos/:id/edit' do
  p params
  id = params['id'].to_i
  current_datas = begin
    File.open('data.json') { |file| JSON.parse(file.read) }
  rescue JSON::ParserError
    []
  end
  File.open('data.json', 'w') do |file|
    req_body = {}
    req_body['title'] = h(params[:title])
    req_body['text'] = h(params[:text])
    req_body['id'] = id
    current_datas.map! { |data| data['id'] == id ? req_body : data }
    JSON.dump(current_datas, file)
  end
  redirect '/memos'
end
