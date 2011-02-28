###*
  @fileoverview Contains the implementation of the Option data structure.
  @author Mads Hartmann Jensen (mads379@gmail.com)
###
 
# Extremely annyoing hack to force the vars of the compiled  
# code to appear before the documentation of Some
if true then true 
 
###*
  @param {*} value The value to wrap inside an Option
  @constructor
###
Some = (value)  -> 
  if (value == undefined) 
    return new None()
  else 
    this.__value  = value
  this
  
###*
  Checks if the Option is empty

  @return {boolean} True if the Option is empty, i.e. of type None. Otherwise false.
###
Some.prototype.isEmpty = () -> false 

###*
  Gets the value stored in the option. This will throw an exception if invoked 
  on an instance of None.

  @return The value stored in the Option.
###
Some.prototype.get = () -> this.__value

###*
  Gets the value stored in the Option or returns the value passed.

  @param {*} value The value to return if the Option is None.
  @return The value if Some otherwise the value passed to the function
###
Some.prototype.getOrElse = (value) -> this.get()

###*
  @constructor
###
None = () -> this

###*
  Checks if the Option is empty

  @return {boolean} True if the Option is empty, i.e. of type None. Otherwise false.
###
None.prototype.isEmpty = () -> true

###*
  Gets the value stored in the option. This will throw an exception if invoked 
  on an instance of None.

  @return The value stored in the Option.
###
None.prototype.get = () -> throw new Error("Can't get a value from None")

###*
  Gets the value stored in the Option or returns the value passed.

  @param {*} value The value to return if the Option is None.
  @return The value if Some otherwise the value passed to the function
###
None.prototype.getOrElse = (value) -> value

if exports?
  exports.Some = Some 
  exports.None = None 