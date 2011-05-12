/**
  @fileoverview Contains the implementation of the Map data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
*/mugs.provide('mugs.TreeMap');
mugs.require('mugs.RedBlack');
mugs.require('mugs.RedBlackLeaf');
mugs.require('mugs.RedBlackNode');
/**
  mugs.TreeMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree. The
  map contains the following operations

  <pre>
  --------------------------------------------------------
  Core operations of the Map ADT
  --------------------------------------------------------
  insert( key,value )                               O(logn)
  get( index )                                      O(logn)
  remove( index )                                   O(logn)
  contains( key )                                   O(logn)
  --------------------------------------------------------
  Methods that all containers have to implement
  --------------------------------------------------------
  map( f )                                            O(n)
  flatMap( f )                                        O(n)
  filter( f )                                         O(n)
  forEach( f )                                        O(n)
  foldLeft(s)(f)                                      O(n)    TODO
  isEmpty()                                           O(1)    TODO
  contains( element )                                 O(n)    TODO
  forAll( f )                                         O(n)    TODO
  take( x )                                           O(n)    TODO
  takeWhile( f )                                      O(n)    TODO
  size()                                              O(n)    TODO
  --------------------------------------------------------
  </pre>

  @class mugs.TreeMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree.
  @constructor
  @example
  var map = new mugs.TreeMap([
    {key: 1, value: "one"},
    {key: 4, value: "four"},
    {key: 3, value: "three"},
    {key: 2, value: "two"}
  ]);
  @param {Array} keyValuePairs An array containing objects with the properties key & value.
  @param {Function=} comparator A comparator function that can compare the keys (optional). Will use a
                                default comparator for integers if no comparator is given
  @public
  @augments mugs.Collection
*/
mugs.TreeMap = function(keyValuePairs, comparator) {
  var kv, treeUnderConstruction, _i, _len;
  treeUnderConstruction = new mugs.RedBlackLeaf(mugs.RedBlack.BLACK);
  if (keyValuePairs instanceof Array && keyValuePairs.length > 0) {
    for (_i = 0, _len = keyValuePairs.length; _i < _len; _i++) {
      kv = keyValuePairs[_i];
      treeUnderConstruction = treeUnderConstruction.insert(kv.key, kv.value);
    }
  }
  this.tree = treeUnderConstruction;
  if (comparator != null) {
    this.tree.comparator = comparator;
  }
  return this;
};
mugs.TreeMap.prototype = new mugs.Collection();
/*
---------------------------------------------------------------------------------------------
Methods related to the MAP ADT
---------------------------------------------------------------------------------------------
*/
/**
  Return a new mugs.TreeMap containing the given (key,value) pair.
  @param {*} key The key to store the value by
  @param {*} value The value to store in the map
  @return {mugs.TreeMap} A new mugs.TreeMap that also contains the new key-value pair
*/
mugs.TreeMap.prototype.insert = function(key, value) {
  return this.buildFromTree(this.tree.insert(key, value));
};
/**
  If a (key,value) pair exists return mugs.Some(value), otherwise mugs.None()
  @param {*} key The key of the value you want to read.
  @return {mugs.Some|mugs.None} mugs.Some(value) if it exists in the map. Otherwise mugs.None
*/
mugs.TreeMap.prototype.get = function(key) {
  return this.tree.get(key);
};
/**
  Returns a new mugs.TreeMap without the given key-value pair.
  @param {*} key The key of the value you want to remove
  @return {mugs.TreeMap} A new mugs.TreeMap that doesn't contain the key-value pair
*/
mugs.TreeMap.prototype.remove = function(key) {
  return this.buildFromTree(this.tree.remove(key));
};
/**
  Returns a sorted list containing all of the keys in the mugs.TreeMap
  @return {List} A sorted list containing all of the keys in the mugs.TreeMap
*/
mugs.TreeMap.prototype.keys = function() {
  return this.tree.keys();
};
/**
  Returns a sorted list containing all of the values in the mugs.TreeMap
  @return {List} sorted list containing all of the values in the mugs.TreeMap
*/
mugs.TreeMap.prototype.values = function() {
  return this.tree.values();
};
/**
  Return true if the collection is empty, otherwise false

  @return True if the collection is empty, otherwise false
*/
mugs.TreeMap.prototype.isEmpty = function() {
  return this.tree.isEmpty();
};
/**
  Used to construct a mugs.TreeMap from mugs.RedBlackTree. This is intended
  for internal use only. Would've marked it private if I could.
  @private
*/
mugs.TreeMap.prototype.buildFromTree = function(tree) {
  var map;
  map = new mugs.TreeMap(this.comparator);
  map.tree = tree;
  return map;
};
/*
---------------------------------------------------------------------------------------------
Methods related to Collection prototype
---------------------------------------------------------------------------------------------
*/
/**
  @private
*/
mugs.TreeMap.prototype.buildFromArray = function(arr) {
  return new mugs.TreeMap(arr, this.comparator);
};
/**
  Applies function 'f' on each value in the map. This return nothing and is only invoked
  for the side-effects of f.

  @see mugs.Collection
*/
mugs.TreeMap.prototype.forEach = function(f) {
  return this.tree.inorderTraversal(f);
};