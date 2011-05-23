mugs.provide("mugs.Collection")

###*
  (INTERFACE) This is base prototype for all collections. It implements a set of methods for all collections 
  in terms of the forEach method. 
  
  This is to be considered a partial prototype. Prototypes which inherit from mugs.Collection will have
  to implement two methods: forEach and buildFromArray
  
  The forEach method should be implemented as efficiently as possible as this is used to implement
  all the methods in the mugs.Collection prototype. The buildFromArray method should simply be a constructor 
  for the prototype which takes a plain old javascript array. 
  
  @class (INTERFACE) Collection is the base interface that all collections implements.
###
mugs.Collection = () -> this
  
###*
  Returns a new collection with the values of applying the function 'f' on each element in 'this'
  collection. 
  
  @param  f The unary function to apply on each item in the collection
  @return   A new collection with the values of applying the function 'f' on each element in 'this'
            collection.
###
mugs.Collection.prototype.map = ( f ) -> 
  elements = []
  this.forEach( (elem) -> elements.push( f(elem) ) )
  new this.buildFromArray(elements)

###*
  Returns a new collection with the concatenated values of applying the function 'f' on each element
  in 'this' collection. The function 'f' is expected to return an object that implements the forEach
  method itself. 
  
  @param  f The unary function to apply on each item in the collection. It is expected to return an 
            object that implements the forEach method itself.
  @return   A new collection with the concatenated values of applying the function 'f' on each element
            in 'this' collection
###
mugs.Collection.prototype.flatMap = ( f ) -> 
  elements = []
  this.forEach( (x) -> f(x).forEach( (y) -> elements.push(y) ))
  new this.buildFromArray(elements)
  
###*
  Selects all elements of the collection which satisfy a predicate

  @param  f An unary function that should return true if the item is wanted 
            in the resulting collection
  @return   A new collection with all of the items that satisfy the predicate 
###
mugs.Collection.prototype.filter = ( f ) -> 
  elements = []
  this.forEach( (elem) -> if f(elem) then elements.push(elem))
  new this.buildFromArray(elements)

###*
  True of the item is contained in the collection, otherwise false
  
  @param  item  The item to search for 
  @return       True of the item is contained in the collection, otherwise false
###
mugs.Collection.prototype.contains = (item) -> 
  containsItem = false
  contains = (i) -> 
    if (i.value != undefined && i.value == item) || i == item
      containsItem = true
  this.forEach( contains ) 
  return containsItem
  
###*
  Returns the number of items in the collection
  
  @return The number of items in the collection
###
mugs.Collection.prototype.size = () ->
  count = 0
  this.forEach( (i) -> count++ )
  return count

###*
  Returns an array with all of the items in the collection 
  
  @return An array with all of the items in the collection 
###
mugs.Collection.prototype.asArray = () ->
  arr = []
  this.forEach( (e) -> arr.push(e) )
  arr