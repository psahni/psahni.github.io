class Middleman::Blog::TagPages
  def self.tag_name(tag)
    case tag.downcase
    when 'ruby on rails'
      'Ruby on Rails'
    when 'jquery'
      'jQuery'
    when 'postgresql', 'postgres'
      'PostgreSQL'
    when 'jquery'
      'jQuery'
    when 'javascript'
      'JavaScript'
    when 'ember', 'emberjs', 'ember.js'
      'Ember.js'
    when 'backbone'
      'Backbone.js'
    else
      tag.split(' ').map(&:capitalize).join(' ')
    end
  end

  def manipulate_resource_list(resources)
    resources + @app.blog.tags.map do |tag, articles|
      path = self.class.link(@app.blog.options, tag)

      p = ::Middleman::Sitemap::Resource.new(
        @app.sitemap,
        path
      )
      p.proxy_to(@app.blog.options.tag_template)

      # Add metadata in local variables so it's accessible to
      # later extensions
      p.add_metadata :locals => {
        'page_type' => 'tag',
        'tagname' => tag,
        'articles' => articles,
        'title' => "DockYard ReefPoints - #{self.class.tag_name(tag)} Articles"
      }
      # Add metadata in instance variables for backwards compatibility
      p.add_metadata do
        @tag = tag
        @articles = articles
      end

      p
    end
  end
end
