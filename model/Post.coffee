###
# Post format - for future validation etc! -->
title: String
tagline: String
credit: String, who to credit if external
link: String, validated as an http link, if external - original post
categories: Array of String
mainCategory: String
tags: Array of String
body: String (markdown)
slug: String
updatedAt: Date
updatedBy: Meteor.userId()
createdAt: Date
###

class @Post extends DataType
  constructor: (post)->

  @typedProperties ['title','tagline','credit','link','slug','body','mainCategory', 'createdBy', 'updatedBy'], String
  @typedProperties ['createdAt','updatedAt'], Date
  @typedProperties ['likeCount','viewCount'], Number
  @typedProperties ['categories','tags'], [String]
  @typedProperty 'published', Boolean
  #@typedProperty 'author', String