mugs.provide("mugs.Indexed")
mugs.require("mugs.Extensible")

###*
  (INTERFACE) Indexed are for collections where the items can be accessed with an index
  
  @class (INTERFACE) are for collections where the items can be accessed with an index
  @augments mugs.Extensible
###
mugs.Indexed = () -> this

mugs.Indexed.prototype = new mugs.Extensible()

###*
  Returns mugs.Some(index) of the first occurrence of the item in the collection if it exists.
  otherwise, mugs.None
  
  @param  item  The item to search for in the collection
  @return       mugs.Some(index) of the first occurrence of the item in the collection if it exists.
                otherwise, mugs.None
###
mugs.Indexed.prototype.indexOf = (item) -> 
  this.findIndex( (itm) -> item == itm )

###*
  Returns mugs.Some(index) of the last occurrence of the item in the collection if it exists.
  otherwise, mugs.None
  
  @param  item  The item to search for in the collection
  @return       mugs.Some(index) of the last occurrence of the item in the collection if it exists.
                otherwise, mugs.None
###  
mugs.Indexed.prototype.lastIndexOf = (item) ->
  this.findLastIndex( (itm) -> itm == item )

###*
  Returns mugs.Some(index) of the first element satisfying a predicate, or mugs.None

  @parem  p The predicate to apply to each object
  @return   mugs.Some(index) of the first element satisfying a predicate, or mugs.None
###
mugs.Indexed.prototype.findIndex = (f) -> 
  index = new mugs.None()
  i = 0 
  this.forEach( (itm) -> 
    if f(itm) && index.isEmpty()
      index = new mugs.Some(i)
      i++
    else
      i++
  )
  return index

###*
  Returns mugs.Some(index) of the last element satisfying a predicate, or mugs.None

  @parem  p The predicate to apply to each object
  @return   mugs.Some(index) of the last element satisfying a predicate, or mugs.None
###
mugs.Indexed.prototype.findLastIndex = (f) -> 
  index = new mugs.None()
  i = 0 
  this.forEach( (itm) -> 
    if f(itm)
      index = new mugs.Some(i)
      i++
    else 
      i++
  )
  return index