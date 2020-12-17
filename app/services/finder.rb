class Finder
  attr_reader :image_url, :sites, :phrases

  def initialize(params)
    @image_url = CGI.escape(params[:image_url])
    @phrases = params[:phrases].join(" | ") rescue ""
    @sites = params[:sites].map { |site| "site:#{site}" }.join(" | ") rescue ""
  end

  def find_similar
    tineye = Tinplate::TinEye.new
    results = tineye.search(image_url: image_url)

    results.matches.each do |match|
      Result.create(title: match["backlinks"].first["backlink"], link: match["backlinks"].first["url"])
    end
  end
end
