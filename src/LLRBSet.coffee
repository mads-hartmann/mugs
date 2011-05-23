###*
  @fileoverview Contains the implementation of the Set data structure based on a Left Leaning Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
###

mugs.provide("mugs.LLRBSet")

mugs.require("mugs.LLRBNode")
mugs.require("mugs.LLRBLeaf") 
mugs.require("mugs.Indexed")

###*
  mugs.LLRBSet provides the implementation of the abstract data type 'Set' based on a Left-Leaning Red Black Tree. The
  LLRBSet contains the following operations

  <pre>
  insert(key,value)                               O(log n)
  get(index)                                      O(n) (TODO: can be greatly improved)
  remove(index)                                   O(log n)                                             
  keys()                                          O(n)
  values()                                        O(n)
  isEmpty()                                       O(1)
  forEach(f)                                      O(n*O(f))
  update                                          O(n)
  removeAt                                        O(n)
  first                                           O(1)
  last                                            O(n)
  head                                            O(1)
  tail                                            O(log n)
  foldLeft(seed)(f)                               O(n*O(f))
  foldRight(seed)(f)                              O(n*O(f))
  </pre>

  @public
  @augments mugs.Indexed
  @class mugs.LLRBSet Contains the implementation of the Set data structure based on a Left Leaning Red-Black Tree
  
  
  @param items      An array of items to construct the LLRBSet from
  @param comparator A comparator function that can compare the keys (optional). Will use a
                                default comparator if no comparator is given. The default one uses the 
                                < and > operators.
###
mugs.LLRBSet = (items,comparator) ->
  treeUnderConstruction = new mugs.LLRBLeaf(comparator) 
  if items instanceof Array and items.length > 0
    for item in items
      treeUnderConstruction = treeUnderConstruction.insert(item, item)
  this.tree = treeUnderConstruction  
  this.tree.comparator = comparator if comparator?
  this

mugs.LLRBSet.prototype = new mugs.Indexed()

###*
  The elements of the set
  
  @return {List} A list containing all the element of the set
###
mugs.LLRBSet.prototype.values = () ->
  this.tree.values()

###*
  Used to construct a TreeMap from mugs.RedBlackTree. This is intended
  for internal use only. Would've marked it private if I could.
  
  @private
###
mugs.LLRBSet.prototype.buildFromTree = (tree) ->
  set = new mugs.LLRBSet(this.comparator)
  set.tree = tree
  set

###
---------------------------------------------------------------------------------------------
Methods related to Collection prototype
---------------------------------------------------------------------------------------------
###

###*
  Tests if the set contains the element
  @param element The element to check for
###
mugs.LLRBSet.prototype.contains = ( element ) ->
  this.tree.containsKey( element )

###*
  Checks if the collection is empty

  @return true if the collection is empty, otherwise false
###
mugs.LLRBSet.prototype.isEmpty = () ->
  this.tree.isEmpty()

###
---------------------------------------------------------------------------------------------
Methods related to Collection prototype
---------------------------------------------------------------------------------------------
###

###*
  @private
###
mugs.LLRBSet.prototype.buildFromArray = (arr) ->
  new mugs.LLRBSet(arr, this.comparator)

###*
  Applies function 'f' on each value in the collection. This return nothing and is only invoked
  for the side-effects of f.

  @param f The unary function to apply on each element in the collection.
  @see mugs.Collection
###
mugs.LLRBSet.prototype.forEach = ( f ) ->
  # the tree that the set is based on stores key-value pair on each node so we only
  # have to apply the function on the key and then just return that value. 
  q = (kv) -> 
    newValue = f(kv.key)
    { key: newValue, value: newValue }
  this.tree.inorderTraversal( q )

###
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
###

###*
  Creates a new Set with the item inserted 
  
  @param item The Item to insert into the Set
  @return       A new LLRBSet with the item inserted
###
mugs.LLRBSet.prototype.insert = ( item ) ->
  this.buildFromTree(this.tree.insert(item,item))

###*
  Creates a new Set without the given item
  
  @param item   The item to remove from the set
  @return       A new Set without the given item
###
mugs.LLRBSet.prototype.remove = ( item ) ->
  this.buildFromTree(this.tree.remove(item))

###
---------------------------------------------------------------------------------------------
Indexed interface
---------------------------------------------------------------------------------------------
###

###*
  Returns an mugs.Option with the value at the given index if it exists, otherwise mugs.None

  @param index The index of the item to get. 
  @return An mugs.Option with the value at the given index if it exists, otherwise mugs.None
###
mugs.LLRBSet.prototype.get = ( index ) -> 
  this.tree.getAt(index)

###*
  Update the value at a given index. 
  
  @param index The index of the item to update 
  @param item  The new item to store at the given index
  @return      A new collection with the value at the given index updated.
###
mugs.LLRBSet.prototype.update = (index, item) -> 
  itm = this.get(index)
  this.buildFromTree(this.tree.insert(itm,item))

###*
  Returns a new collection without the item at the given index 
  
  @param index the index of the item to remove from the collection.
  @return A new collection without the item at the given index
###
mugs.LLRBSet.prototype.removeAt = (index) ->
  itm = this.get(index).get()
  this.buildFromTree(this.tree.remove(itm))

###*
  Return the first item in the collection wrapped in mugs.Some if the collection is non-empty,
  otherwise a mugs.None.
  
  @return The first item in the collection wrapped in mugs.Some if the collection is non-empty,
          otherwise a mugs.None.
###
mugs.LLRBSet.prototype.first = () ->
  this.get(0)

###*
  Return the tail of the collection. 
  
  @return The tail of the collection 
###
mugs.LLRBSet.prototype.tail = () -> 
  this.removeAt(0)

###*
  Return the last item in the collection wrapped in mugs.Some if the collection is non-empty,
  otherwise a mugs.None.

  @return The last item in the collection wrapped in mugs.Some if the collection is non-empty,
          otherwise a mugs.None.
###
mugs.LLRBSet.prototype.last = () -> 
  this.get(this.size()-1)

###*
  Return the head of the collection wrapped in mugs.Some if the collection is non-empty,
  otherwise a mugs.None. Is the equivalent to first. 
  
  @return The head of the collection wrapped in mugs.Some if the collection is non-empty,
          otherwise a mugs.None.
###
mugs.LLRBSet.prototype.head = () -> 
  this.get(0).get()

###*
  Applies a binary operator on all items of this collection going left to right and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item. 

  @param {*} seed The value to use when the collection is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
###
mugs.LLRBSet.prototype.foldLeft = (seed) -> (f) => 
  this.tree.values().foldLeft(seed)(f)

###*
  Applies a binary operator on all items of this collection going right to left and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item.

  @param {*} seed The value to use when the collection is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
###
mugs.LLRBSet.prototype.foldRight = (seed) -> (f) => 
  this.tree.values().foldRight(seed)(f)