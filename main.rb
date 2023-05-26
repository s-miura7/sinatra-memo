# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './helpers/memo_helpers'

helpers Memo_helpers

get '/memos' do
  @memos = parse_data
  erb :top_view
end

get '/memos/new' do
  erb :new_view
end

post '/memos' do
  current_data = parse_data
  req_body = {}
  req_body['title'] = params[:title]
  req_body['text'] = params[:text]
  req_body['id'] = current_data.empty? ? 1 : current_data[-1]['id'] + 1
  current_data.push(req_body)
  File.open('data.json', 'w') do |file|
    JSON.dump(current_data, file)
  end
  redirect '/memos'
end

get '/memos/:id' do
  id = params['id'].to_i
  current_data = parse_data
  @memo = current_data.find { |data| data['id'].eql?(id) }
  return not_found if @memo.nil?

  erb :show_view
end

delete '/memos/:id' do
  id = params['id'].to_i
  current_data = parse_data
  current_data.delete_if { |data| data['id'].eql?(id) }
  File.open('data.json', 'w') { |file| JSON.dump(current_data, file) }
  redirect '/memos'
end

get '/memos/:id/edit' do
  id = params['id'].to_i
  current_data = parse_data
  @memo = current_data.find { |data| data['id'].eql?(id) }
  return not_found if @memo.nil?

  erb :edit_view
end

patch '/memos/:id' do
  id = params['id'].to_i
  current_data = parse_data
  req_body = {}
  req_body['title'] = params[:title]
  req_body['text'] = params[:text]
  req_body['id'] = id
  current_data.map! { |data| data['id'] == id ? req_body : data }
  File.open('data.json', 'w') do |file|
    JSON.dump(current_data, file)
  end
  redirect '/memos'
end

not_found do
  '404'
end
