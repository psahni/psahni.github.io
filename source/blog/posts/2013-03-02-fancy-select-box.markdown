---
layout: post
title: Fancy Select Box
twitter: _prashantsahni
author: Prashant Sahni
tags: jquery
social: true
---

Often we use HTML select dropdown for providing choices to user depending upon the usecase.

Like we have a code

```html
  <select>
    <option value="Red">Red</option>
    <option value="Yellow">Yellow</option>
    <option value="Green">Green</option>
  </select>
```

This results into a normal select dropdown

<a><img src="http://i49.tinypic.com/etzaqu.jpg" border="0" alt="Image and video hosting by TinyPic" style="width:auto"></a>

Now a little bit of javascript and css will turn this normal dropdown into something fancy

<a><img src="http://i48.tinypic.com/dliash.png" border="0" alt="Image and video hosting by TinyPic" style="width:auto"></a>


##Usage

#### Javscript

The fancy dropdown uses bootstrap downdown script.

Download the script from <a href="http://twitter-bootstrap.node1.zygote.cc/javascript.html#dropdown" target="_blank">here</a>

If you are not familiar with Twitter Bootstrap, then please go through its javascript components <a href="http://twitter.github.com/bootstrap/javascript.html" target="_blank">here</a>

Here is the required the js that delivers the required output

```javascript
jQuery(function($){
    $('select.dropdown').each(function(i, e){
        if (!($(e).data('convert') == 'no')) {
            $(e).hide().wrap('<div class="btn-group" id="select-group-' + i + '" />');
            var select = $('#select-group-' + i);
            var current;
            if( $(e).val().length ){
                current = $(e).find("option:selected").text();
            }
            else{
                current = "Select"
            }
            select.html('<input type="hidden" value="' + $(e).val() + '" name="' + $(e).attr('name') + '" id="' + $(e).attr('id') + '" class="' + $(e).attr('class') + '" /><a class="btn" href="javascript:;">' + current + '</a><a class="btn dropdown-toggle" data-toggle="dropdown" href="javascript:;"><span class="caret"></span></a><ul class="dropdown-menu"></ul>');
            $(e).find('option').each(function(o,q) {
                select.find('.dropdown-menu').append('<li><a href="javascript:;" data-value="' + $(q).attr('value') + '">' + $(q).text() + '</a></li>');
                if ($(q).attr('selected')) select.find('.dropdown-menu li:eq(' + o + ')').click();
            });
            select.find('.dropdown-menu a').click(function() {
                select.find('input[type=hidden]').val($(this).data('value')).change();
                select.find('.btn:eq(0)').text($(this).text());
            });
        }
    });
});
```

#### CSS

We are going use  bootstrap css that is relevant to this fancy dropdown

Here it is

```css
ul, ol{
  padding: 0;
  margin: 0 0 10px 25px;
}

li {
    line-height: 20px;
}

label {
    display: block;
    margin-bottom: 5px;
}
label, input, button, select, textarea {
    font-size: 14px;
    font-weight: normal;
    line-height: 20px;
}

select {
    width: 220px;
    background-color: white;
    border: 1px solid #CCC;
}

.btn-group {
    position: relative;
    display: inline-block;
    font-size: 0;
    white-space: nowrap;
    vertical-align: middle;
}
.btn-group > .btn {
    position: relative;
    -webkit-border-radius: 0;
    -moz-border-radius: 0;
    border-radius: 0;
}

.btn-group > .btn, .btn-group > .dropdown-menu, .btn-group > .popover {
    font-size: 14px;
}

.btn-group > .btn + .dropdown-toggle {
    padding-right: 8px;
    padding-left: 8px;
    -webkit-box-shadow: inset 1px 0 0 rgba(255, 255, 255, 0.125), inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
    -moz-box-shadow: inset 1px 0 0 rgba(255, 255, 255, 0.125), inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
    box-shadow: inset 1px 0 0 rgba(255, 255, 255, 0.125), inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
}

.btn-group > .btn + .btn {
    margin-left: -1px;
}

.btn-group > .btn:last-child, .btn-group > .dropdown-toggle {
    -webkit-border-top-right-radius: 4px;
    border-top-right-radius: 4px;
    -webkit-border-bottom-right-radius: 4px;
    border-bottom-right-radius: 4px;
    -moz-border-radius-topright: 4px;
    -moz-border-radius-bottomright: 4px;
}

.btn {
    border-color: #C5C5C5;
    border-color: rgba(0, 0, 0, 0.15) rgba(0, 0, 0, 0.15) rgba(0, 0, 0, 0.25);
}

.btn .caret {
    margin-top: 8px;
    margin-left: 0;
}
.caret {
    display: inline-block;
    width: 0;
    height: 0;
    vertical-align: top;
    border-top: 4px solid black;
    border-right: 4px solid transparent;
    border-left: 4px solid transparent;
    content: "";
}
.open > .dropdown-menu {
    display: block;
}

.dropdown-menu {
    position: absolute;
    top: 100%;
    left: 0;
    display: none;
    float: left;
    min-width: 160px;
    padding: 5px 0;
    margin: 2px 0 0;
    list-style: none;
    background-color: white;
    border: 1px solid #CCC;
    border: 1px solid rgba(0, 0, 0, 0.2);
    -webkit-border-radius: 6px;
    -moz-border-radius: 6px;
    border-radius: 6px;
    -webkit-box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
    -moz-box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
    -webkit-background-clip: padding-box;
    -moz-background-clip: padding;
    background-clip: padding-box;
}

.dropdown-menu li > a:hover,
.dropdown-menu li > a:focus,
.dropdown-submenu:hover > a {
    color: #ffffff;
    text-decoration: none;
    background-color: #0081c2;
    background-image: -moz-linear-gradient(top, #0088cc, #0077b3);
    background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#0088cc), to(#0077b3));
    background-image: -webkit-linear-gradient(top, #0088cc, #0077b3);
    background-image: -o-linear-gradient(top, #0088cc, #0077b3);
    background-image: linear-gradient(to bottom, #0088cc, #0077b3);
    background-repeat: repeat-x;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff0088cc', endColorstr='#ff0077b3', GradientType=0);
}
.dropdown-menu li > a {
    color: #333333;
    padding: 3px 20px;
    clear:both;
    display: block;
}

.btn {
    display: inline-block;
    *display: inline;
    padding: 4px 12px;
    margin-bottom: 0;
    *margin-left: .3em;
    font-size: 14px;
    line-height: 20px;
    color: #333333;
    text-align: center;
    text-shadow: 0 1px 1px rgba(255, 255, 255, 0.75);
    vertical-align: middle;
    cursor: pointer;
    background-color: #f5f5f5;
    *background-color: #e6e6e6;
    background-image: -moz-linear-gradient(top, #ffffff, #e6e6e6);
    background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#ffffff), to(#e6e6e6));
    background-image: -webkit-linear-gradient(top, #ffffff, #e6e6e6);
    background-image: -o-linear-gradient(top, #ffffff, #e6e6e6);
    background-image: linear-gradient(to bottom, #ffffff, #e6e6e6);
    background-repeat: repeat-x;
    border: 1px solid #bbbbbb;
    *border: 0;
    border-color: #e6e6e6 #e6e6e6 #bfbfbf;
    border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
    border-bottom-color: #a2a2a2;
    -webkit-border-radius: 4px;
    -moz-border-radius: 4px;
    border-radius: 4px;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffffff', endColorstr='#ffe6e6e6', GradientType=0);
    filter: progid:DXImageTransform.Microsoft.gradient(enabled=false);
    *zoom: 1;
    -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
    -moz-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
    height: 20px;
}

```







