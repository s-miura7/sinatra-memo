# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './helpers/memo_helpers'
require 'pg'

helpers MemoHelpers

conn = PG.connect(dbname: 'memo')
# conn.exec("CREATE TABLE memos(id SERIAL, title TEXT NOT NULL, text TEXT NOT NULL)")

get '/memos' do
  @memos = conn.exec('SELECT * FROM memos')
  erb :top_view
end

get '/memos/new' do
  erb :new_view
end

post '/memos' do
  conn.exec('INSERT INTO memos(title, text) VALUES ($1, $2)', [params[:title], params[:text]])
  redirect '/memos'
end

get '/memos/:id' do
  id = params['id']
  conn.exec('SELECT * FROM memos WHERE id = $1', [id]).each { |result| @memo = result }
  return not_found if @memo.nil?

  erb :show_view
end

delete '/memos/:id' do
  id = params['id']
  conn.exec('DELETE FROM memos WHERE id = $1', [id])
  redirect '/memos'
end

get '/memos/:id/edit' do
  id = params['id']
  conn.exec('SELECT * FROM memos WHERE id = $1', [id]).each { |result| @memo = result }
  return not_found if @memo.nil?

  erb :edit_view
end

patch '/memos/:id' do
  id = params['id']
  # 一文が長いから2行に分けた
  res = conn.exec('UPDATE  memos SET (title, text) = ($1, $2) WHERE id = $3', [params[:title], params[:text], id])
  res.each { |result| @memo = result }
  redirect '/memos'
end

not_found do
  '404'
end
