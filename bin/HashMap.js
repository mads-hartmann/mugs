/*
  @fileoverview Contains a hash based implementation of the Map ADT
  @author Mads Hartmann Jensen (mads379@gmail.com)
*/mugs.provide("mugs.HashMap");
mugs.require("mugs.Some");
mugs.require("mugs.None");
mugs.require("mugs.Collection");
mugs.require("mugs.List");
/*
  HashMap

  Implementation of an immutable Map based on a hash table.
  The bucket array approach is used and the underlying
  data-structure is a Random Access List. Separate Chaining
  is used to deal with collisions where the chain is based
  on a List.

  A property named something like "mugs_uid_2kczq5" will be added
  to the key objects. This approach has been copied from
  JS_Cols (http://jscols.com/).

  <pre>
  -----------------------------------------------------------
  Core operations of the Map ADT
  -----------------------------------------------------------
  B is the number of items in the bucket array (101 by default)
  b is the number of items in the current bucket
  -----------------------------------------------------------
  get(key)          O(log B + b)
  insert(key,item)  O(log B + b)
  remove(key)       O(log B + b)
  contains(key)     O(log B + b)
  forEach( f )      O(B * b * O(f))
  values()          O(B * b)
  keys()            O(B * b)
  </pre>

  @class HashMap
  @augments mugs.Collection
  @param {Array} keyValuePairs An array containing objects with the properties key & value.
  @param {Bool} initialize This is only used internally. It's true if the bucket array should be initialize
*/
mugs.HashMap = function(keyValuePairs, initialize) {
  var kv, mapUnderConstruction, _i, _len;
  if (initialize !== false) {
    this.initializeBucketArray_();
  }
  mapUnderConstruction = this;
  if (keyValuePairs instanceof Array && keyValuePairs.length > 0) {
    for (_i = 0, _len = keyValuePairs.length; _i < _len; _i++) {
      kv = keyValuePairs[_i];
      mapUnderConstruction = mapUnderConstruction.insert(kv.key, kv.value);
    }
  }
  return mapUnderConstruction;
};
mugs.HashMap.prototype = new mugs.Collection();
/*
  @param key The key of the item to retrieve
  @return Some(item) if an item was associated with the key. Otherwise None
*/
mugs.HashMap.prototype.get = function(key) {
  var bucket, hash, result, that;
  that = this;
  hash = this.getHash_(key);
  bucket = this.getBucketFromKey_(key);
  result = new None();
  bucket.forEach(function(item) {
    if (hash === that.getHash_(item.key)) {
      return result = new Some(item.value);
    }
  });
  return result;
};
/*
  @param key The key to associate with the item
  @param item The item to insert into the HashMap
  @return A new HashMap with the with the new key/item inserted
*/
mugs.HashMap.prototype.insert = function(key, item) {
  var bucket, index, newBucketArr, newMap;
  index = this.compress_(this.getHash_(key));
  bucket = this.getBucketFromKey_(key);
  newBucketArr = this.bucketArray_.update(index, bucket.prepend({
    key: key,
    value: item
  }));
  newMap = new mugs.HashMap([], false);
  newMap.bucketArray_ = newBucketArr;
  return newMap;
};
/*
  Return a new HashMap without the given key.
  @param key The key of the item to remove
  @return A new HashMap without the given key.
*/
mugs.HashMap.prototype.remove = function(key) {
  var bucket, index, indexOfItem, newBucketArr, newMap, that;
  that = this;
  index = that.compress_(that.getHash_(key));
  bucket = that.getBucketFromKey_(key);
  indexOfItem = bucket.findIndex(function(item) {
    return that.getHash_(item.key) === that.getHash_(key);
  }).getOrElse(-1);
  if (indexOfItem >= 0) {
    newBucketArr = that.bucketArray_.update(index, bucket.removeAt(indexOfItem));
    newMap = new mugs.HashMap([], false);
    newMap.bucketArray_ = newBucketArr;
    return newMap;
  } else {
    return that;
  }
};
/*
  @param key The to check the presence of
*/
mugs.HashMap.prototype.contains = function(key) {
  var bucket, hash, isThere, that;
  that = this;
  hash = this.getHash_(key);
  bucket = this.getBucketFromKey_(key);
  isThere = false;
  bucket.forEach(function(item) {
    if (hash === that.getHash_(item.key)) {
      return isThere = true;
    }
  });
  return isThere;
};
/*
  Returns a List with all of the values in the Map
  @return {mugs.List} List with all of the values in the Map
*/
mugs.HashMap.prototype.values = function() {
  return this.bucketArray_.flatMap(function(bucket) {
    return bucket.map(function(item) {
      return item.value;
    });
  });
};
/*
  Returns a List with all of the keys in the Map
  @return {mugs.List} List with all of the keys in the Map
*/
mugs.HashMap.prototype.keys = function() {
  return this.bucketArray_.flatMap(function(bucket) {
    return bucket.map(function(item) {
      return item.key;
    });
  });
};
/*
  @private
*/
mugs.HashMap.prototype.N_ = 101;
/*
  @private
*/
mugs.HashMap.prototype.bucketArray_ = new mugs.List();
/*
  @private
*/
mugs.HashMap.prototype.initializeBucketArray_ = function() {
  var i;
  i = 0;
  while (i < this.N_) {
    this.bucketArray_ = this.bucketArray_.prepend(new mugs.List());
    i++;
  }
};
/*
  @private
*/
mugs.HashMap.prototype.getBucketFromKey_ = function(key) {
  var hash, index;
  hash = this.getHash_(key);
  index = this.compress_(hash);
  return this.bucketArray_.get(index).get();
};
/*
  Generates a hash code for an object.
  @private
*/
mugs.HashMap.prototype.getHash_ = function(key) {
  var type;
  type = typeof key;
  if (type === 'object' && key || type === 'function') {
    return 'o' + mugs.getUid(key);
  } else {
    return type.substr(0, 1) + key;
  }
};
/*
  Converts the hash-code to an integer and then compresses the result hash-code
  so it fits in the bucket array
  @private
*/
mugs.HashMap.prototype.compress_ = function(key) {
  var index;
  index = parseInt(key, 36);
  return index % this.N_;
};
/*
---------------------------------------------------------------------------------------------
Methods related to Collection prototype
---------------------------------------------------------------------------------------------
*/
mugs.HashMap.prototype.buildFromArray = function(arr) {
  return new mugs.HashMap(arr);
};
mugs.HashMap.prototype.forEach = function(f) {
  return this.bucketArray_.forEach(function(bucket) {
    return bucket.forEach(f);
  });
};