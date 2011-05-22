###*
  @fileoverview Contains a hash based implementation of the Map ADT
  @author Mads Hartmann Jensen (mads379@gmail.com)
###

mugs.provide("mugs.HashMap")

mugs.require("mugs.Some")
mugs.require("mugs.None")
mugs.require("mugs.Collection")
mugs.require("mugs.List")

###*
  HashMap
  
  Implementation of an immutable Map based on a hash table. The bucket array approach is used and the underlying 
  data-structure is a Random Access List. Separate Chaining is used to deal with collisions where the chain is based 
  on a List.  
  
  A property named something like "mugs_uid_2kczq5" will be added to the key objects. This approach has been copied from 
  JS_Cols (http://jscols.com/).
  
  <pre>
  -----------------------------------------------------------
  B is the number of items in the bucket array (101 by default)
  b is the number of items in the current bucket
  -----------------------------------------------------------
  
  get(key)                                     O(log B + b) 
  insert(key,item)                             O(log B + b)
  remove(key)                                  O(log B + b)
  containsKey(key)                             O(log B + b)
  forEach( f )                                 O(B * b * O(f))
  values()                                     O(B * b)
  keys()                                       O(B * b)
  </pre>

  @class HashMap
  @augments mugs.Collection
  @param {Array} keyValuePairs An array containing objects with the properties key & value.
  @param {Bool} initialize This is only used internally. It's true if the bucket array should be initialize
###
mugs.HashMap = (keyValuePairs, initialize) -> 
  
  this.initializeBucketArray_() if initialize != false

  mapUnderConstruction = this
  if keyValuePairs instanceof Array and keyValuePairs.length > 0
    for kv in keyValuePairs
      mapUnderConstruction = mapUnderConstruction.insert(kv.key, kv.value)
  mapUnderConstruction

mugs.HashMap.prototype = new mugs.Collection()

###*
  If a (key,value) pair exists return mugs.Some(value), otherwise mugs.None()
  
  @param key The key of the item to retrieve
  @return Some(item) if an item was associated with the key. Otherwise None
###
mugs.HashMap.prototype.get = (key) -> 
  that   = this
  hash   = this.getHash_(key)
  bucket = this.getBucketFromKey_(key)
  result = new None()
  bucket.forEach( (item) -> if hash == that.getHash_(item.key) then result = new Some(item.value))
  result

###*
  Return a new mugs.HashMap containing the given (key,value) pair.
  
  @param key  The key to associate with the item
  @param item The item to insert into the HashMap
  @return     A new HashMap with the with the new key/item inserted
###
mugs.HashMap.prototype.insert = (key, item) -> 
  index        = this.compress_(this.getHash_(key))
  bucket       = this.getBucketFromKey_(key)
  newBucketArr = this.bucketArray_.update(index, bucket.prepend({ key: key, value: item}))
  newMap       = new mugs.HashMap([], false)
  newMap.bucketArray_ = newBucketArr
  newMap

###*
  Return a new HashMap without the given key. 
  
  @param key The key of the item to remove
  @return A new HashMap without the given key. 
###
mugs.HashMap.prototype.remove = (key) -> 
  that        = this
  index       = that.compress_(that.getHash_(key))
  bucket      = that.getBucketFromKey_(key)
  indexOfItem = bucket.findIndex( (item) -> that.getHash_(item.key) == that.getHash_(key) ).getOrElse(-1)
  if indexOfItem >= 0 
    newBucketArr = that.bucketArray_.update(index, bucket.removeAt(indexOfItem))
    newMap       = new mugs.HashMap([],false)
    newMap.bucketArray_ = newBucketArr
    newMap
  else 
    that

###*
  True if the given key is contained in the TreeMap, otherwise false. 

  @param  key The key to search for 
  @return True if the given key is contained in the HashMap, otherwise false. 
###
mugs.HashMap.prototype.containsKey = (key) -> 
  that    = this
  hash    = this.getHash_(key)
  bucket  = this.getBucketFromKey_(key)
  isThere = false 
  bucket.forEach( (item) -> if hash == that.getHash_(item.key) then isThere = true )
  isThere 
  
###*
  Returns a List with all of the values in the Map
  
  @return {mugs.List} List with all of the values in the Map
###  
mugs.HashMap.prototype.values = () -> 
  this.bucketArray_.flatMap( (bucket) -> bucket.map( (item) -> item.value ))
  
###*
  Returns a List with all of the keys in the Map
  
  @return {mugs.List} List with all of the keys in the Map
###
mugs.HashMap.prototype.keys = () -> 
  this.bucketArray_.flatMap( (bucket) -> bucket.map( (item) -> item.key ))
  
###*
  @private
###
mugs.HashMap.prototype.N_ = 101

###*
  @private
###
mugs.HashMap.prototype.bucketArray_ = new mugs.List() # TODO: Use Random Access List 

###*
  @private
###
mugs.HashMap.prototype.initializeBucketArray_ = () -> 
  i = 0
  while i < this.N_
    this.bucketArray_ = this.bucketArray_.prepend(new mugs.List())
    i++
  return

###*
  @private
###
mugs.HashMap.prototype.getBucketFromKey_ = (key) -> 
  hash  = this.getHash_(key)
  index = this.compress_(hash)
  this.bucketArray_.get(index).get()

###*
  Generates a hash code for an object. 
  @private
###
mugs.HashMap.prototype.getHash_ = (key) -> 
  type = typeof key
  if type == 'object' && key || type == 'function'
    'o' + mugs.getUid(key)
  else
    type.substr(0,1) + key

###*
  Converts the hash-code to an integer and then compresses the result hash-code 
  so it fits in the bucket array
  
  @private
###  
mugs.HashMap.prototype.compress_ = (key) -> 
  index = parseInt(key,36)
  index % this.N_

###
---------------------------------------------------------------------------------------------
Methods related to Collection prototype
---------------------------------------------------------------------------------------------
###

###*
  @private
###
mugs.HashMap.prototype.buildFromArray = (arr) -> 
  new mugs.HashMap(arr)

###*
  Applies function 'f' on each value in the map. This return nothing and is only invoked
  for the side-effects of f.

  @see mugs.Collection
###
mugs.HashMap.prototype.forEach = ( f ) -> 
  this.bucketArray_.forEach( (bucket) -> bucket.forEach(f))