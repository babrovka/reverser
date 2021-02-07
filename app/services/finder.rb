class Finder
  attr_reader :image_url, :sites, :phrases

  def initialize(image_url)
    @image_url = image_url

    # @image_url = params[:image_url]
    # @phrases = params[:phrases].join(" | ") rescue ""
    # @sites = params[:sites].map { |site| "site:#{site}" }.join(" | ") rescue ""
  end

  def find_similar
    client.url = url
    client.perform
    client.redirect_url
    # tineye = Tinplate::TinEye.new
    # results = tineye.search(image_url: image_url)

    # results.matches.each do |match|
    #   Result.create(title: match["backlinks"].first["backlink"], link: match["backlinks"].first["url"])
    # end
  end

  def url
    "https://images.google.com/searchbyimage?image_url=#{image_url}&encoded_image=&image_content=&filename=&hl=ru"
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
