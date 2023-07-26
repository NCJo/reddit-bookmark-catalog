class SessionController < ApplicationController
    def create
        auth_hash = request.env['omniauth.auth']
        session[:access_token] = auth_hash.credential.token
        redirect_to root_path, notice: 'Logged in!'
    end

    def destroy
        session[:access_token] = nil
        redirect_to root_path, notice: 'Logged Out!'
    end