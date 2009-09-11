#!/usr/bin/env ruby

$DBG = true

require "nitro"
require "og"

include Nitro

require "part/admin"
#require "part/system"

require "app/setup"
require "app/skin"
require "app/model/post"
require "app/model/comment"
require "app/model/category"
require "app/controller/post"
require "app/controller/comment"
require "app/controller/category"

app = Application.new()
app.dispatcher.root = Post
app.dispatcher.root.comments = Comment
app.dispatcher.root.categories = Category
app.start

