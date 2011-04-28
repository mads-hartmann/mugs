mugs.provide("mugs.Traversable")

###*
  This is base prototype for all collections. It implements a set of methods for all collections 
  in terms of the forEach method. 
  
  This is to be considered a partial prototype. Prototypes which inherit from mugs.Traversable will have
  to implement two methods: forEach and buildFromArray
  
  The forEach method should be implemented as efficiently as possible as this is used to implement
  all the methods in the mugs.Traversable prototype. The buildFromArray method should simply be a constructor 
  for the prototype which takes a plain old javascript array. 
###
mugs.Traversable = () -> this

###*
  @private
###
mugs.Traversable.prototype.buildFromArray = () -> throw new Error("Should be implemented in subclass")  
  
mugs.Traversable.prototype.forEach = () -> throw new Error("Should be implemented in subclass")  
  
###*
  Returns a new collection with the values of applying the function 'f' on each element in 'this'
  collection. 
###
mugs.Traversable.prototype.map = ( f ) -> 
  elements = []
  this.forEach( (elem) -> elements.push( f(elem) ) )
  new this.buildFromArray(elements)

###*
  Returns a new collection with the concatenated values of applying the function 'f' on each element
  in 'this' collection. The function 'f' is expected to return an object that implements the forEach
  method itself. 
###
mugs.Traversable.prototype.flatMap = ( f ) -> 
  elements = []
  this.forEach( (x) -> f(x).forEach( (y) -> elements.push(y) ))
  new this.buildFromArray(elements)
  
###*

###
mugs.Traversable.prototype.filter = ( f ) -> 
  elements = []
  this.forEach( (elem) -> if f(elem) then elements.push(elem))
  new this.buildFromArray(elements)

###*

###
mugs.Traversable.prototype.isEmpty = () -> 
  itIsEmpty = true
  this.forEach( (elem) -> itIsEmpty = false; return false )
  return true

mugs.Traversable.prototype.asArray = () ->
  arr = []
  this.forEach( (e) -> arr.push(e) )
  arr