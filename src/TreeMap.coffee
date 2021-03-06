###*
  @fileoverview Contains the implementation of the Map data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

mugs.provide('mugs.TreeMap')

mugs.require('mugs.RedBlack')
mugs.require('mugs.RedBlackLeaf')
mugs.require('mugs.RedBlackNode')

###*
  mugs.TreeMap provides the implementation of the abstract data type 'Map' based on a Red Black Tree. The
  map contains the following operations

  <pre>
  insert( key,value )                               O(log n)
  get( index )                                      O(log n)
  remove( index )                                   O(log n)
  containsKey(key)                                  O(log n)
  keys()                                            O(n)
  values()                                          O(n)
  isEmpty()                                         O(1)
  forEach(f)                                        O(n*O(f))
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
###
mugs.TreeMap = (keyValuePairs, comparator) ->
  treeUnderConstruction = new mugs.RedBlackLeaf(mugs.RedBlack.BLACK,comparator)
  if keyValuePairs instanceof Array and keyValuePairs.length > 0
    for kv in keyValuePairs
      treeUnderConstruction = treeUnderConstruction.insert(kv.key, kv.value)
  this.tree = treeUnderConstruction  
  this

mugs.TreeMap.prototype = new mugs.Collection()

###
---------------------------------------------------------------------------------------------
Methods related to the MAP ADT
---------------------------------------------------------------------------------------------
###

###*
  Return a new mugs.TreeMap containing the given (key,value) pair.
  
  @param {*} key The key to store the value by
  @param {*} value The value to store in the map
  @return {mugs.TreeMap} A new mugs.TreeMap that also contains the new key-value pair
###
mugs.TreeMap.prototype.insert = (key, value) -> this.buildFromTree(this.tree.insert(key,value))

###*
  If a (key,value) pair exists return mugs.Some(value), otherwise mugs.None()
  
  @param {*} key The key of the value you want to read.
  @return {mugs.Some|mugs.None} mugs.Some(value) if it exists in the map. Otherwise mugs.None
###
mugs.TreeMap.prototype.get = (key) -> this.tree.get(key)

###*
  Returns a new mugs.TreeMap without the given key-value pair.
  
  @param {*} key The key of the value you want to remove
  @return {mugs.TreeMap} A new mugs.TreeMap that doesn't contain the key-value pair
###
mugs.TreeMap.prototype.remove = (key) -> this.buildFromTree(this.tree.remove(key))

###*
  True if the given key is contained in the TreeMap, otherwise false. 
  
  @param  key The key to search for 
  @return True if the given key is contained in the TreeMap, otherwise false. 
###
mugs.TreeMap.prototype.containsKey = (key) -> 
  this.tree.containsKey(key)

###*
  Returns a sorted list containing all of the keys in the mugs.TreeMap
  
  @return {List} A sorted list containing all of the keys in the mugs.TreeMap
###
mugs.TreeMap.prototype.keys = () -> this.tree.keys()

###*
  Returns a sorted list containing all of the values in the mugs.TreeMap
  
  @return {List} sorted list containing all of the values in the mugs.TreeMap
###
mugs.TreeMap.prototype.values = () -> this.tree.values()

###*
  Return true if the collection is empty, otherwise false
  
  @return True if the collection is empty, otherwise false
###
mugs.TreeMap.prototype.isEmpty = () ->
  this.tree.isEmpty()


###*
  Used to construct a mugs.TreeMap from mugs.RedBlackTree. This is intended
  for internal use only. Would've marked it private if I could.
  
  @private
###
mugs.TreeMap.prototype.buildFromTree = (tree) ->
  map = new mugs.TreeMap(this.comparator)
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
mugs.TreeMap.prototype.buildFromArray = (arr) ->
  new mugs.TreeMap(arr, this.comparator)

###*
  Applies function 'f' on each value in the map. This return nothing and is only invoked
  for the side-effects of f.
  
  @see mugs.Collection
###
mugs.TreeMap.prototype.forEach = ( f ) ->
  this.tree.inorderTraversal( f )
