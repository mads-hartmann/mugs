###*
  @fileoverview Contains the implementation of the Option monad which consists
                of two prototypes: Some and mugs.None.
  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

mugs.provide('mugs.Some')
mugs.provide('mugs.None') 

###*
  Don't use the Option prototype directly, use the {@link mugs.Some} or {@link mugs.None}. An option represents
  an optional value. It consists of either Some or mugs.None.

  @see mugs.Some
  @see mugs.None
  @constructor
### 
mugs.Option = () -> this

###*
  Returns the option's value if the option is mugs.Nonempty, otherwise return the value
  'otherwise'.
  
  @param {*} otherwise The value to return if the Option is mugs.None.
  @return The option's value if Some otherwise the value passed to the function
###
mugs.Option.prototype.getOrElse = (otherwise) ->
  if this.isEmpty() then otherwise else this.get()

###*
  Returns a Some containing the result of applying f to this Option's
  value if this Option is mugs.Nonempty. Otherwise return mugs.None.

  @param {function(*):*} f The unary function to apply
  @return {Option} Some containing the result of applying the function f on the
                   element inside the Option if mugs.Nonempty. Otherwise mugs.None.
###
mugs.Option.prototype.map = ( f ) ->
  if this.isEmpty() then new mugs.None else new mugs.Some(f(this.get()))

###*
  Returns the result of applying f to this option's value if this Option is
  mugs.Nonempty, otherwise mugs.None. This is Slightly different from `map` in that f is
  expected to return an Option (which could be mugs.None).

  @param {function(*): Option} f The unary function to apply
  @return {Option} The result of applying the function f on the
                   element inside the Option if mugs.Nonempty. Otherwise mugs.None.
###
mugs.Option.prototype.flatMap = ( f ) ->
  if this.isEmpty() then new mugs.None else f(this.get())

###*
  Returns this Option if it is mugs.Nonempty '''and''' applying the 'predicate' to
  this Option's value returns true. Otherwise, return mugs.None

  @param {function(*): boolean} predicate A function that decides if the value
                                should be included in the resulting collection
###
mugs.Option.prototype.filter = ( predicate ) ->
  if (this.isEmpty() || predicate(this.get())) then this else new mugs.None()

###*
  Apply the given procedure f to the option's value, if it is mugs.Nonempty. Otherwise,
  do nothing.

  @param {function(*): *} f A unary function.
  @return Nothing. This is all about side effects
###
mugs.Option.prototype.foreach = ( f ) ->
  if (!this.isEmpty())
    f(this.get())

mugs.Option.prototype.asArray = () -> 
  if (this.isEmpty()) then [] else [this.get()]

###*
  Some(x) represents an existing value x. It's part of the {@link Option} monad.

  @class Some(x) represents an existing value x. It's part of the {@link Option} monad.
  @param {*} value The value to wrap inside an Option
  @see mugs.Option
  @constructor
  @augments mugs.Option
###
mugs.Some = (value)  ->
  if (value == undefined)
    return new mugs.None()
  else
    this.__value  = value
  this

mugs.Some.prototype = new mugs.Option()

###*
  See documentation in {@link mugs.Option}
###
mugs.Some.prototype.isEmpty = () -> false

###*
  See documentation in {@link mugs.Option}
###
mugs.Some.prototype.get = () -> this.__value

###*
  mugs.None represents the non-existing of a value. It's part of the {@link mugs.Option} monad.

  @see mugs.Option
  @constructor
  @augments mugs.Option
  @class mugs.None represents the non-existing of a value. It's part of the {@link mugs.Option} monad.
###
mugs.None = () -> this

mugs.None.prototype = new mugs.Option()
mugs.None.prototype.constructor = mugs.None

###*
  See documentation in {@link mugs.Option}
###
mugs.None.prototype.isEmpty = () -> true

###*
  See documentation in {@link mugs.Option}
###
mugs.None.prototype.get = () -> throw new Error("Get get a value in an instance of mugs.None")
