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

  @typedProperties ['title','tagline','credit','link','slug','body','mainCategory', 'createdBy', 'updatedBy', 'permalink'], String
  @typedProperties ['createdAt','updatedAt', 'publishedAt'], Date
  @typedProperties ['upVotes','downVotes','viewCount'], Number
  @typedProperties ['categories','tags'], [String], true #reactive
  @typedProperty 'published', Boolean
  @typedProperty 'linkToFeaturedImage', String
  @typedProperty 'featuredImage', Uint8Array
  #@typedProperty 'author', String