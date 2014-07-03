---
layout: post
title: "Backbone.js todo application with rails as backend"
twitter: _prashantsahni
author: Prashant Sahni
tags: Backbone, rails
social: true
---


<p>
  The application is based on <a href="http://documentcloud.github.com/backbone/docs/todos.html">this</a> example todo application which uses local storage for backend.
  The app is created by  <a href="http://jgn.me/">Jerome Gravel-Niquet</a>.<br/> <a href="https://github.com/addyosmani">Addy Osmani</a> is the creator of <a href="http://backbonejs.org/">Backbone.js</a> 
  <br/>
</p>

#### Generate the todo model

```ruby

 $ rails g model Todo title:string completed:boolean completed_at:datetime
 $ rake db:migrate

```

#### Gemfile

```ruby
source 'https://rubygems.org'
gem 'rails', '3.2.8'
gem 'mysql2'
gem 'jquery-rails'
gem 'backbone-on-rails'
gem 'jasminerice'
gem "ejs", '1.1.1'
gem 'uglifier', '>= 1.0.3'
gem 'execjs'
gem 'therubyracer'
```

```
 $ bundle install
```

Read about backbone-on-rails gem <a href="https://github.com/meleyal/backbone-on-rails" target="_blank">here</a> <br/>
<a href="https://github.com/codebrew/backbone-rails" target="_blank">Backbone-rails</a> is also a very nice gem. You can use it too.<br/>
  

Then,

```ruby
   $ rails generate backbone:install --javascript
```

What it does it simply creates model, collection, router, view and template path. See the installation code

[Here](https://github.com/meleyal/backbone-on-rails/blob/master/lib/generators/backbone/install/install_generator.rb)

It requires the needed dependencies in application.js, see 40th line of the installation code.

<strong>Directory structure of app folder </strong>
<img src="/images/backbone_app1.png" alt="" /><br />
Dependencies is a extra directory that i created.

  Hope you have basic understanding of Backbone.js.

  [Here](http://addyosmani.github.com/backbone-fundamentals/) is a very nice book by the creator of Backbone.js.

  Now read about [underscore.js](http://underscorejs.org/), javascript templating,

  if you are not familiar with it. underscore.js is a dependency of backbone.js.

  See one example code using underscore.js [EJS](https://gist.github.com/3379332).

  [Embedded JavaScript](http://embeddedjs.com/) templates are used in this application.

  Read [Here](http://stackoverflow.com/questions/6557238/format-of-ejs-and-jst-template-files-in-rails-backbone-gem)

<!--
  Oh! you have watched this source code. Welcome :-)
  * Under score.js links
  http://wynnnetherland.com/journal/rubyists-meet-underscore-js-your-new-favorite-javascript-library
  http://embeddedjs.com/getting_started.html
  http://www.bigjason.com/blog/precompiled-javascript-templates-rails-3-1
-->

<u>Backbone Todo Model</u> - /assets/javascripts/models/todo.js

```javascript
  var app = app || {};
  $(function($){
      'use strict';
      app.Todo = Backbone.Model.extend({
          defaults:{
             title: '',
             completed: false 
          },
          toggle: function() {
              this.url = "/api/todos/" + this.attributes.id + "/completed";
			        this.save({
			  	    completed: !this.get('completed')
			      });
		    }
      });
  });

```

<u>Backbone todo collection</u> - /assets/javascripts/collectitons/todos.js

```javascript
    var app = app || {};
    $(function($){
        'use strict';
        var TodoList = Backbone.Collection.extend({
           url: "/api/todos" ,
           model: app.Todo,
         completed: function() {
		      return this.filter(function( todo ) {
			      return todo.get('completed');
		      });
	      },
           nextOrder: function() {
		      if ( !this.length ) {
			      return 1;
           }
          },
          // Filter down the list to only todo items that are still not finished.
	      remaining: function() {
		      return this.without.apply( this, this.completed() );
	      },
	      comparator: function(todo){
		      return todo.get('order');
	      }
		
        });
        
        app.Todos = new TodoList();
    });
```

<p>
  May be you are not getting all code into head if you are new. I find it difficult in starting. It takes a bit time to understand it all.
</p>

<u>Backbone todo views </u> - /assets/javascripts/views/todo.js

```javascript

var app = app || {};
$(function($){
  'use strict';
  app.TodoView = Backbone.View.extend({
    tagName:  'li',
    template: JST["todos/todo"],
    initialize: function(){
    this.model.on( 'change', this.render, this );
    this.model.on( 'destroy', this.remove, this );
    this.model.on( 'visible', this.toggleVisible, this );
  },
  events:{
    'click .destroy':	'clear' ,
    'keypress .edit':	'updateOnEnter',
    'dblclick label':	'edit',
    'blur .edit':		'restore',
    'click .toggle':	'togglecompleted'
  },
  render: function() {
    this.$el.html( this.template( this.model.toJSON() ) );
    this.$el.toggleClass( 'completed', this.model.get('completed') ); //** Mark if completed **
    this.toggleVisible();                                            //**  Hide or Visible
    this.input = this.$('.edit');
    return this;
  },
  toggleVisible : function () {
    this.$el.toggleClass( 'hidden',  this.isHidden());
  },
  isHidden : function () {
    var isCompleted = this.model.get('completed');
    return ( // hidden cases only
    (!isCompleted && app.TodoFilter === 'completed')
    || (isCompleted && app.TodoFilter === 'active')
    );
  },
  // Remove the item, destroy the item from server and delete its view.
  clear: function() {
    this.model.destroy();
  },
  togglecompleted: function() {
    this.model.toggle();
  },
  // If you hit `enter`, we're through editing the item.
  updateOnEnter: function( e ) {
    if ( e.which === ENTER_KEY ) {
    this.close();
    }
  },
  // Close the `"editing"` mode, saving changes to the todo.
  close: function() {
    var value = this.input.val().trim();
    if ( value ) {
    this.model.save({ title: value});
    } else {
    this.clear();
    }
    this.$el.removeClass('editing');
  },
  // Switch this view into `"editing"` mode, displaying the input field.
  edit: function() {
    this.$el.addClass('editing');
    this.input.focus();
  },
  restore: function(){
    this.$el.removeClass('editing');
  }
 });
})

```

<u>Backbone todo template</u> - /assets/templates/todos/todo.jst.ejs

```
 <div class="view">
   <input class="toggle" type="checkbox" <%= completed ? 'checked' : '' %>>
   <label><%- title %></label>
   <button class="destroy"></button>
 </div>
 <input class="edit" value="<%- title %>">
```

<u>Backbone todo template</u> - /assets/templates/todos/index.jst.ejs

```
<div id="todoapp">
  <div id="title">
    <h1>Todos</h1>		
  </div>
  <div class="content">
    <div id="create-todo">
      <input id="new-todo" placeholder="What needs to be done?" type="text" />
      <span class="ui-tooltip-top" style="display:none">Press Enter to save this task</span>
    </div>
    <div id="todos">
      <ul id="todo-list"></ul>
    </div>
    <div id="todo-stats"></div>
  </div>
</div>

<ul id="instructions">
  <li>Double-click to edit a todo.</li>
</ul>
```

<u>Backbone todo template</u> - /assets/templates/todos/stats.jst.ejs

```
<span id="todo-count"><strong><%= remaining %></strong> <%= remaining === 1 ? 'item' : 'items' %> left</span>
<ul id="filters">
  <li>
    <a class="selected" href="#/">All</a>
  </li>
  <li>
    <a href="#/active">Active</a>
  </li>
  <li>
    <a href="#/completed">Completed</a>
  </li>
</ul>
<% if (completed) { %>
  <button id="clear-completed">Clear completed (<%= completed %>)</button>
<% } %>
```

<u>Backbone todo views </u> - /assets/javascripts/views/app.js

```javascript
var app = app || {};
$(function($){
  app.AppView = Backbone.View.extend({
    el: '#todoapp',
    statsTemplate: JST['todos/stats'],
    events: {
    'keypress #new-todo': 'createOnEnter',
    'click #clear-completed': 'clearCompleted',
    'click #toggle-all': 'toggleAllComplete'
   },
  initialize: function(){
   this.input = this.$('#new-todo');
   this.allCheckbox = this.$('#toggle-all')[0];
   this.$footer = this.$('#footer');
   this.$main = this.$('#main');

   app.Todos.on( 'add', this.addOne, this );
   app.Todos.on( 'reset', this.addAll, this );
   app.Todos.on( 'change:completed', this.filterOne, this );
   app.Todos.on( 'filter', this.filterAll, this );
   app.Todos.on( 'all', this.render, this );


   app.Todos.fetch(); // -> It is sending request to /api/todos and it will call 'all' and 'reset' method
  },  
  render: function(){
    var completed = app.Todos.completed().length;
    var remaining = app.Todos.remaining().length;

    if ( app.Todos.length ) {
      this.$main.show();
      this.$footer.show();
      this.$footer.html(this.statsTemplate({
      completed: completed,
      remaining: remaining
    }));
    this.$('#filters li a').removeClass('selected')
                           .filter('[href="#/' + ( app.TodoFilter || '' ) + '"]')
                           .addClass('selected');
   } 
   else {
      this.$main.hide();
      this.$footer.hide();
    }
    this.allCheckbox.checked = !remaining;
  },
  // Generate the attributes for a new Todo item.
  newAttributes: function() {
    return {
    title: this.input.val().trim(),
    order: app.Todos.nextOrder(),
    completed: false
   };
  },
  createOnEnter: function( e ) {
    if ( e.which !== ENTER_KEY || !this.input.val().trim() ) {
    return;
  }
  app.Todos.create( this.newAttributes() );
    this.input.val('');
  },
  // **Important Method**
  addOne: function( todo ) {
    var view = new app.TodoView({ model: todo });
      $('#todo-list').append( view.render().el );
    },
// Add all items in the **Todos** collection at once.
  addAll: function() {
    this.$('#todo-list').html('');
    app.Todos.each(this.addOne, this);
  },
  filterOne : function (todo) {
    todo.trigger('visible');
  },
  filterAll : function () {
    app.Todos.each(this.filterOne, this);
  },
  clearCompleted: function() {
    _.each( app.Todos.completed(), function( todo ) {
      todo.destroy();
    });

    return false;
  },

  toggleAllComplete: function() {
    var completed = this.allCheckbox.checked;
    app.Todos.each(function( todo ) {
    todo.save({
      'completed': completed
      });
    });
  }

  });
});

```

<u>Backbone todo router</u> - /assets/javascripts/routers/router.js
   
```javascript
var app = app || {};
$(function($) {
	'use strict';
	var Workspace = Backbone.Router.extend({
		routes:{
			'*filter': 'setFilter'
		},
		setFilter: function( param ) {
			// Set the current filter to be used
			app.TodoFilter = param.trim() || '';
			// Trigger a collection filter event, causing hiding/unhiding
			// of Todo view items
			app.Todos.trigger('filter');
		}
	});
	app.TodoRouter = new Workspace();
	Backbone.history.start();
});
```
</p>

<p>
    Recommended Article to have more understanding - <br/>
  <a href="http://patshaughnessy.net/2011/6/28/where-does-my-javascript-code-go-backbone-jst-and-the-rails-3-1-asset-pipeline" target="_blank">Where does my javascript code go? Backbone, JST and the Rails 3.1 asset pipeline</a>
</p>

<u>Rails Todos Controller</u> -  /app/controlles/todos_controller.rb

```ruby
class TodosController < ApplicationController

  respond_to :json

  def index
    respond_with Todo.all
  end

  def show
    respond_with Todo.find params[:id]
  end

  def create
    respond_with Todo.create params[:todo]
  end

  def update
    if params["todo_completed"] == "completed"
      respond_with Todo.complete params[:id], params[:todo]
   else
     respond_with Todo.update params[:id], params[:todo]  
    end
  end

  def destroy
    respond_with Todo.destroy params[:id]
  end


end
```  

<u>Rails Todo Model</u> - /app/models/todo.rb

```ruby

class Todo < ActiveRecord::Base
  
  attr_accessible :title, :complete_status, :completed
  

  def self.complete(id, attrs)
    Rails.logger.info("== Completing todo ==")
    todo  = find(id)
    todo.attributes = attrs
    todo.completed_at = Time.now
    todo.save
    return todo
  end
  
    
end

```


<u>Routes</u>

```ruby
  scope 'api' do
    resources :todos
  end
  match "/api/todos/:id/completed", :to => "todos#update", :todo_completed => "completed"
  root :to => 'home#index'
  match '*path', :to =>  'home#index'
```

<u>Make a home controller and write its index view as </u> -

```
<div id="todoapp">
  <header id="header">
    <h1>todos</h1>
    <input id="new-todo" placeholder="What needs to be done?" autofocus>
  </header>
  <section id="main">
    <input id="toggle-all" type="checkbox">
    <label for="toggle-all">Mark all as complete</label>
    <ul id="todo-list"></ul>
  </section>
  <footer id="footer"></footer>
</div>
<div id="info">
  <p>Double-click to edit a todo</p>
  <p>Written by <a href="https://github.com/addyosmani">Addy Osmani</a></p>
  <p>Part of <a href="http://todomvc.com">TodoMVC</a></p>
</div>
```

<u>Kick things off</u><br/>

Make a file todo_app.js - /assets/javascripts/todo_app.js and require it in application.js too

```javascript
    var app = app || {};
    var ENTER_KEY = 13;
    $(function() {
      new app.AppView();
    });
```

<p>
  Let me know if you face any problem while executing this code. Thanks
</p>

