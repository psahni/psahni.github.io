---
layout: post
title: Mocking Apis - Integration Testing with protractor in AngularJs
date: 2014-09-28 11:33 UTC
tags:
twitter: _prashantsahni
author: Prashant Sahni
social: true
---

In integration testing we test END TO END userworkflow, testing different components tied together. We do not test the underlying implementation
in integration testing. It is essentially about testing rendering of pages, elements of UI and user interaction over them.


<strong>Example</strong>: User fills the form, submits it after filling data and redirected to certain page.

Here is an high level case -

```javascript
  describe("User Registration", function() {
    
    beforeEach(function(){
      //............
    });

  });
```

The framework that is used for Angular JS integration testing is Protractor. It a wrapper over Webdriver.js.
<a href='https://github.com/angular/protractor' target='_blank'><img src='/assets/images/protractor.png'></a>

I am here going to explain you a scenario where you need to test an application which is calling an external api.
The application is consuming api from the api provider.

When we test our app, we don't want that test environment should send request to our real server. What we actually want is
to mock the service which will respond with out any processing or unintelligently.
