###*
@fileoverview Contains the implementation of the Option data structure.
@author Mads Hartmann Jensen (mads379@gmail.com)
###

Some = (value)  -> 

  if (value == undefined) 
    return new None()
  else 
    this.__value  = value
    
  this.isEmpty =     ()       -> false 
  this.get =         ()       -> this.__value
  this.getOrElse =   (f)      -> this.get()

None = () -> 
      
  this.isEmpty =     ()  -> true
  this.get =         ()  -> throw new Error("Can't get a value from None")
  this.getOrElse =   (f) -> f()

if exports?
  exports.Some = Some 
  exports.None = None 