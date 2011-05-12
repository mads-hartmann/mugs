mugs.provide("mugs.Collection");
/**
  This is base prototype for all collections. It implements a set of methods for all collections
  in terms of the forEach method.

  This is to be considered a partial prototype. Prototypes which inherit from mugs.Collection will have
  to implement two methods: forEach and buildFromArray

  The forEach method should be implemented as efficiently as possible as this is used to implement
  all the methods in the mugs.Collection prototype. The buildFromArray method should simply be a constructor
  for the prototype which takes a plain old javascript array.
*/
mugs.Collection = function() {
  return this;
};
/**
  @private
*/
mugs.Collection.prototype.buildFromArray = function() {
  throw new Error("Should be implemented in subclass");
};
mugs.Collection.prototype.forEach = function() {
  throw new Error("Should be implemented in subclass");
};
/**
  Returns a new collection with the values of applying the function 'f' on each element in 'this'
  collection.
*/
mugs.Collection.prototype.map = function(f) {
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
mugs.Collection.prototype.flatMap = function(f) {
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
mugs.Collection.prototype.filter = function(f) {
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
  contains
*/
mugs.Collection.prototype.contains = function(item) {
  var contains, containsItem;
  containsItem = false;
  contains = function(i) {
    if ((i.value !== void 0 && i.value === item) || i === item) {
      return containsItem = true;
    }
  };
  this.forEach(contains);
  return containsItem;
};
/**
  Returns the number of items in the collection

  @return The number of items in the collection
*/
mugs.Collection.prototype.size = function() {
  var count;
  count = 0;
  this.forEach(function(i) {
    return count++;
  });
  return count;
};
mugs.Collection.prototype.asArray = function() {
  var arr;
  arr = [];
  this.forEach(function(e) {
    return arr.push(e);
  });
  return arr;
};