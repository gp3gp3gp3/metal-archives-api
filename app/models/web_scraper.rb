class WebScraper

  def self.scrape_band_page(html)
    site = Nokogiri::HTML(html)
    keys = site.css("div#band_stats dt").map {|e| e.text.chop.squish.downcase.tr(" ", "_").to_sym}
    values = site.css("div#band_stats dd").map {|e| e.text.squish}
    band_attribs = Hash[keys.zip values]
    band_attribs[:band_name] = site.css("h1.band_name a")[0].text
    band_attribs[:band_name_img] = site.css("a#logo")[0].attributes["href"].value
    band_attribs[:band_img] = site.css("a#photo")[0].attributes["href"].value

    binding.pry
    # This div#ui-tabs-5 needs to be targeted in a different way, since the id changes
    album_header = site.css("div#ui-tabs-5 tr")[0].css("th").map {|e| e.text.downcase.to_sym}

    album_data = site.css("div#ui-tabs-5 tr")[1..-1].map {|e| e.css("td").map {|el| el.text.squish}}

    album_hashes = album_data.map {|e| Hash[album_header.zip(e)]}
    band_attribs[:albums] = album_hashes.map {|album| Album.new(album)}
    band_attribs
  end

end