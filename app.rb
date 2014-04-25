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
    if session[:value] == 'view' then
      redirect '/main'
    elsif session[:value] == 'upload' then
      redirect "/upload/#{session[:id]}"
    else
      haml :login
    end
  end

  # ログイン情報送信
  post '/login' do
    @user = User.new
    flag = @user.check_pass(params[:id],params[:pass])
    if flag != false then
      if flag == 'view' then
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

  # ログアウト
  post '/logout' do
    session[:value] = nil
    session[:id] = nil
    redirect '/login'
  end

  # 閲覧用楽譜ページ
  get '/main' do
    redirect '/login' if session[:value] == nil
    haml :main
  end

  # 楽譜ページ
  get '/main/:score' do
    redirect '/login' if session[:value] == nil
    # なんらかのモデル
    haml :score
  end

  # アップロードページ
  get '/upload/:user' do
    redirect '/login' if session[:value] == nil
    redirect '/main' if session[:id] == nil
    haml :upload
  end

  # ファイルアップロード
  post '/send' do
    redirect "/upload/#{session[:id]}"
  end

  # 任意のURLは/loginにredirect
  get '/*' do
    redirect '/login'
  end
end
