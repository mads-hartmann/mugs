###
  
###

mugs.provide("mugs.range")

mugs.range = {}

###*
  Creates an array with all the numbers between from and to inclusive. 
###
mugs.range.to = (from, to) -> [from..to]

###*
  Creates an array with all the numbers between from and until. From 
  is included, until isn't.
###
mugs.range.until = (from, until_)  -> [from..until_-1]