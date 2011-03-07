### Extremely annoying hack to force the vars of the compiled  
    code to appear before the documentation ###
if true then true

###*
  This is base prototype for all collections. It implements a set of methods for all collections 
  in terms of the forEach method. 
  
  This is to be considered a partial prototype. Prototypes which inherit from mahj.Traversable will have
  to implement two methods: forEach and buildFromArray
  
  The forEach method should be implemented as efficiently as possible as this is used to implement
  all the methods in the mahj.Traversable prototype. The buildFromArray method should simply be a constructor 
  for the prototype which takes a plain old javascript array. 
###
mahj.Traversable = () -> this

###*
  @private
###
mahj.Traversable.prototype.buildFromArray = () -> throw new Error("Should be implemented in subclass")  
  
mahj.Traversable.prototype.forEach = () -> throw new Error("Should be implemented in subclass")  
  
###*
  Returns a new collection with the values of applying the function 'f' on each element in 'this'
  collection. 
###
mahj.Traversable.prototype.map = ( f ) -> 
  elements = []
  this.forEach( (elem) -> elements.push( f(elem) ) )
  new this.buildFromArray(elements)

###*
  Returns a new collection with the concatenated values of applying the function 'f' on each element
  in 'this' collection. The function 'f' is expected to return an object that implements the forEach
  method itself. 
###
mahj.Traversable.prototype.flatMap = ( f ) -> 
  elements = []
  this.forEach( (x) -> f(x).forEach( (y) -> elements.push(y) ))
  new this.buildFromArray(elements)
  
###*

###
mahj.Traversable.prototype.filter = ( f ) -> 
  elements = []
  this.forEach( (elem) -> if f(elem) then elements.push(elem))
  new this.buildFromArray(elements)

###*

###
mahj.Traversable.prototype.isEmpty = () -> 
  itIsEmpty = true
  this.forEach( (elem) -> itIsEmpty = false; return false )
  return true

if exports?
  exports.mahj.Traversable = mahj.Traversable
