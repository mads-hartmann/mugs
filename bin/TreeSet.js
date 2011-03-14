/**
  @fileoverview Contains the implementation of the Set data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
*/var BLACK, RED, RedBlackLeaf, RedBlackNode, RedBlackNodeWrapper, Traversable, TreeSet;
if (typeof require != "undefined" && require !== null) {
  RedBlackNodeWrapper = require('../src/RedBlackTree');
  RedBlackNode = RedBlackNodeWrapper.RedBlackNode;
  RedBlackLeaf = RedBlackNodeWrapper.Leaf;
  RED = RedBlackNodeWrapper.RED;
  BLACK = RedBlackNodeWrapper.BLACK;
  Traversable = (require('./Traversable')).Traversable;
}
/**
  @augments mahj.Traversable
  @class TreeSet provides the implementation of the abstract data type Set based on a Red Black Tree
  @public
*/
TreeSet = function(elements, comparator) {
  var element, treeUnderConstruction, _i, _len;
  if (elements instanceof Array && elements.length > 0) {
    treeUnderConstruction = new RedBlackLeaf(BLACK);
    for (_i = 0, _len = elements.length; _i < _len; _i++) {
      element = elements[_i];
      treeUnderConstruction = treeUnderConstruction.insert(element, element);
    }
    this.tree = treeUnderConstruction;
  } else {
    this.tree = new RedBlackLeaf(BLACK);
  }
  if (comparator != null) {
    this.tree.comparator = comparator;
  }
  return this;
};
TreeSet.prototype = new mahj.Traversable();
/**
  Insert an element in the set. If the set already contains an element equal to the given value,
  it is replaced with the new value.
  @param element The element to insert into the set
*/
TreeSet.prototype.insert = function(element) {
  return this.buildFromTree(this.tree.insert(element, element));
};
/**
  Delete an element from the set
  @param element The element to remove from the set
*/
TreeSet.prototype.remove = function(element) {
  return this.buildFromTree(this.tree.remove(element));
};
/**
  Tests if the set contains the element
  @param element The element to check for
*/
TreeSet.prototype.contains = function(element) {
  return this.tree.containsKey(element);
};
/**
  The elements of the set
  @return {List} A list containing all the element of the set
*/
TreeSet.prototype.values = function() {
  return this.tree.values();
};
/**
  Used to construct a TreeMap from RedBlackTree. This is intended
  for internal use only. Would've marked it private if I could.
  @private
*/
TreeSet.prototype.buildFromTree = function(tree) {
  var set;
  set = new TreeSet(this.comparator);
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
TreeSet.prototype.buildFromArray = function(arr) {
  return new TreeSet(arr, this.comparator);
};
/**
  Applies function 'f' on each value in the map. This return nothing and is only invoked
  for the side-effects of f.
  @param f The unary function to apply on each element in the set.
  @see mahj.Traversable
*/
TreeSet.prototype.forEach = function(f) {
  var q;
  q = function(kv) {
    return {
      key: f(kv.key),
      value: f(kv.value)
    };
  };
  return this.tree.inorderTraversal(q);
};
if (typeof exports != "undefined" && exports !== null) {
  exports.TreeSet = TreeSet;
}