# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './helpers/helpers'

helpers Memohelper

get '/memos' do
  @memos = parse_datas
  erb :top_view
end

get '/memos/new' do
  erb :new_view
end

post '/memos' do
  current_datas = parse_data
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
  current_datas = parse_data
  @memo = current_datas.filter { |data| data['id'].eql?(id) }[0]
  return not_found if @memo.nil? == true

  erb :show_view
end

delete '/memos/:id' do
  id = params['id'].to_i
  current_datas = parse_data
  current_datas.delete_if { |data| data['id'].eql?(id) }
  File.open('data.json', 'w') { |file| JSON.dump(current_datas, file) }
  redirect '/memos'
end

get '/memos/:id/edit' do
  id = params['id'].to_i
  current_datas = parse_data
  @memo = current_datas.filter { |data| data['id'].eql?(id) }[0]
  return not_found if @memo.nil? == true

  erb :edit_view
end

patch '/memos/:id' do
  id = params['id'].to_i
  current_datas = parse_data
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

not_found do
  '404'
end
