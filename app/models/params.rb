class Params
  attr_accessor :defaults, :headers, :cookies

  def initialize
    @defaults = { followlocation: true }
    @headers  = { 'Accept'     => accept_header,
                  'User-Agent' => user_agent_header }
    @cookies  = ''
  end

  def to_h
    defaults = self.defaults.clone
    headers  = self.headers.clone
    cookies  = self.cookies.clone

    defaults[:headers] = headers
    headers['Cookie']  = cookies
    defaults
  end

  private

  def accept_header
    %w(text/javascript
       application/javascript
       application/ecmascript
       application/x-ecmascript).join(', ')
  end

  def user_agent_header
    %w(mozilla/5.0
       (macintosh; intel mac os x 10_6_8)
       applewebkit/535.19
       (khtml, like gecko)
       chrome/18.0.1025.168
       safari/535.19 ).join(' ')
  end
end
