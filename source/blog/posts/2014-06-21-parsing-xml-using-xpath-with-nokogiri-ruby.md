---
layout: post
title: Parsing XML using XPATH with nokogiri ruby
twitter: _prashantsahni
author: Prashant Sahni
tags: rails
social:
---


XPath is a language for finding information in an XML file. XPath is used to navigate through elements and attributes in an XML document.
We can also use XPath to traverse through an XML file in Ruby. We will Nokogiri gem for that.

Xpath is a very powerful tool to fetch the relevant information, read items and attributes from xml file.

Please read about the xpath syntax from following link -

<a href='http://www.w3schools.com/xpath/xpath_syntax.asp' target='_blank'><img src='/assets/images/xpath.png' style='width:25%;'/></a>


For demo, let us consider an xml file that holds information of employees.

```xml
<?xml version="1.0"?>
<Employees>
    <Employee id="1111" type="admin">
        <firstname>John</firstname>
        <lastname>Watson</lastname>
        <age>30</age>
        <email>johnwatson@sh.com</email>
    </Employee>
    <Employee id="2222" type="admin">
        <firstname>Sherlock</firstname>
        <lastname>Homes</lastname>
        <age>32</age>
        <email>sherlock@sh.com</email>
    </Employee>
    <Employee id="3333" type="user">
        <firstname>Jim</firstname>
        <lastname>Moriarty</lastname>
        <age>52</age>
        <email>jim@sh.com</email>
    </Employee>
    <Employee id="4444" type="user">
        <firstname>Mycroft</firstname>
        <lastname>Holmes</lastname>
        <age>41</age>
        <email>mycroft@sh.com</email>
    </Employee>
</Employees>
```

As we can see there are 4 employeees. Attributes - id, type. Child nodes - firstname, lastname, age and email.

Lets write code..

We are going to use Nokogiri ruby gem that provides a beautiful api for parsing, ability to search documents via Xpath. More info - [nokogiri](http://nokogiri.org/)

<img src='/assets/images/nokogiri.png' style='width:60%;'/>

* Install the gem
```
 gem install nokogiri
```

## Examples:

Ex 1. Read firstname of all employees

```ruby
require 'nokogiri'
f = File.open("employee.xml")
doc = Nokogiri::XML(f)

puts "== First name of all employees"
expression = "Employees/Employee/firstname"
nodes = doc.xpath(expression)

nodes.each do |node|
  p node.text
end
```
```
"John"
"Sherlock"
"Jim"
"Mycroft"
```

Ex 2. Read a specific employee using employee id

```ruby
expression = "/Employees/Employee[@emplid='2222']"
nodes = doc.xpath(expression)

nodes.children.each do |node|
 p "#{ node.name }: #{ node.text }"   if node.class == Nokogiri::XML::Element
end

```
```
"firstname: Sherlock"
"lastname: Homes"
"age: 32"
"email: sherlock@sh.com"
```

Ex 3. Read firstname of all employees who are admin

```ruby
expression = "/Employees/Employee[@type='admin']/firstname"
nodes = doc.xpath(expression)


nodes.each do |node|
 p "#{ node.text }"
end
```

```
"John"
"Sherlock"
```

Ex 4. Read firstname of all employees who are older than 40 year

```ruby
expression = "/Employees/Employee[age>40]/firstname"
nodes = doc.xpath(expression)


nodes.each do |node|
 p "#{ node.text }"
end
```
```
"Jim"
"Mycroft"
```

Ex 5. Read firstname of first two employees (defined in xml file)

```ruby
expression = "/Employees/Employee[position() <= 2]/firstname"
nodes = doc.xpath(expression)


nodes.each do |node|
 p "#{ node.text }"
end

```
```
"John"
"Sherlock"
```

Thanks for reading :-)