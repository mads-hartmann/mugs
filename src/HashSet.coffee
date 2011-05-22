###*
  @fileoverview Contains a hash based implementation of the Set ADT
  @author Mads Hartmann Jensen (mads379@gmail.com)
###

mugs.provide("mugs.HashSet")

mugs.require("mugs.HashMap")

###*
  The HashSet is using a HashMap as the underlying data structure so 
  the asymptotic running time of the operations are bound by the HashMap
  implementation. 

  <pre>
  -----------------------------------------------------------
  B is the number of items in the bucket array (101 by default)
  b is the number of items in the current bucket
  -----------------------------------------------------------
  insert(key,item)  O(log B + b)
  remove(key)       O(log B + b)
  contains(key)     O(log B + b)
  forEach( f )      O(B * b * O(f))
  values()          O(B * b)
  </pre>
  
  @class HashSet
  @augments mugs.Extensible
  @param items        An array of items to construct the LLRBSet from
  @param initialize_  used internally. Do not pass anything 
###
mugs.HashSet = (items, initialize_) ->  
  kvs = ( {key: i, value: i} for i in items )
  this.hashMap_ = new mugs.HashMap(kvs) if initialize_ != false
  this

mugs.HashSet.prototype = new mugs.Extensible()

###*
  Returns a mugs.List with all of the items in the Set
  @return A mugs.List with all of the items in the Set
###
mugs.HashSet.prototype.values = () -> 
  this.hashMap_.values()

###*
  @private
###
mugs.HashSet.prototype.buildFromHashMap = (hashMap) -> 
  hset = new mugs.HashSet([],false)
  hset.hashMap_ = hashMap
  hset

###
---------------------------------------------------------------------------------------------
Methods related to Collection prototype
---------------------------------------------------------------------------------------------
###

###*
  @private
###
mugs.HashSet.prototype.buildFromArray = (arr) -> 
  new mugs.HashSet(arr)

###*
  Applies function 'f' on each value in the set. This return nothing and is only invoked
  for the side-effects of f.

  @param f The unary function to apply on each element in the set.
  @see mugs.Collection
###
mugs.HashSet.prototype.forEach = ( f ) -> 
  this.values().forEach( f )

###*
  Returns true if the item is in the Set, otherwise false
  
  @param item The item to check for 
  @return True if the item is in the set, otherwise false
###
mugs.HashSet.prototype.contains = (item) -> 
  this.hashMap_.containsKey(item)
  
###
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
###

###*
  Returns a new HashSet with the item inserted 
  
  @param item The item to insert into the Set
  @return     A new HashSet with the item inserted
###
mugs.HashSet.prototype.insert = (item) -> 
  this.buildFromHashMap(this.hashMap_.insert(item,item))

###*
  Returns a new HashSet with the item removed
  
  @param item The item to remove from the set
  @return     A new HashSet with the item removed
###
mugs.HashSet.prototype.remove = (item) -> 
  this.buildFromHashMap(this.hashMap_.remove(item,item))