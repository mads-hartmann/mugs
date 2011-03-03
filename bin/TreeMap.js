/**
  @fileoverview Contains the implementation of the Map data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
*/var BLACK, RED, RedBlackLeaf, RedBlackNode, RedBlackNodeWrapper, TreeMap;
if (typeof require != "undefined" && require !== null) {
  RedBlackNodeWrapper = require('../src/RedBlackTree');
  RedBlackNode = RedBlackNodeWrapper.RedBlackNode;
  RedBlackLeaf = RedBlackNodeWrapper.Leaf;
  RED = RedBlackNodeWrapper.RED;
  BLACK = RedBlackNodeWrapper.BLACK;
}
/**
  TreeMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree. The
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
  map( f )                                            O(n)    TODO
  flatMap( f )                                        O(n)    TODO
  filter( f )                                         O(n)    TODO
  forEach( f )                                        O(n)    TODO
  foldLeft(s)(f)                                      O(n)    TODO
  isEmpty()                                           O(1)    TODO
  contains( element )                                 O(n)    TODO
  forAll( f )                                         O(n)    TODO
  take( x )                                           O(n)    TODO
  takeWhile( f )                                      O(n)    TODO
  size()                                              O(n)    TODO
  --------------------------------------------------------
  </pre>

   @class TreeMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree.
   @public
*/
TreeMap = function(key, value, comparator) {
  this.tree = new RedBlackNode(RED, new RedBlackLeaf(BLACK), key, value, new RedBlackLeaf(BLACK), comparator);
  if (comparator != null) {
    this.tree.comparator = comparator;
  }
  this.insert = function(key, value) {
    return this.constructFromTree(this.tree.insert(key, value));
  };
  this.get = function(key) {
    return this.tree.get(key);
  };
  this.remove = function(key) {
    return this.constructFromTree(this.tree.remove(key));
  };
  this.keys = function() {
    return this.tree.keys();
  };
  this.values = function() {
    return this.tree.values();
  };
  this.constructFromTree = function(tree) {
    var set;
    set = new TreeMap();
    set.tree = tree;
    return set;
  };
  return this;
};
if (typeof exports != "undefined" && exports !== null) {
  exports.TreeMap = TreeMap;
}