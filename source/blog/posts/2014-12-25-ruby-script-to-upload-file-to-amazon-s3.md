---
layout: post
title: Ruby script to upload file to Amazon-S3
twitter: _prashantsahni
author: Prashant Sahni
tags: rails
social:
---


One can upload directly to Amazon S3. Please have a look at this article <a href='http://aws.amazon.com/articles/1434'>http://aws.amazon.com/articles/1434</a>, where file is uploaded
through HTML POST form. We can achieve the same thing through ruby script. I wrote this script for testing environment.

Uploading to S3 using using HTTP POST requires a few prerequesits, one of which is a policy document which S3 uses for authorization and imposes limits on the files that can be uploaded and the other is a signed version of this document known as a signature.


```ruby

require 'json'
require 'rest-client'
require 'base64'
require 'openssl'
require 'digest/sha1'

class S3UploadTest

  def initialize(file)
    @file = file
  end

  def upload
    bucket            = ENV['CAN_UPLOAD_BUCKET']                     # Save these variabes in your environment
    access_key_id     = ENV['CAN_UPLOAD_AWS_ACCESS_KEY_ID']
    secret_access_key = ENV['CAN_UPLOAD_AWS_ACCESS_KEY_KEY']
    acl               = 'public-read'
    content_type      = 'multipart/form-data'
    expiration_date   =  10.hours.from_now
    max_filesize      =  500.megabytes

    policy_document =
      {"expiration" =>  "2015-01-01T00:00:00Z",
       "conditions" =>  [
        {"bucket" =>  "#{bucket}"},
        {"x-amz-server-side-encryption" => 'AES256'},
        ["starts-with", "$key", "uploads/#{File.basename(@file)}"],
        {"acl" =>  "public-read"},
        ["content-length-range", 0, 1048576]
      ]
    }
    policy = Base64.encode64(policy_document.to_json).gsub(/\n|\r/, '')
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_access_key, policy)).gsub("\n","")

		fields = { 
		           :key => "uploads/#{File.basename(@file)}",
		           :acl => "public-read" , 
		           'x-amz-server-side-encryption' => 'AES256', 
		           "AWSAccessKeyId" => "#{ access_key_id }", 
		           'Policy' => "#{ policy }", 
		           'Signature' => "#{ signature }",
                 :file => "#{ @file }", 
                 :multipart => true
              }
     headers = {
     				"x-amz-server-side-encryption" =>  'AES256', 
     				"Content-Type" => "#{ content_type }" 
     			}
     					
    # Request
    response = RestClient.post "https://#{ bucket }.s3.amazonaws.com", fields, headers
    if response.code == 204
    	puts "[ File is uploaded to Amazon S3! ]"
    else
     puts "[ File is not uploaded to Amazon S3! ]"
     puts "== Response:"
     puts response.inspect
    end
  end

end

file = '/path/to/file'
S3UploadTest.new(file).upload

```

Execute it - 
```
 ruby s3_upload_test
```
