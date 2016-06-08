require 'rack'
require_relative '../lib/controller_base'
# require 'byebug'

class MyController < ControllerBase
  def go
    if @req.path == "/cats"
      render_content("hello cats!", "text/html")
    else
      redirect_to("/cats")
    end
  end
end
