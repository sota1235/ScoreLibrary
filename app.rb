require 'sinatra/base'
require 'haml'
require 'sass'
require 'coffee-script'

require_relative 'models/init'

class Server < Sinatra::Base

  # セッション設定
  enable :sessions
  set :sessions, true

  # ログイン画面
  get '/login' do
    if session[:value] == 'view':
      redirect '/main'
    elsif session[:value] == 'upload'
      redirect "/upload/#{session[:id]}"
    else
      haml :login
    end
  end

  # ログイン情報送信
  post '/login' do
    flag = check_date(params[:id],params[:pass])
    if flag != False
      if flag == "view"
        session[:value] = 'view'
        redirect '/main'
      else
        session[:value] = 'upload'
        session[:id] = params[:id]
        redirect "/upload/#{params[:id]}"
      end
    else
      redirect '/login'
    end
  end

  # 閲覧用楽譜ページ
  get '/main' do
    redirect '/login' if session[:value] = nil
    haml :main
  end

  # 楽譜ページ
  get '/main/:score' do
    redirect '/login' if session[:value] = nil
    # なんらかのモデル
    haml :score
  end

  # アップロードページ
  get '/upload/:user' do
    haml :upload
  end

  # ファイルアップロード
  post '/send' do

    redirect "/upload/#{session[:id]}"
  end
end
