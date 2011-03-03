/**
  @fileoverview Contains the implementation of the Option monad which consists
                of two prototypes: Some and None.
  @author Mads Hartmann Jensen (mads379@gmail.com)
*/
/* Extremely annoying hack to force the vars of the compiled
    code to appear before the documentation of Some */var None, Option, Some;
if (true) {
  true;
}
/**
  Don't use the Option prototype directly, use the {@link Some} or {@link None}. An option represents
  an optional value. It consists of either Some or None.

  @see Some
  @see None
  @constructor
*/
Option = function() {
  return this;
};
/**
  Checks if the Option is empty.
  @return {boolean} True if the Option is empty, i.e. of type None. Otherwise false.
*/
Option.prototype.isEmpty = function() {
  throw new Error("Not implemented in Option");
};
/**
  Returns the option's value if the option is nonempty. This will throw an exception if
  invoked on an instance of None.
  @return {*} The value stored in the Option.
*/
Option.prototype.get = function() {
  throw new Error("Not implemented in Option");
};
/**
  Returns the option's value if the option is nonempty, otherwise return the value
  'otherwise'.
  @param {*} otherwise The value to return if the Option is None.
  @return The option's value if Some otherwise the value passed to the function
*/
Option.prototype.getOrElse = function(otherwise) {
  if (this.isEmpty()) {
    return otherwise;
  } else {
    return this.get();
  }
};
/**
  Returns a Some containing the result of applying f to this Option's
  value if this Option is nonempty. Otherwise return None.

  @param {function(*):*} f The unary function to apply
  @return {Option} Some containing the result of applying the function f on the
                   element inside the Option if nonempty. Otherwise None.
*/
Option.prototype.map = function(f) {
  if (this.isEmpty()) {
    return new None;
  } else {
    return new Some(f(this.get()));
  }
};
/**
  Returns the result of applying f to this option's value if this Option is
  nonempty, otherwise None. This is Slightly different from `map` in that f is
  expected to return an Option (which could be None).

  @param {function(*): Option} f The unary function to apply
  @return {Option} The result of applying the function f on the
                   element inside the Option if nonempty. Otherwise None.
*/
Option.prototype.flatMap = function(f) {
  if (this.isEmpty()) {
    return new None;
  } else {
    return f(this.get());
  }
};
/**
  Returns this Option if it is nonempty '''and''' applying the 'predicate' to
  this Option's value returns true. Otherwise, return None

  @param {function(*): boolean} predicate A function that decides if the value
                                should be included in the resulting collection
*/
Option.prototype.filter = function(predicate) {
  if (this.isEmpty() || predicate(this.get())) {
    return this;
  } else {
    return new None();
  }
};
/**
  Apply the given procedure f to the option's value, if it is nonempty. Otherwise,
  do nothing.

  @param {function(*): *} f A unary function.
  @return Nothing. This is all about side effects
*/
Option.prototype.foreach = function(f) {
  if (!this.isEmpty()) {
    return f(this.get());
  }
};
/**
  Some(x) represents an existing value x. It's part of the {@link Option} monad.

  @class Some(x) represents an existing value x. It's part of the {@link Option} monad.
  @param {*} value The value to wrap inside an Option
  @see Option
  @constructor
  @augments Option
*/
Some = function(value) {
  if (value === void 0) {
    return new None();
  } else {
    this.__value = value;
  }
  return this;
};
Some.prototype = new Option();
Some.prototype.constructor = Some;
/**
  See documentation in {@link Option}
*/
Some.prototype.isEmpty = function() {
  return false;
};
/**
  See documentation in {@link Option}
*/
Some.prototype.get = function() {
  return this.__value;
};
/**
  None represents the non-existing of a value. It's part of the {@link Option} monad.

  @see Option
  @constructor
  @augments Option
  @class None represents the non-existing of a value. It's part of the {@link Option} monad.
*/
None = function() {
  return this;
};
None.prototype = new Option();
None.prototype.constructor = None;
/**
  See documentation in {@link Option}
*/
None.prototype.isEmpty = function() {
  return true;
};
/**
  See documentation in {@link Option}
*/
None.prototype.get = function() {
  throw new Error("Get get a value in an instance of None");
};
if (typeof exports != "undefined" && exports !== null) {
  exports.Some = Some;
  exports.None = None;
}