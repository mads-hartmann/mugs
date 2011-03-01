###*
  @fileoverview Contains the implementation of the Option monad which consists 
                of two prototypes: Some and None.
  @author Mads Hartmann Jensen (mads379@gmail.com)
###
 
### Extremely annoying hack to force the vars of the compiled  
    code to appear before the documentation of Some ###
if true then true 
 
###*
  Don't use the Option prototype directly. Use the Some or None. An option represents
  an optional value. It consists of either Some or None. 
  
  @see Some
  @see None
  @constructor 
###
Option = () -> 

###*
  Checks if the Option is empty. 
  @return {boolean} True if the Option is empty, i.e. of type None. Otherwise false.
###
Option.prototype.isEmpty = () -> throw new Error("Not implemented in Option")

###*
  Gets the value stored in the option. This will throw an exception if invoked 
  on an instance of None.
  @return {*} The value stored in the Option. 
###
Option.prototype.get = () -> throw new Error("Not implemented in Option")

###*
  @param {*} otherwise The value to return if the Option is None.
  @return The value if Some otherwise the value passed to the function
### 
Option.prototype.getOrElse = (otherwise) ->  
  if this.isEmpty() then otherwise else this.get() 

###*
  Applies the function ‘f’ on each element in the collection and returns a
  new collection with the values returned from applying the function ‘f’.

  @param {function(*):*} f A function that maps the value to another value
###
Option.prototype.map = ( f ) ->   
  if this.isEmpty() then new None else new Some(f(this.get()))

###*
  Applies the function ‘f’ to all elements of the collection and concatenates 
  the results.

  @param {function(*):*} f A function that maps the value to another value
  @return {Option} An Option with the result of applying the function f on the 
                   element inside the Option.
###
Option.prototype.flatMap = ( f ) ->   
  if this.isEmpty() then new None else f(this.get())

###*
  Applies the function ‘f’ on each element and returns a collection of the same 
  type with the elements where the function returned true.
  
  @param {function(*): boolean} predicate A function that decides if the value 
                                should be included in the resulting collection
### 
Option.prototype.filter = ( predicate ) ->   
  if (this.isEmpty() || predicate(this.get())) then this else new None()
###*
  Apply the function f on each element in the collection returning nothing. This 
  is all about side effects.
  
  @param {function(*): *} f A unary function. 
  @return Nothing. This is all about side effects
###
Option.prototype.foreach = ( f ) ->
  if (!this.isEmpty()) 
    f(this.get())

###*
  An option represents an optional value. It consists of either Some or None. Some(e)
  represents the existence of value e. 
  
  @param {*} value The value to wrap inside an Option
  @see Option
  @constructor
  @augments Option
###
Some = (value)  -> 
  if (value == undefined) 
    return new None()
  else 
    this.__value  = value
  this

Some.prototype = new Option()
Some.prototype.constructor = Some
Some.prototype.isEmpty = () -> false
Some.prototype.get = () -> this.__value
  
###*
  An Option represents an optional value. It consists of either Some or None. None
  represents the non-existence of a value.
  
  @see Option
  @constructor
  @augments Option
###
None = () -> this

None.prototype = new Option()
None.prototype.constructor = None
None.prototype.isEmpty = () -> true
None.prototype.get = () -> throw new Error("Get get a value in an instance of None")

if exports?
  exports.Some = Some
  exports.None = None
