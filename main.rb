# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './helpers/memo_helpers'
require 'pg'

helpers MemoHelpers

MY_DB_NAME = 'memo'

CONN = PG.connect(dbname: MY_DB_NAME)

CONN.exec('CREATE TABLE IF NOT EXISTS memos(id SERIAL, title TEXT NOT NULL, text TEXT NOT NULL)')

get '/memos' do
  @memos = CONN.exec('SELECT * FROM memos ORDER BY id ASC')
  erb :top_view
end

get '/memos/new' do
  erb :new_view
end

post '/memos' do
  CONN.exec('INSERT INTO memos(title, text) VALUES ($1, $2)', [params[:title], params[:text]])
  redirect '/memos'
end

get '/memos/:id' do
  redirect not_found unless /^[+-]?[0-9]+$/ =~ params['id'].to_s
  @memo = CONN.exec('SELECT * FROM memos WHERE id = $1',[ params['id']]).first
  redirect not_found if @memo.nil?

  erb :show_view
end

delete '/memos/:id' do
  CONN.exec('DELETE FROM memos WHERE id = $1',[ params['id']])
  redirect '/memos'
end

get '/memos/:id/edit' do
  redirect not_found unless /^[+-]?[0-9]+$/ =~ params['id'].to_s
  @memo = CONN.exec('SELECT * FROM memos WHERE id = $1',[ params['id']]).first
  redirect not_found if @memo.nil?

  erb :edit_view
end

patch '/memos/:id' do
  new_memo = [[params[:title], params[:text], params['id']]]
  CONN.exec('UPDATE  memos SET (title, text) = ($1, $2) WHERE id = $3', *new_memo)
  redirect '/memos'
end

not_found do
  "404 ページが見つかりません"
end
