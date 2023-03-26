class PingController < ApplicationController

  def pong
    Esp::Subsystem.connection.execute('SELECT 1')
    Mex::Subsystem.connection.execute('SELECT 1')
    Latam::Subsystem.connection.execute('SELECT 1')
    Tirantid::LopdApp.connection.execute('SELECT 1')
    Esp::UserSession.first
    Mex::UserSession.first
    Latam::UserSession.first
    response_with_no_content
  end

end
