class Finder
  attr_reader :image_url, :query

  def initialize(params)
    # @image_url = "https%3A%2F%2Fi.pinimg.com%2Foriginals%2F35%2F0e%2F73%2F350e73b5fcb3326850b3a9a82c13c760.jpg"
    @image_url = params[:image_url]
    @query = [params[:phrases], params[:domain]].join(" ")
  end

  def find_similar
    resp = client.get(initial_url)
    url = modified_url(resp.header["location"])
    resp = client.get(url)

    similar_images_link = resp.links.find { |link| link.href&.match?(/simg/) }
    similar_images_response = similar_images_link.click
    similar_images_response.body
  end

  def initial_url
    "https://images.google.com/searchbyimage?image_url=#{image_url}"
  end

  def modified_url(redirect_url)
    uri = URI.parse(redirect_url)
    new_query_ar = URI.decode_www_form(uri.query || '') << ["q", query]
    uri.query = URI.encode_www_form(new_query_ar)
    uri.to_s
  end

  def client
    @_client ||= begin
      agent = Mechanize.new
      agent.request_headers = {
        'authority' => 'images.google.com',
        'upgrade-insecure-requests' => '1',
        'User-Agent' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1'
      }
      agent.redirect_ok = false
      agent
    end
  end
end
