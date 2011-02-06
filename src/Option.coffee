###
  This file contains the implementation for Option and it's two
  subclasses: Some and None. 
  
  Some and None are used to 

  @Author: Mads Hartmann Jensen (mads379@gmail.com)
###
class Option
  
  this.__value
  
  constructor: ()            -> throw new Error("Not implemented in Option")
  isEmpty:     ()            -> throw new Error("Not implemented in Option")
  get:         ()            -> throw new Error("Not implemented in Option")
  getOrElse:   (alternative) -> 
    if (this.isEmpty()) 
       alternative 
    else 
      this.get()
  
class Some extends Option

  isEmpty:     ()       -> false 
  get:         ()       -> this.__value
  constructor: (value)  -> 
    if (value == undefined) 
      return new None()
    else 
      this.__value  = value
  
class None  extends Option
  
  constructor: () -> 
  isEmpty:     () -> true
  
exports.Some = Some 
exports.None = None 

# console.log new Some("gotit").getOrElse( "alternative" )
# console.log new Some(undefined).getOrElse("shouldBeAlternative")
# console.log new None().getOrElse( "shouldBeAlternative" )