/* Extremely annoying hack to force the vars of the compiled
    code to appear before the documentation */if (true) {
  true;
}
/**
  This is base prototype for all collections. It implements a set of methods for all collections
  in terms of the forEach method.

  This is to be considered a partial prototype. Prototypes which inherit from mahj.Traversable will have
  to implement two methods: forEach and buildFromArray

  The forEach method should be implemented as efficiently as possible as this is used to implement
  all the methods in the mahj.Traversable prototype. The buildFromArray method should simply be a constructor
  for the prototype which takes a plain old javascript array.
*/
mahj.Traversable = function() {
  return this;
};
mahj.Traversable.prototype.buildFromArray = function() {
  throw new Error("Should be implemented in subclass");
};
mahj.Traversable.prototype.forEach = function() {
  throw new Error("Should be implemented in subclass");
};
/**
  Returns a new collection with the values of applying the function 'f' on each element in 'this'
  collection.
*/
mahj.Traversable.prototype.map = function(f) {
  var elements;
  elements = [];
  this.forEach(function(elem) {
    return elements.push(f(elem));
  });
  return new this.buildFromArray(elements);
};
/**
  Returns a new collection with the concatenated values of applying the function 'f' on each element
  in 'this' collection. The function 'f' is expected to return an object that implements the forEach
  method itself.
*/
mahj.Traversable.prototype.flatMap = function(f) {
  var elements;
  elements = [];
  this.forEach(function(x) {
    return f(x).forEach(function(y) {
      return elements.push(y);
    });
  });
  return new this.buildFromArray(elements);
};
/**

*/
mahj.Traversable.prototype.filter = function(f) {
  var elements;
  elements = [];
  this.forEach(function(elem) {
    if (f(elem)) {
      return elements.push(elem);
    }
  });
  return new this.buildFromArray(elements);
};
/**

*/
mahj.Traversable.prototype.isEmpty = function() {
  var itIsEmpty;
  itIsEmpty = true;
  this.forEach(function(elem) {
    itIsEmpty = false;
    return false;
  });
  return true;
};
if (typeof exports != "undefined" && exports !== null) {
  exports.mahj.Traversable = mahj.Traversable;
}