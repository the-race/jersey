class Params
  attr_accessor :defaults, :headers, :cookies

  def initialize
    @defaults = { :followlocation => true }
    @headers  = {
      'Accept'     => %w(
                         text/javascript
                         application/javascript
                         application/ecmascript
                         application/x-ecmascript
                        ).join(', '),
      'User-Agent' => %w(
                         mozilla/5.0
                         (macintosh; intel mac os x 10_6_8)
                         applewebkit/535.19
                         (khtml, like gecko)
                         chrome/18.0.1025.168
                         safari/535.19
                        ).join(' ')
    }
    @cookies = ''
  end

  def to_h
    #defaults = self.defaults.clone
    #headers  = self.headers.clone
    #cookies  = self.cookies.clone
    self.defaults[:headers] = headers
    self.headers['Cookie']  = cookies
    defaults
  end
end                              
