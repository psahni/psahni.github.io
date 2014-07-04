---
layout: post
title: Thumbnail image fetcher for youtube and vimeo
twitter: _prashantsahni
author: Prashant Sahni
tags: ruby
social: true
---

<p>

If you want to show youtube or vimeo videos on your website, you can simplly get code to embed from the specfic video page or you can generate embed code for the video
on the basis of url of the video.
What if you want to have thumbnail images for the videos, useful if you want to make a video gallery, where each video in the gallery 
is respresented by the small thumbnail image, Here is a script that can help you.

</p>

<p>
  <h3>You tube</h3>
  In as you know every video as an id attached in the url of every video 
  for example: "http://www.youtube.com/watch?v=c_Q6bq3QTyk&feature=related".
  So, In this youtube video url,  'c_Q6bq3QTyk' is the id of the video.
  
  Now if I want to fetch the image for this video, youtube provides me four images at following urls, The first one 0.jpg( first one ) is a full size image, others are thumbnail images

    <a href='http://img.youtube.com/vi/YR12Z8f1Dh8/0.jpg' target='_blank'>http://img.youtube.com/vi/YR12Z8f1Dh8/0.jpg</a>
    <a href='http://img.youtube.com/vi/YR12Z8f1Dh8/1.jpg' target='_blank'>http://img.youtube.com/vi/YR12Z8f1Dh8/1.jpg</a>
    <a href='http://img.youtube.com/vi/YR12Z8f1Dh8/2.jpg' target='_blank'>http://img.youtube.com/vi/YR12Z8f1Dh8/2.jpg</a>
    <a href='http://img.youtube.com/vi/YR12Z8f1Dh8/3.jpg' target='_blank'>http://img.youtube.com/vi/YR12Z8f1Dh8/3.jpg</a>
</p>

<p>
  <h3>Vimeo</h3>
  In case of vimeo, every video has a url like http://vimeo.com/34918047, where 34918047 is an id of the video.
  Now what vimeo does it returns a json array which contains all the information about the video in key value pairs,
  For example: http://vimeo.com/34918047 video has a corresponding api url pointing to http://vimeo.com/api/v2/video/34918047.json, 
  that returns all the info about this video.
  The response has a key 'thumbnail_small' which has url for for small thumbnail image.
</p>
<p>
  Now the script
</p>
<!--
Old one
/youtube\.com\/watch\?v=([\w-]+)+&.+=(.+)/
-->
```ruby


#######################################################
# Thumbnail image fetcher for youtube or vimeo
#######################################################

require "net/http"
require "uri"
require 'rubygems'
require 'json'

class ImageFetcher

 PROVIDERS = { 
                 'youtube' => { 
                                :api_url => 'http://img.youtube.com/vi/', 
                                :regex => /youtube\.com\/watch\?v=([^&]+)/
                              },
                 'vimeo'   => { 
                                :api_url =>  'http://vimeo.com/api/v2/video/',
                                :regex => /vimeo\.com\/(.+)/
                              } 
               }
 

 DIR_NAME = 'images'
 YOUTUBE_THUMBNAIL_NO = 1
 NO_RESPONSE = 'No response' 
  
 def initialize(url)
  @url = url
  @matched_video_type = PROVIDERS.keys.find{ |k| @url.match(k) }
 end

 def thumbnail
   @thumbnail = fetch_thumbnail
 end
  
 
#--------------------------------------PRIVATE----------------------------------------------------------  

 private
  
 def fetch_thumbnail
   property = PROVIDERS[@matched_video_type]
   create_image_directory! unless File.exists?('images')
   @url.match(property[:regex])
   case @matched_video_type
    when 'youtube'
      complete_api_url = property[:api_url] + $1 + '/' + YOUTUBE_THUMBNAIL_NO.to_s + '.jpg'
      puts '=> Fetching youtube video image with id ' + "#{ $1 }"
      response = fetch_response(complete_api_url) 
      if response
        file_to_save = DIR_NAME + '/' + $1 + '_' + YOUTUBE_THUMBNAIL_NO.to_s + '_youtube.jpg'
        save_image(:data => response.body, :file_to_save =>  file_to_save)
     else
      puts NO_RESPONSE
     end
   when 'vimeo'
    complete_api_url = property[:api_url] + $1 + '.json'
    puts '=> Fetching vimeo video image with id ' + "#{ $1 }"
    response = fetch_response(complete_api_url) # The returned response is JSON
    if response
      json           =  JSON.parse(response.body)
      thumbnail_url  =  json[0]["thumbnail_small"]
      image_data     =  fetch_response(thumbnail_url)
      file_to_save   =  DIR_NAME + '/' + $1 + '_' + 'small' + '_vimeo.jpg'
      save_image(:data => image_data.body, :file_to_save => file_to_save)
    else
      puts NO_RESPONSE
    end
   else
    puts "=> The video type is not supported"  
   end
 rescue Exception => e
  puts e.message
 end
  
 def create_image_directory!
   Dir.mkdir( DIR_NAME )
 end
  
 def fetch_response(uri)
   uri = URI.parse(uri)
   response = Net::HTTP.get_response(uri)
   response
 end
 
 def save_image(options = {})
   puts "=> Saving image.."
   image_file = File.new( options[:file_to_save], 'w' )
   image_file.write( options[:data] )
 end
 
end

youtube = ImageFetcher.new('http://www.youtube.com/watch?v=zzQumRpqmDE&feature=fvwrel')
youtube.thumbnail
#vimeo = ImageFetcher.new('http://vimeo.com/37102493')
#vimeo.thumbnail
```

<p>
  Thanks for having a look. Please let me know if any enhancement or improvement.
</p>


