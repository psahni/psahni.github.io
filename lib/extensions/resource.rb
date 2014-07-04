class Middleman::Sitemap::Resource
  def method_missing(method, *args, &block)
    if %w{title summary author twitter category comments github}.include?(method.to_s)
      data[method] || metadata[:locals][method.to_s]
    else
      super
    end
  end
end
