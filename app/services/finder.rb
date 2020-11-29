class Finder
  attr_reader :image_url, :sites, :phrases

  def initialize(params)
    @image_url = CGI.escape(params[:image_url])
    @phrases = params[:phrases].join(" | ") rescue ""
    @sites = params[:sites].map { |site| "site:#{site}" }.join(" | ") rescue ""
  end

  def find_similar
    query = URI.encode_www_form(params)
    http = Curl.get("https://serpapi.com/search?#{query}")
    json = json = JSON.parse(http.body_str)

    json["image_results"].each do |result|
      Result.create(title: result["title"], link: result["link"])
    end
  end

  def params
    {
      'api_key' => ENV['SERPAPI'],
      'engine' => 'google_reverse_image',
      'q' => search_query,
      'image_url' => image_url,
      'num' => 100,
    }
  end

  def search_query
    "#{phrases} #{sites}"
  end
end
