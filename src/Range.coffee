###
  range is a utility object that can create arrays with all natural number in a 
  given range. Convenient for people who do not use Coffeescript. 
  
  @author Mads Hartmann Jensen. 
###

mugs.provide("mugs.range")

mugs.range = {}

###*
  Creates an array with all the numbers between from and to inclusive. 

  @param from   The lower bound of the range  (included)
  @param to      The upper bound of the range (included)  
  @return An array with all the numbers between from and to inclusive. 
###
mugs.range.to = (from, to) -> [from..to]

###*
  Creates an array with all the numbers between from and until. From 
  is included, until isn't.
  
  @param from   The lower bound of the range (included)
  @param until_ The upper bound of the range  (excluded)
  @return An array with all the numbers between from and until. From 
          is included, until isn't.
###
mugs.range.until = (from, until_)  -> [from..until_-1]