# frozen_string_literal: true

# 共通で使うメソッド
module Memohelper
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def parse_datas
    File.open('./data.json') { |file| JSON.parse(file.read) }
  rescue JSON::ParserError
    []
  end
end
