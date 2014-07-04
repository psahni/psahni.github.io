---
layout: post
title: Parsing JSON Response in Ruby
twitter: _prashantsahni
author: Prashant Sahni
tags: Ruby scripts
social: true
---

<p>
	We have to use Net::HTTP class, for that we have to require net/http ( it is inbuilt with ruby). A very use full link on Net::HTTP  
	<a href='http://www.rubyinside.com/nethttp-cheat-sheet-2940.html'>here</a> 
</p>

```ruby
	require 'net/http'
	require 'rubygems'
	require 'json'

	@response = Net::HTTP.get(URI.parse("http://www.reddit.com/.json"))
	@result = JSON.parse(@response)

```


<p>
Now the parsed info lies in the @result, by using methods of ruby, you can parse this @result according to you your need.
</p>

