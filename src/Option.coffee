###*
@fileoverview Contains the implementation of the Option data structure.
@author Mads Hartmann Jensen (mads379@gmail.com)
###

###*
  @class Some
###
class Some 

  this.__value

  constructor: (value)  -> 
    if (value == undefined) 
      return new None()
    else 
      this.__value  = value

  isEmpty:     ()       -> false 
  get:         ()       -> this.__value
  getOrElse:   (f)      -> this.get()

###*
  @class None
###  
class None 
  
  constructor: ()  -> 
    
  isEmpty:     ()  -> true
  get:         ()  -> throw new Error("Can't get a value from None")
  getOrElse:   (f) -> f()

if exports?
  exports.Some = Some 
  exports.None = None 