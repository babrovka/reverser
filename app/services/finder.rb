class Finder
  attr_reader :image_url, :sites, :phrases

  def initialize(params)
    # @image_url = "https%3A%2F%2Fi.pinimg.com%2Foriginals%2F35%2F0e%2F73%2F350e73b5fcb3326850b3a9a82c13c760.jpg"
    @image_url = params[:image_url]
    @phrases = params[:phrases]
    # @image_url = params[:image_url]
    # @phrases = params[:phrases].join(" | ") rescue ""
    # @sites = params[:sites].map { |site| "site:#{site}" }.join(" | ") rescue ""
  end

  def find_similar
    client.url = initial_url
    client.perform
    client.redirect_url

    client.url = modified_url(client.redirect_url)
    # client.perform
    # binding.pry
    # client.body
    # tineye = Tinplate::TinEye.new
    # results = tineye.search(image_url: image_url)

    # results.matches.each do |match|
    #   Result.create(title: match["backlinks"].first["backlink"], link: match["backlinks"].first["url"])
    # end
  end

  def initial_url
    "https://images.google.com/searchbyimage?image_url=#{image_url}&encoded_image=&image_content=&filename=&hl=ru"
  end

  def modified_url(redirect_url)
    uri = URI.parse(redirect_url)
    new_query_ar = URI.decode_www_form(uri.query || '') << ["q", @phrases] << ["oq", @phrases]
    uri.query = URI.encode_www_form(new_query_ar)
    uri.to_s
  end

  def client
    @_client ||= begin
      Curl::Easy.new("http://www.google.co.uk") do |curl|
        curl.headers["authority"] = "images.google.com"
        curl.headers["upgrade-insecure-requests"] = "1"
        curl.headers["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1"
        curl.verbose = true
      end
    end
  end
end
