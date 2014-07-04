---
layout: post
title: Single Sign on in Rails
twitter: _prashantsahni
author: Prashant Sahni
tags: rails
social: true
---

## Requirement

User should be able to maintain the session ( authenticated ) on multiple websites   ( apprentely from the same group/network/domain ) with sign in just once.<br/>

####Example:
User sign in to gmail, he/she gets automatically signed in to youtube or any other website from the google.<br/>
<br/>

###Basic Idea:

<p>
    Here is a high level pictorial representation of the concept. <br/>
    The following image I copied from <a  target='_blank' href="http://merbist.com/2012/04/04/building-and-implementing-a-single-sign-on-solution/">here.</a>
    Thank you <a href="http://matt.aimonetti.net/" target='_blank'>Matt Aimonetti</a>
    <img src="/images/sso-login.png" alt='sso-login-image'/>
    <br/>
    <br/>
    Now read this explanation  at this <a href="http://rubycas.github.io/" target='_blank'>link</a><br/>
    <img src="/images/basic_cas_single_signon_mechanism_diagram.png" alt="">
</p>


###Note:
<p>

I have copied this images shamelessly. The goal is to put the information into top of the head in organized manner, so that somebody can start with it.
Thank you so much to the author of the website.
</p>


<p>
    <h3>How To Implement:</h3>
    <h5>Setting up server</h5>
    <ul>
        <li>Implementation is little bit tricky, but not too difficult. We have to have a database with authentication information of user accounts and that database should be shared
            across all the target applications.
        </li>
        <li>
            User access the application to which he desired to login, if he is not logged in, then he gets redirected to SSO server with 'service' parameter set to name of the website.
            The SSO server  application renders the login page.
        </li>
    </ul>
</p>

<p>
    We need to have a master website( or cas server) and a client website( which is going to use cas server, they will be cas protected ).
</p>


Lets start.

1. Clone <a href="https://github.com/rubycas/rubycas-server" target='_blank'>rubycas-server</a>
```
git clone https://github.com/rubycas/rubycas-server
```

2. Follow the Readme

3. If you are following things mentioned above, then clearly a question comes, how the users account information will be stored at the cas server.
What I figured out, I am telling you. Please copy this table structure into ```db/migrate/001_create_initial_structure.rb```
( Ideally there should be an app folder in <a href="https://github.com/rubycas/rubycas-server" target='_blank'>rubycas-server</a> which should have controllers and models )

```ruby

    # Creating User table for storing users credentials
    create_table "users", :force => true do |t|
     t.string   "email",                                 :default => "", :null => false
     t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
     t.string   "reset_password_token"
     t.datetime "reset_password_sent_at"
     t.datetime "remember_created_at"
     t.integer  "sign_in_count",                         :default => 0
     t.datetime "current_sign_in_at"
     t.datetime "last_sign_in_at"
     t.string   "current_sign_in_ip"
     t.string   "last_sign_in_ip"
     t.string   "username"
     t.string   "encryption_salt"
     t.datetime "created_at",                                            :null => false
     t.datetime "updated_at",                                            :null => false
    end
```

4. Run server as mentioned in the Readme, the server boot process will run the migrations automatically. The server should be running at the port, you have mentioned in config.yml.
 You must be having a screen like this
 <img src="/images/cas_server_image.png" alt=""/> <br/><br/>
5. Now make an script to insert users into the database, because till now you have no sign up mechanism.


#####Setting up SSO Client

<p>
    I have made a sso client in rails, please clone it, follow the Readme, and run it on your local machine
    <a href="https://github.com/psahni/sso_client_rails" target='_blank'>https://github.com/psahni/sso_client_rails</a>
</p>

<p>
 After successful login you will see following screen <br/>
 <img src="/images/client_sso.png" alt="">
</p>