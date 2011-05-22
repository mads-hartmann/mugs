###*
  @fileoverview Contains the implementation of the Map data structure based on a Left Leaning Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
###

mugs.provide("mugs.LLRBMap")

mugs.require("mugs.LLRBNode")
mugs.require("mugs.LLRBLeaf") 

###*
  mugs.LLRBMap provides the implementation of the abstract data type 'Map' based on a Left Leaning Red Black Tree. The
  map contains the following operations

  <pre>
  insert(key,value)                               O(log n)
  get(index)                                      O(log n)
  remove(index)                                   O(log n)
  containsKey(key)                                O(log n)
  keys()                                          O(n)
  values()                                        O(n)
  isEmpty()                                       O(1)
  forEach(f)                                      O(n*O(f))
  </pre>

  @public
  @augments mugs.Collection
  @class mugs.LLRBMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree.
  @example
  var map = new mugs.LLRBMap([
    {key: 1, value: "one"},
    {key: 4, value: "four"},
    {key: 3, value: "three"},
    {key: 2, value: "two"}
  ]);

  @param {Array} keyValuePairs An array containing objects with the properties key & value.
  @param {Function=} comparator A comparator function that can compare the keys (optional). Will use a
                                default comparator if no comparator is given. The default one uses the 
                                < and > operators.
###
mugs.LLRBMap = (keyValuePairs, comparator) ->
  treeUnderConstruction = new mugs.LLRBLeaf() 
  if keyValuePairs instanceof Array and keyValuePairs.length > 0
    for kv in keyValuePairs
      treeUnderConstruction = treeUnderConstruction.insert(kv.key, kv.value)
  this.tree = treeUnderConstruction  
  this.tree.comparator = comparator if comparator?
  this

mugs.LLRBMap.prototype = new mugs.Collection()

###
---------------------------------------------------------------------------------------------
Methods related to the MAP ADT
---------------------------------------------------------------------------------------------
###

###*
  Returns a new mugs.LLRBMap containing the given (key,value) pair.
  
  @param {*} key The key to store the value by
  @param {*} value The value to store in the map
  @return {mugs.LLRBMap} A new mugs.LLRBMap that also contains the new key-value pair
###
mugs.LLRBMap.prototype.insert = (key, value) -> 
  this.buildFromTree(this.tree.insert(key,value))

###*
  If a (key,value) pair exists return mugs.Some(value), otherwise mugs.None()
  
  @param {*} key The key of the value you want to read.
  @return {mugs.Some|mugs.None} mugs.Some(value) if it exists in the map. Otherwise mugs.None
###
mugs.LLRBMap.prototype.get = (key) -> 
  this.tree.get(key)

###*
  Returns a new mugs.LLRBMap without the given key-value pair.
  
  @param {*} key The key of the value you want to remove
  @return {mugs.LLRBMap} A new mugs.LLRBMap that doesn't contain the key-value pair
###
mugs.LLRBMap.prototype.remove = (key) -> 
  this.buildFromTree(this.tree.remove(key))

###*
  Returns a sorted list containing all of the keys in the mugs.LLRBMap
  
  @return {List} A sorted list containing all of the keys in the mugs.LLRBMap
###
mugs.LLRBMap.prototype.keys = () -> 
  this.tree.keys()

###*
  True if the given key is contained in the LLRBMap, otherwise false. 
  
  @param  key The key to search for 
  @return True if the given key is contained in the LLRBMap, otherwise false. 
###
mugs.LLRBMap.prototype.containsKey = (key) -> 
  this.tree.containsKey(key)

###*
  Returns a sorted list containing all of the values in the mugs.LLRBMap
  
  @return {List} sorted list containing all of the values in the mugs.LLRBMap
###
mugs.LLRBMap.prototype.values = () -> 
  this.tree.values()

###*
  Return true if the collection is empty, otherwise false
  
  @return True if the collection is empty, otherwise false
###
mugs.LLRBMap.prototype.isEmpty = () ->
  this.tree.isEmpty()

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
Methods related to Collection prototype
---------------------------------------------------------------------------------------------
###

###*
  @private
###
mugs.LLRBMap.prototype.buildFromArray = (arr) ->
  new mugs.LLRBMap(arr, this.comparator)

###*
  Applies function 'f' on each value in the collection. This return nothing and is only invoked
  for the side-effects of f.

  @param f The unary function to apply on each element in the collection.
  @see mugs.Collection
###
mugs.LLRBMap.prototype.forEach = ( f ) ->
  this.tree.inorderTraversal( f )
