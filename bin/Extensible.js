mugs.provide("mugs.Extensible");
mugs.require("mugs.Collection");
/**
  @augments mugs.Collection
*/
mugs.Extensible = function() {
  return this;
};
mugs.Extensible.prototype = new mugs.Collection();
/**
  Creates a new collection without any of the given items

  @param items An array with the items to remove from the collection
  @return      A new collection without any of the given items
*/
mugs.Extensible.prototype.removeAll = function(items) {
  var item, newCollection, _i, _len;
  newCollection = this;
  for (_i = 0, _len = items.length; _i < _len; _i++) {
    item = items[_i];
    newCollection = newCollection.remove(item);
  }
  return newCollection;
};
/**
  Creates a new collection with the items inserted.

  @param items An array with the items to insert into the collection
  @return      A new collection with the items inserted.
*/
mugs.Extensible.prototype.insertAll = function(items) {
  var item, newCollection, _i, _len;
  newCollection = this;
  for (_i = 0, _len = items.length; _i < _len; _i++) {
    item = items[_i];
    newCollection = newCollection.insert(item);
  }
  return newCollection;
};