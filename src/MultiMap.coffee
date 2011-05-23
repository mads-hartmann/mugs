###*
  @fileoverview Contains the implementation of the Multimap data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

mugs.provide("mugs.Multimap")

mugs.require("mugs.List")
mugs.require('mugs.RedBlack')
mugs.require('mugs.RedBlackLeaf')
mugs.require('mugs.RedBlackNode')

###*
  Multimap
  
  A Multimap is a Map where a key can be associated with many values. The values will be stored in a collection
  chosen by the user. The collection has to implement mugs.Extensible. Multimap is a higher-kinded collection. 
  
  <pre>
    insert          O(log n)
    insertAll       O(log n * items)
    get             O(log n)
    remove          O(log n)
    removeAll       O(log n)
    contains        O(log n)
    values          O(n)
    keys            O(n)
  </pre>
  
  @class mugs.Multimap  provides the implementation of the Multimap ADT based on a Red Black Tree
  
  @example
var multimap = new mugs.Multimap([ { key: 1, value: [1,2,3] }, 
                                   { key: 2, value: 4 } ], 
                                   mugs.List);
  
  @param keyValuePairs  An array containing objects with key and value properties. 
  @param constructor    The Constructor function for the collection to associate with each key. The collection has
                        to implement the mugs.Extensible interface. 
  @param comparator     The comparator function used to compare the keys in the Map. 
                      
###
mugs.Multimap = (keyValuePairs, collectionConstructor, comparator) -> 
  treeUnderConstruction = new mugs.RedBlackLeaf(mugs.RedBlack.BLACK, comparator)
  if keyValuePairs instanceof Array and keyValuePairs.length > 0
    for kv in keyValuePairs
      val = (if kv.value instanceof Array then new collectionConstructor(kv.value) else new collectionConstructor([kv.value]))
      treeUnderConstruction = treeUnderConstruction.insert(kv.key, val)

  this.collectionConstructor_ = collectionConstructor
  this.tree_ = treeUnderConstruction  
  this

mugs.Multimap.prototype = new mugs.Collection()

###*
  Returns a new multimap with the key/value pair 
  
  @param key    key to store in the multimap
  @param value  value to store in the multimap
  @return       A new multimap with the key/value pair
###
mugs.Multimap.prototype.insert = (key, value) -> 
  current_list = this.tree_.get(key).getOrElse(new this.collectionConstructor_())
  new_tree     = this.tree_.insert(key, current_list.insert(value))
  this.buildFromTree(new_tree)

###*
  Returns a new multimap with all of the values associated with the given key
  
  @param key    The key to store in the multimap 
  @param values An array with the values to store in the multimap
  @return       A new multimap with all of the values associated with the given key
###
mugs.Multimap.prototype.insertAll = (key, values) -> 
  current_list = this.tree_.get(key).getOrElse(new this.collectionConstructor_())
  new_tree     = this.tree_.insert(key, current_list.insertAll(values))
  this.buildFromTree(new_tree)

###*
  Returns a collection of all values associated with a key.
  
  @param key key to search for in the multimap
  @return A collection of all the values associated with the given key.  
          Empty List if the key isn't in map
###
mugs.Multimap.prototype.get = (key) -> 
  this.tree_.get(key).getOrElse(new this.collectionConstructor_())

###*
  Removes a key-value pair from the multimap.
  
  @param key key of entry to remove from the multimap
  @param value value of entry to remove the multimap
  @return A new multimap without the value associated with the given key. 
###
mugs.Multimap.prototype.remove = (key, value) -> 
  currentList = this.tree_.get(key).getOrElse(new this.collectionConstructor_())
  newList = currentList.remove(value)
  new_tree     = this.tree_.insert(key, newList)
  this.buildFromTree(new_tree)

###*
   Removes all values associated with a given key.
   
   @param key key of entries to remove from the multimap
   @return A new mugs.Multimap without any values associated the the key 
###
mugs.Multimap.prototype.removeAll = (key) -> 
  this.buildFromTree(this.tree_.remove(key))

###*
  Checks if the key is in the Multimap

  @param key The key of the 
  @return True if the Multimap contains the key, otherwise false
###
mugs.Multimap.prototype.containsKey = (key) -> 
  this.tree_.containsKey(key)

###*
  Returns a mugs.List with all of the values in the Multimap. 
  
  @returns a mugs.List with all of the values in the Multimap
###
mugs.Multimap.prototype.values = () -> 
  this.tree_.values().flatMap( (list) -> list )

###*
  Returns a mugs.List with all of the keys in the Multimap
  
  @returns a mugs.List with all of the keys in the Multimap
###
mugs.Multimap.prototype.keys = () -> 
  this.tree_.keys()

###*
  @private
###
mugs.Multimap.prototype.buildFromTree = (tree) ->
  map = new mugs.Multimap([], this.collectionConstructor_)
  map.tree_ = tree
  map