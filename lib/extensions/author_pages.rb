class ::Middleman::Configuration::ConfigurationManager
  attr_accessor :authorlink
  attr_accessor :author_template
end

class ::Middleman::Blog::Options
  attr_accessor :authorlink
  attr_accessor :author_template
end

module ::Middleman::Blog::BlogArticle
  def author
    data['author']
  end
end

class ::Middleman::Blog::BlogData
  def authors
    authors = {}
    @_articles.each do |article|
      author = article.author
      authors[author] ||= []
      authors[author] << article
    end

    authors.each do |author, articles|
      authors[author] = articles.sort_by(&:date).reverse
    end

    authors
  end
end

module AuthorPages
  def self.registered(app)
    app.helpers do
      def author_path(author)
        sitemap.find_resource_by_path(::AuthorPages::AuthoredPage.link(self, author)).try(:url)
      end
    end

    app.after_configuration do
      sitemap.register_resource_list_manipulator(:blog_authors, ::AuthorPages::AuthoredPage.new(self), false)
    end
  end

  def self.included(*args)
    self.registered(*args)
  end

  class AuthoredPage
    def self.link(app, author)
      ::Middleman::Util.normalize_path(app.blog.options.authorlink.sub(':author', author.parameterize))
    end

    def initialize(app)
      @app = app
    end

    def manipulate_resource_list(resources)
      resources + @app.blog.authors.map do |author, articles|
        path = self.class.link(@app, author)

        resource = ::Middleman::Sitemap::Resource.new(@app.sitemap, path)
        resource.proxy_to(@app.blog.options.author_template)

        resource.add_metadata :locals => {
          'page_type' => 'author',
          'authorname' => author,
          'articles' => articles,
          'title' => "DockYard ReefPoints - #{author}'s Articles"
        }

        resource.add_metadata do
          @author = author
          @articles = articles
        end

        resource
      end
    end
  end
end

::Middleman::Extensions.register(:author_pages , ::AuthorPages)
