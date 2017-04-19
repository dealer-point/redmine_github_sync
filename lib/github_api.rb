class GithubApi
  def initialize(owner, repo, protocol = 'https', token)
  	valid_param = owner.empty? || repo.empty? || token.empty?
    raise 'Empty owner or repasitory or token' if valid_param
    @owner = owner
    @repo = repo
    @protocol = protocol
    @token = token
    @pulls_list_url = "#{@protocol}://api.github.com/repos/#{@owner}/#{@repo}"\
                      "/pulls?access_token=#{@token}&state=all"
  end

  def unserialize(data)
    JSON.parse(data)
  end
  
  private :unserialize

  def send_request(path, method = 'GET', data = {}, use_token = true)
    request_data = {}
    uri = URI(path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if @protocol == 'https'

    case method
      when 'POST'
        request = Net::HTTP::Post.new(uri)
        request.set_form_data(data)
      when 'PUT'
        request = Net::HTTP::Put.new(uri)
        request.set_form_data(data)
      when 'DELETE'
        request = Net::HTTP::Delete.new(uri)
      else
        request = Net::HTTP::Get.new(uri)
    end

    begin
      response = http.request(request)
      request_data[:data] = JSON.parse(response.body)
      request_data[:http_code] = response.code
      request_data[:link] = response.header['link']
      
    rescue Exception => e
      puts "Exception \n  message: #{e.message} \n  backtrace: #{e.backtrace}"
    end

    handle_result(request_data)
  end
  
  def handle_result (data)
    unless data[:http_code].to_i == 200
      data[:is_error] = true
    end
    data
  end

  def pulls 
  	@pulls_list = []
  	get_pulls_list(@pulls_list_url)
  end

  def get_pulls_list(url)
  	response = send_request(url)
    @pulls_list += response[:data]
    link = response[:link]
    next_link_param = /\<(http.*?)\>.*?rel=\"next"/.match(link)
    next_url = next_link_param[1] if next_link_param
    get_pulls_list(next_url) if next_url
    @pulls_list
  end

end