require 'json'
require 'byebug'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_rails_lite_app']
      @cookies_hash = JSON.parse(req.cookies['_rails_lite_app'])
    else
      @cookies_hash = {}
    end
  end

  def [](key)
    @cookies_hash[key]
  end

  def []=(key, val)
    @cookies_hash[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    # You specify the cookie's attributes using a hash. 
    # You should make sure to specify the path and value
    # attributes. The path should be / so the cookie will
    # available at every path and the value should be the
    # JSON serialized content of the ivar that contains the session data.
    res.set_cookie('_rails_lite_app', @cookies_hash.to_json)
  end
end
