# -------------------------------------------------------------------
# EXTENSIONS
# -------------------------------------------------------------------

# custom
require 'builder'
#require 'byebug'
require 'middleman-blog/tag_pages'
require 'active_support/inflector'
require 'lib/extensions/custom_urls.rb'

p "==="
p Dir['./lib/**/*']
Dir['./lib/**/*.rb'].each { |f| require f }


activate :custom_urls


# gems
activate :livereload
activate :directory_indexes
activate :automatic_image_sizes
activate :syntax # code highlighting

activate :blog do |blog|
  blog.permalink = "blog/:year/:month/:day/:title.html"
  blog.sources = "blog/posts/:year-:month-:day-:title.html"
#  blog.paginate = true
#  blog.tag_template = 'category.html'
#  blog.taglink = 'categories/:tag.html'
  blog.author_template = 'author.html'
  blog.authorlink = 'authors/:author.html'
end

# github userpages deploy
#activate :deploy do |deploy|
  #deploy.method = :git
  #deploy.build_before = true
  #deploy.branch   = "master"
  #deploy.remote   = "git@github.com:username/username.github.io.git"
#end

# github project pages deploy
#activate :deploy do |deploy|
#  deploy.method = :git
#  deploy.build_before = true # default: false
#end

# markdown settings

set :markdown_engine, :redcarpet
set :markdown, :layout_engine => :erb, :fenced_code_blocks => true, :lax_html_blocks => true, :renderer => ::Highlighter::HighlightedHTML.new
activate :highlighter
activate :author_pages
activate :legacy_category
ignore 'author.html.haml'
page 'sitemap.xml', layout: false
page 'atom.xml', layout: false


# directories
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir, 'assets/fonts'
set :data_dir, 'source/data'
set :layouts_dir,  '_layouts'
set :helpers_dir, 'lib/helpers'
set :haml, remove_whitespace: true

#set :partials_dir, '_partials'

# -------------------------------------------------------------------
# MISC
# -------------------------------------------------------------------

# _vendor support for Sprockets
after_configuration do
  sprockets.append_path File.join "#{root}", 'source/assets/_vendor'
end

# Ignore files/paths
ignore '.idea/*'

# -------------------------------------------------------------------
# Build-specific config
# -------------------------------------------------------------------

configure :build do
  activate :minify_css
  activate :minify_javascript
  # activate :relative_assets
  # activate :cache_buster
  activate :asset_hash

  # Favicon generator
  # https://github.com/follmann/middleman-favicon-maker
=begin
  activate :favicon_maker do |f|
    f.template_dir  = File.join(root, 'source/assets/img')
    f.output_dir    = File.join(root, 'build')
    f.icons = {
      "favicon.ico" => [
        { icon: "favicon.ico", size: "32x32,16x16" },
      ]
    }
  end
=end
  # Alt image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
  # remote is optional (default is "origin")
  # run `git remote -v` to see a list of possible remotes
  deploy.remote = "git@github.com:psahni/psahni.github.io.git"

  # branch is optional (default is "gh-pages")
  # run `git branch -a` to see a list of possible branches
  deploy.branch = "master"
end


module Middleman::Blog::BlogArticle
  def summary
    data['summary']
  end

  def tags
    article_tags = data['tags']

    if data['tags'].is_a? String
      article_tags = article_tags.split(',').map(&:strip)
    else
      article_tags = Array.wrap(article_tags)
    end
    Array.wrap(data['legacy_category']) + article_tags
  end
end

helpers do
  def ordinal_date(date)
    number = date.day.ordinalize
    ordinal = number.slice!(-2,2)

    "#{date.strftime('%B')} #{number}<sup>#{ordinal}</sup>, #{date.strftime('%Y')}"
  end

  def tag_links(tags)
    tags.map do |tag|
      link_to tag_path(tag), class: 'post__tag' do
        "#{tag_name(tag)}&nbsp;<span class='post__tag__count'>(#{tag_count(tag)})</span>"
      end
    end.join(' ')
  end

  def tag_count(tag)
    blog.articles.select { |article| article.tags.include?(tag) }.size
  end

  def tag_name(tag)
    Middleman::Blog::TagPages.tag_name(tag)
  end

  def active_state_for(path)
    page_classes.split.first == (path) ? 'active' : nil
  end
end