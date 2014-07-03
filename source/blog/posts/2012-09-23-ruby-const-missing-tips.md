---
layout: post
title: "ruby 'const-missing' tip"
twitter: _prashantsahni
author: Prashant Sahni
tags: ruby
social: true
---

<style>
.highlight code{
  background-color: black !important;
}
</style>


<p>
  <h3>Handle loading of constants with the help of const_missing </h3>
  We can find the constants defined for the class on the fly like this:
</p>


```ruby

class User  
  def self.const_missing(const_name)
   case const_name
    when :PREMIUM
      1
    when :GOLD
      2
    when :PLATINUM
      3
    when :TITANIUM
      4
   else
     nil    
   end
  end  
end

# User::PREMIUM =>  1
# User::GOLD    =>  2
# User::PLATINUM => 3
# User::DIAMOND => nil

```


You can set constant value on the fly like this:

```ruby
    self.const_set(const_name, -rand(99999)) unless self.const_defined?(const_name)
```

So, Instead of returning <code>nil</code> you can write above code, depending upon our usecase.

We can do lots of interesting tasks with the help of this technique, like loading the file on the fly or including module and calling its method. Think about it.
Hope it helps. Thanks for reading.

