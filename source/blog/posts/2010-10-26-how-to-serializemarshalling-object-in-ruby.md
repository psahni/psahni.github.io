---
layout: post
title: How to Serialize-(marshalling) Object in Ruby
twitter: _prashantsahni
author: Prashant Sahni
tags: ruby
social: true
---
It happens many times that we want to store data on the persistance storage for using it some time later

##Marshalling

Marshalling is the process by which we can serialize  and unserialize ruby object in our ruby programs.
The data that is stored can be read and the original object can be reconstituted.
So, In marshalling we are actually recording the data(state + code) of the object in such a way that when it is unmarshalled it can be retained into original object with its data.A more general explanation given <a href='http://www.wisegeek.com/in-computer-programming-what-is-marshalling.htm' target='_blank'>here</a>

Suppose we have data

```ruby

users_data = {
               "users_status" => ['inactive', 'active', 'suspended', 'deleted'],   
               "default_settings" => [{:send_notification=> 'true', :subscribe_to_news_letter => '1'}]
            }
```

I'll do Marshalling + encoding of data that can be used to store in database

So,i can do like

```ruby

users_data.keys.each do |key|
  UserData[key.to_s] = users_data[key]
end
```

In UserData model, i can write something like:

```ruby

#User(kind, value, created_at, updated_at)
class UserData

 def []=(kind, value)
   user_data = self.find_by_kind(kind.to_s) || self.new(:kind => kind.to_s)
   user_data.value = Base64.encode64(Marshal.dump(value))
   user_data.save 
 end

 def self.[](kind)
  user_data = UserData.find_by_kind(kind.to_s)
  user_data ? Marshal.load(Base64.decode64(user_data.value)) : nil
 end
end
```
A very good use case and a very simple code, please let me know if there any difficulty in understanding
