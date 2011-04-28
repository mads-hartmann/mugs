/**
  @fileoverview Contains the implementation of the Set data structure based on a Left Leaning Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
*/mugs.provide("mugs.LLRBSet");
mugs.require("mugs.LLRBNode");
mugs.require("mugs.LLRBLeaf");
/**
  @augments mugs.Traversable
  @class mugs.LLRBSet Contains the implementation of the Set data structure based on a Left Leaning Red-Black Tree
  @public
*/
mugs.LLRBSet = function(items, comparator) {
  var item, treeUnderConstruction, _i, _len;
  treeUnderConstruction = new mugs.LLRBLeaf();
  if (items instanceof Array && items.length > 0) {
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      treeUnderConstruction = treeUnderConstruction.insert(item, item);
    }
  }
  this.tree = treeUnderConstruction;
  if (comparator != null) {
    this.tree.comparator = comparator;
  }
  return this;
};
mugs.LLRBSet.prototype = new mugs.Traversable();
/**
  Insert an element in the set. If the set already contains an element equal to the given value,
  it is replaced with the new value.
  @param element The element to insert into the set
*/
mugs.LLRBSet.prototype.insert = function(element) {
  return this.buildFromTree(this.tree.insert(element, element));
};
/**
  Delete an element from the set
  @param element The element to remove from the set
*/
mugs.LLRBSet.prototype.remove = function(element) {
  return this.buildFromTree(this.tree.remove(element));
};
/**
  Tests if the set contains the element
  @param element The element to check for
*/
mugs.LLRBSet.prototype.contains = function(element) {
  return this.tree.containsKey(element);
};
/**
  The elements of the set
  @return {List} A list containing all the element of the set
*/
mugs.LLRBSet.prototype.values = function() {
  return this.tree.values();
};
/**
  Used to construct a TreeMap from mugs.RedBlackTree. This is intended
  for internal use only. Would've marked it private if I could.
  @private
*/
mugs.LLRBSet.prototype.buildFromTree = function(tree) {
  var set;
  set = new mugs.LLRBSet(this.comparator);
  set.tree = tree;
  return set;
};
/*
---------------------------------------------------------------------------------------------
Methods related to Traversable prototype
---------------------------------------------------------------------------------------------
*/
/**
  @private
*/
mugs.LLRBSet.prototype.buildFromArray = function(arr) {
  return new mugs.LLRBSet(arr, this.comparator);
};
/**
  Applies function 'f' on each value in the map. This return nothing and is only invoked
  for the side-effects of f.
  @param f The unary function to apply on each element in the set.
  @see mugs.Traversable
*/
mugs.LLRBSet.prototype.forEach = function(f) {
  var q;
  q = function(kv) {
    var newValue;
    newValue = f(kv.key);
    return {
      key: newValue,
      value: newValue
    };
  };
  return this.tree.inorderTraversal(q);
};