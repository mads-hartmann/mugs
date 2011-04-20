###*
  @fileoverview Contains the implementation of the Map data structure based on a Left Leaning Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
###

###*
  mugs.LLRBMap provides the implementation of the abstract data type 'Map' based on a Left Leaning Red Black Tree. The
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

  @class mugs.LLRBMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree.
  @constructor
  @example
  var map = new mugs.LLRBMap([
    {key: 1, value: "one"},
    {key: 4, value: "four"},
    {key: 3, value: "three"},
    {key: 2, value: "two"}
  ]);
  @param {Array} keyValuePairs An array containing objects with the properties key & value.
  @param {Function=} comparator A comparator function that can compare the keys (optional). Will use a
                                default comparator for integers if no comparator is given
  @public
  @augments mugs.Traversable
###
mugs.LLRBMap = (keyValuePairs, comparator) ->
  treeUnderConstruction = new mugs.LLRBLeaf() 
  if keyValuePairs instanceof Array and keyValuePairs.length > 0
    for kv in keyValuePairs
      treeUnderConstruction = treeUnderConstruction.insert(kv.key, kv.value)
  this.tree = treeUnderConstruction  
  this.tree.comparator = comparator if comparator?
  this

mugs.LLRBMap.prototype = new mugs.Traversable()

###
---------------------------------------------------------------------------------------------
Methods related to the MAP ADT
---------------------------------------------------------------------------------------------
###

###*
  Return a new mugs.LLRBMap containing the given (key,value) pair.
  @param {*} key The key to store the value by
  @param {*} value The value to store in the map
  @return {mugs.LLRBMap} A new mugs.LLRBMap that also contains the new key-value pair
###
mugs.LLRBMap.prototype.insert = (key, value) -> this.buildFromTree(this.tree.insert(key,value))

###*
  If a (key,value) pair exists return mugs.Some(value), otherwise mugs.None()
  @param {*} key The key of the value you want to read.
  @return {mugs.Some|mugs.None} mugs.Some(value) if it exists in the map. Otherwise mugs.None
###
mugs.LLRBMap.prototype.get = (key) -> this.tree.get(key)

###*
  Returns a new mugs.LLRBMap without the given key-value pair.
  @param {*} key The key of the value you want to remove
  @return {mugs.LLRBMap} A new mugs.LLRBMap that doesn't contain the key-value pair
###
mugs.LLRBMap.prototype.remove = (key) -> this.buildFromTree(this.tree.remove(key))

###*
  Returns a sorted list containing all of the keys in the mugs.LLRBMap
  @return {List} A sorted list containing all of the keys in the mugs.LLRBMap
###
mugs.LLRBMap.prototype.keys = () -> this.tree.keys()

###*
  Returns a sorted list containing all of the values in the mugs.LLRBMap
  @return {List} sorted list containing all of the values in the mugs.LLRBMap
###
mugs.LLRBMap.prototype.values = () -> this.tree.values()

###*
  Used to construct a mugs.LLRBMap from mugs.RedBlackTree. This is intended
  for internal use only. Would've marked it private if I could.
  @private
###
mugs.LLRBMap.prototype.buildFromTree = (tree) ->
  map = new mugs.LLRBMap(this.comparator)
  map.tree = tree
  map

###
---------------------------------------------------------------------------------------------
Methods related to Traversable prototype
---------------------------------------------------------------------------------------------
###

###*
  @private
###
mugs.LLRBMap.prototype.buildFromArray = (arr) ->
  new mugs.LLRBMap(arr, this.comparator)

###*
  Applies function 'f' on each value in the map. This return nothing and is only invoked
  for the side-effects of f.
  @see mugs.Traversable
###
mugs.LLRBMap.prototype.forEach = ( f ) ->
  this.tree.inorderTraversal( f )