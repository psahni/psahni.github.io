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
	browser().navigateTo('/signup');
});

it("ensure user can signup for the application", function(){
	var first_name = element(by.id('FirstName'));
	first_name.sendKeys("Mark");

	var last_name = element(by.id('LastName'));
	last_name.sendKeys('Edwards');

	var email = element(by.id('Email'));
	email.sendKeys('mark@nulightsolutions.com');

	var password = element(by.id('password'));
	var confirm_password = element(by.id('confirm-password'));
	password.sendKeys('passwOrd');
	confirm_password.sendKeys('passwOrd');

	var button = element(by.id('signup-button'));
	button.click();

	expect(browser.getCurrentUrl()).toMatch('someUrlString');
});

});
```

The framework that is used for Angular JS integration testing is Protractor. It a wrapper over Webdriver.js.
<a href='https://github.com/angular/protractor' target='_blank'><img src='/assets/images/protractor.png'></a>

Protractor is an end to end testing framework for AngularJS applications. It uses webdriver to control browser activities, it runs on the top of Selenium because it is based on webdriver protocols. Protractor uses Jasmine for its test syntax. So its a nice wrapper over selenium and jasmine.

I am here going to explain you a scenario where you need to test an application which is calling an external api.
The application is consuming api from the api provider.

When we test our app, we don't want that test environment should send request to our real server. What we actually want is
to mock the service which will respond with unintelligently or out any processing.

We create dump version of the service which simply returns the desired response.


<h2>$httpBackend</h2>
As per angular js documentation this is Fake HTTP backend implementation suitable for end-to-end testing or backend-less development of applications that use the $http service.
This service is used to intercept the request.

There are 2 different implementations of $httpBackend for faking/mocking HTTP requests: one for unit testing, provided by the ngMock service, and one for E2E testing, provided by ngMockE2E. To set up an E2E test, we should have a module that depends on ngMockE2E and the application module.

<h2>Using $httpBackend to mock HTTP requests</h2>
The following example shows how to mock a login request.
Suppose ngApp is 'userManagement'. Lets create a mock version of the module 'userManagementMock'.

```javascript
var expected_response = {'id' : 'abcd1234'};
angular.module('userManagementMock', ['userManagement', 'ngMockE2E'])
   .run(function ($httpBackend) {
      $httpBackend.whenPOST('https://api.example.com/users/login').respond(function(){
       return [200, expected_response];
      });
    $httpBackend.whenGET(/.*/).passThrough();
 });
```

$httpBackend.whenGET(/.*/).passThrough() - It just passes all the requests that we are not mocking. We should not be mocking
requests which are loading templates, scripts from the server.
