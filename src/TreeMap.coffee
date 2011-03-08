###*
  @fileoverview Contains the implementation of the Map data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
###
if require?
  RedBlackNodeWrapper = require('../src/RedBlackTree')
  RedBlackNode        = RedBlackNodeWrapper.RedBlackNode
  RedBlackLeaf        = RedBlackNodeWrapper.Leaf
  RED                 = RedBlackNodeWrapper.RED
  BLACK               = RedBlackNodeWrapper.BLACK
  Traversable = (require './Traversable').Traversable

###*
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
   
  @class TreeMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree.
  @constructor
  @example
  var map = new TreeMap([
    {key: 1, value: "one"},
    {key: 4, value: "four"},
    {key: 3, value: "three"},
    {key: 2, value: "two"}
  ]);
  @param {Array} keyValuePairs An array containing objects with the properties key & value.
  @param {Function=} comparator A comparator function that can compare the keys (optional). Will use a 
                                default comparator for integers if no comparator is given
  @public
  @augments mahj.Traversable
###    
TreeMap = (keyValuePairs, comparator) ->
  # Delegate tree 
  if keyValuePairs instanceof Array and keyValuePairs.length > 0 
    treeUnderConstruction = new RedBlackLeaf(BLACK)
    for kv in keyValuePairs
      treeUnderConstruction = treeUnderConstruction.insert(kv.key, kv.value)
    this.tree = treeUnderConstruction
  else 
    this.tree = RedBlackLeaf(BLACK)
  this.tree.comparator = comparator if comparator?
  this

TreeMap.prototype = new mahj.Traversable()

###
---------------------------------------------------------------------------------------------
Methods related to the MAP ADT
---------------------------------------------------------------------------------------------
###  

###*
  Return a new TreeMap containing the given (key,value) pair.
  @param {*} key The key to store the value by 
  @param {*} value The value to store in the map
  @return {TreeMap} A new TreeMap that also contains the new key-value pair 
###
TreeMap.prototype.insert = (key, value) -> this.buildFromTree(this.tree.insert(key,value))
  
###*
  If a (key,value) pair exists return Some(value), otherwise None()
  @param {*} key The key of the value you want to read. 
  @return {Some|None} Some(value) if it exists in the map. Otherwise None
###
TreeMap.prototype.get = (key) -> this.tree.get(key)
  
###*
  Returns a new TreeMap without the given key-value pair.
  @param {*} key The key of the value you want to remove 
  @return {TreeMap} A new TreeMap that doesn't contain the key-value pair
###
TreeMap.prototype.remove = (key) -> this.buildFromTree(this.tree.remove(key))
  
###*
  Returns a sorted list containing all of the keys in the TreeMap
  @return {List} A sorted list containing all of the keys in the TreeMap
###
TreeMap.prototype.keys = () -> this.tree.keys()
  
###*
  Returns a sorted list containing all of the values in the TreeMap
  @return {List} sorted list containing all of the values in the TreeMap
###
TreeMap.prototype.values = () -> this.tree.values()
  
###*
  Used to construct a TreeMap from RedBlackTree. This is intended 
  for internal use only. Would've marked it private if I could.
  @private
###
TreeMap.prototype.buildFromTree = (tree) -> 
  set = new TreeMap(this.comparator)
  set.tree = tree
  set

###
---------------------------------------------------------------------------------------------
Methods related to Traversable prototype 
---------------------------------------------------------------------------------------------
### 

###*
  @private
###
TreeMap.prototype.buildFromArray = (arr) -> 
  new TreeMap(arr, this.comparator)

###*
  Applies function 'f' on each value in the map. This return nothing and is only invoked
  for the side-effects of f. 
  @see mahj.Traversable
###
TreeMap.prototype.forEach = ( f ) -> 
  this.tree.inorderTraversal( f )

    
if exports?
  exports.TreeMap = TreeMap