---
layout: post
title: Ruby on Rails Thinking Sphinx
twitter: _prashantsahni
author: Prashant Sahni
tags: jquery
social: true
---

#### Sphinx is open source search server used for full text search, we have used it with Rails and MySql database.

### Why Sphinx:


* Blazingly fast indexing and searching
* Variety of Text Processing features which are easy to adapt as per Application.
* Scaling: It can scale up to millions of queries per day.
* Performance: Sphinx indexes up to 10-15 MB of text per second per single CPU core.
* Easy to write Sql Style Queries
* Grouping and Clustering
* Distributed Searching


### Thinking Sphinx:

Thinking Sphinx is a Ruby gem which helps us to connect Sphinx with Rails Active Record.
We can attach our models to sphinx through Thinking Sphinx. <br/>

Example: Suppose we have Model Country with fields:
id, name, about, continent_id, capital, rating_no.

```
Country(id,name, about, continent_id, capital, rating_no)


```
Another model
```
PlacesToVisit(name, country_id)
```

```ruby
    class Country < ActiveRecord::Base 
      has_many :places_to_visits  
    end 
```  

```ruby
class PlacesToVisit < ActiveRecord::Base 
  belongs_to :country 
end 
```
  We want to have full text search on all fields of Country except id and its places to visit (has many association)

### How to Use:

We can  write in Country model as:

```ruby
    class Country < ActiveRecord::Base 
      has_many :places_to_visits 
      define_index do 
       indexes name, 
       :sortable => true 
       indexes about 
       indexes rating_no 
       indexes capital 
       indexes places_to_visits(:name), :as => :place, :sortable => true 
       has continent_id 
      end 
     end 
```

you can read more about indexing <a href='http://freelancing-god.github.com/ts/en/indexing.html' target='_blank'>here</a>  <br />

### Searching example

  Suppose we want to search countries with rating between 5 and 10.

```ruby
  Country.search params[:search], :with => {:rating_no => 5..10} 
```  

Here with is used for filtering, it accepts ruby array and ranges A typical example with some advanced options 

```ruby
Country(params[:search], :match_mode => :all, 
                         :field_weights => {:name => 20, :about => 10}, 
                         :with =>  {:rating_no => 5..10 }, 
                         :conditions => { :continent_id => 1}, 
                         :page => params[:page], :per_page => 3)
```

We have provided field weights here so that while searching is applied name will have more priority than about conditions is for full text  searching specific attributes, :with is for filtering search results.
We use pagination with incorporating :page and :per_page parameters 
match mode: How the key words will match to the fields 

```
:all – all records that has the complete key word will be returned 
:any – means all records that has any of the keyword will be returned 
:boolean – we can also use boolean operators with keywords example: 
```
Then
```
  Country.search ‘India | USA’, :match_mode => :boolean
```
  Hope this  post is useful to you.
  Thanks for Reading it.


