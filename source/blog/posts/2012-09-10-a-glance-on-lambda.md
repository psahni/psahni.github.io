---
layout: post
title: "A glance on usage of lambda"
twitter: _prashantsahni
author: Prashant Sahni
tags: ruby
social: true
---

<p>
  Hi there. Lots of blog posts exists on the web which explains about differences between Proc and lambda and talk about usage of blocks.
  Here we'll see some different and smart uses of lambda.
</p>
<p>
 As we know lambda is a instance of a class Proc and its behaviour is just like a method. Every thing in ruby is an object, but blocks itself are not objects,
 however we can represent them through object - here comes the role of lambda and obviously Proc.new . <br/>
 
 lambda is a method of 'Kernal' module.
</p>

Suppose we have an array: <code>array = [32, 42, 12, 3, 39, 51]</code>. If we want to sort this array in descending order, then we'll simply do

```ruby

 array.sort{|x,y| y <=> x }
```

Here is another way - We will move the block {|x,y| y<=>x} into the method

```ruby
def descending_order
  lambda{|x,y| y<=>x}
end
``` 
And then we can call like this

```ruby
array.sort &descending_order
```
The method 'sort' expects a block to be passed to it, so if we want to replace block by some method name, then we just have to prefix method name with '&'.

Now have a look at another example:

```ruby

  def print_hello(name = 'steve')
   "Hello #{ name }" 
  end

  greet = lambda(&method(:print_hello))
  greet.call("Prashant")
```

In this way we can convert a method into a proc object

Now have a look at this:

```ruby
   square = lambda{|*arr| arr.collect{|a| a*a }}
```
In ruby 1.8.7 we call

```ruby
 square.call(1,2,3)
```

but in ruby 1.9 we can call

```ruby
square.(1,2,3)
```

Suppose we have some lists(array) and we are doing any operation using map/collect, take for an example:
 
 <code>priority_countries.map{|country| [country.code, country.capitalize]}</code>... (1),<br/>
 if we are doing this task again n again, then it is a better idea to make a helper method and use lambda like this: 

```ruby
  converter = lambda{|list| list.map{ |element| [element.code, element.capitalize]} }
```

 Now we can get same result as (1) through
```ruby
converter[priority_countries]
```
 One last thing not specially about lambda but yes its about Proc object
 Suppose we have an array <code>array  = [3, 5, 9]</code>
 we have some method say:
```ruby
   def square(x)
    x*x
   end
``` 
We can call this like 
  <code>
    array.map{|x| square(x)}
  </code>
<br/>
  What if we want to call like this <code>array.map(&:square) </code> ... (2). So for this we have to convert square method into proc object.
</p>

We can finally achieve (2) by writing following code

```ruby
class Fixnum
 
   def to_proc
    lambda {|x, *args| x.send(self, *args)}
   end
  
   def square
    self*self
   end

end
```

```
array  = [3, 5, 9]
array.map(&:square)
```

For more explanation  about "to_proc", please refer
[here](http://pragdave.pragprog.com/pragdave/2005/11/symbolto_proc.html)


<p>
Hope this post has helped you in increasing understanding of blocks. Thanks for reading.
</p>

