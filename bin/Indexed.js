mugs.provide("mugs.Indexed");
mugs.require("mugs.Extensible");
/**
  @augments mugs.Extensible
*/
mugs.Indexed = function() {
  return this;
};
mugs.Indexed.prototype = new mugs.Extensible();
/**
  Returns mugs.Some(index) of the first occurrence of the item in the collection if it exists.
  otherwise, mugs.None

  @param  item  The item to search for in the collection
  @return       mugs.Some(index) of the first occurrence of the item in the collection if it exists.
                otherwise, mugs.None
*/
mugs.Indexed.prototype.indexOf = function(item) {
  return this.findIndex(function(itm) {
    return item === itm;
  });
};
/**
  Returns mugs.Some(index) of the last occurrence of the item in the collection if it exists.
  otherwise, mugs.None

  @param  item  The item to search for in the collection
  @return       mugs.Some(index) of the last occurrence of the item in the collection if it exists.
                otherwise, mugs.None
*/
mugs.Indexed.prototype.lastIndexOf = function(item) {
  return this.findLastIndex(function(itm) {
    return itm === item;
  });
};
/**
  Returns mugs.Some(index) of the first element satisfying a predicate, or mugs.None

  @parem  p The predicate to apply to each object
  @return   mugs.Some(index) of the first element satisfying a predicate, or mugs.None
*/
mugs.Indexed.prototype.findIndex = function(f) {
  var i, index;
  index = new mugs.None();
  i = 0;
  this.forEach(function(itm) {
    if (f(itm) && index.isEmpty()) {
      index = new mugs.Some(i);
      return i++;
    } else {
      return i++;
    }
  });
  return index;
};
/**
  Returns mugs.Some(index) of the last element satisfying a predicate, or mugs.None

  @parem  p The predicate to apply to each object
  @return   mugs.Some(index) of the last element satisfying a predicate, or mugs.None
*/
mugs.Indexed.prototype.findLastIndex = function(f) {
  var i, index;
  index = new mugs.None();
  i = 0;
  this.forEach(function(itm) {
    if (f(itm)) {
      index = new mugs.Some(i);
      return i++;
    } else {
      return i++;
    }
  });
  return index;
};