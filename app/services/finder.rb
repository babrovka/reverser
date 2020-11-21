class Finder
  attr_reader :image_url

  def initialize(image_url)
    @image_url = CGI.escape(image_url)
  end

  def find_similar
    params = {'api_key' => ENV['SERPAPI'],'engine' => 'google_reverse_image','image_url' => image_url}
    query = URI.encode_www_form(params)
    http = Curl.get("https://serpapi.com/search?#{query}")
    json = json = JSON.parse(http.body_str)

    json["image_results"].each do |result|
      Result.create(title: result["title"], link: result["link"])
    end
  end
end
