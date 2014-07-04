---
layout: post
title: How to exclude files in rcov(a-code-coverage-tool-in-ruby)
twitter: _prashantsahni
author: Prashant Sahni
tags: rspec
social: true
---

Today i was working on  one of my project for increasing test coverage , i want to exclude some files from testing because they are not needed, for example: helpers
I am using rspec framework for testing,  In spec folder there is a file rcov.opts, in this file we have --exclude option. We can append our path of files to this. for example I want to exclude helpers , sweepers folders, so i just did

```ruby
  --exclude "helpers/*,app/sweepers/*"
```

</p>
<p>
Then when i ran 
```ruby
rake spec:rcov
``` then the excluded files did not appear in the statistics appeared in index.html file
</p>
