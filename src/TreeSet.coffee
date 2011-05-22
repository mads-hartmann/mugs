###*
  @fileoverview Contains the implementation of the Set data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
###

mugs.provide('mugs.TreeSet')

mugs.require('mugs.RedBlackLeaf')
mugs.require('mugs.RedBlackNode')
mugs.require("mugs.Indexed")

###*
  mugs.TreeSet provides the implementation of the abstract data type Set based on a Red Black Tree. The
  TreeSet contains the following operations

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
  @class mugs.TreeSet provides the implementation of the abstract data type Set based on a Red Black Tree
  
  
  @param items      An array of items to construct the LLRBSet from
  @param comparator A comparator function that can compare the keys (optional). Will use a
                                default comparator if no comparator is given. The default one uses the 
                                < and > operators.
###
mugs.TreeSet = (items,comparator) ->
  treeUnderConstruction = new mugs.RedBlackLeaf(mugs.RedBlack.BLACK)
  if items instanceof Array and items.length > 0
    for item in items
      treeUnderConstruction = treeUnderConstruction.insert(item, item)
    this.tree = treeUnderConstruction
  else
    this.tree = new mugs.RedBlackLeaf(mugs.RedBlack.BLACK)
  this.tree.comparator = comparator if comparator?
  this

mugs.TreeSet.prototype = new mugs.Indexed()

###*
  The elements of the set
  
  @return {List} A list containing all the element of the set
###
mugs.TreeSet.prototype.values = () ->
  this.tree.values()

###*
  Used to construct a TreeMap from mugs.RedBlackTree. This is intended
  for internal use only. Would've marked it private if I could.
  
  @private
###
mugs.TreeSet.prototype.buildFromTree = (tree) ->
  set = new mugs.TreeSet([], this.comparator)
  set.tree = tree
  set

###
---------------------------------------------------------------------------------------------
Collection prototype
---------------------------------------------------------------------------------------------
###

###*
  @private
###
mugs.TreeSet.prototype.buildFromArray = (arr) ->
  new mugs.TreeSet(arr, this.comparator)

###*
  Applies function 'f' on each value in the set. This return nothing and is only invoked
  for the side-effects of f.
  
  @param f The unary function to apply on each element in the set.
  @see mugs.Collection
###
mugs.TreeSet.prototype.forEach = ( f ) ->
  # the tree that the set is based on stores key-value pair on each node so we only
  # have to apply the function on the key and then just return that value. 
  q = (kv) -> 
    newValue = f(kv.key)
    { key: newValue, value: newValue }
  this.tree.inorderTraversal( q )

###*
  Checks if the collection is empty

  @return true if the collection is empty, otherwise false
###
mugs.TreeSet.prototype.isEmpty = () ->
  this.tree.isEmpty()
  
###*
  Tests if the set contains the element
  
  @param element The element to check for
###
mugs.TreeSet.prototype.contains = ( element ) ->
  this.tree.containsKey( element )

###
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
###

###*
  Insert an element in the set. If the set already contains an element equal to the given value,
  it is replaced with the new value.
  
  @param item The element to insert into the set
###
mugs.TreeSet.prototype.insert = ( item ) ->
  this.buildFromTree(this.tree.insert(item,item))

###*
  Delete an element from the set
  
  @param item The element to remove from the set
###
mugs.TreeSet.prototype.remove = ( item ) ->
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
mugs.TreeSet.prototype.get = ( index ) -> 
  this.tree.atIndex(index)

###*
  Update the value at a given index. 

  @param index The index of the item to update 
  @param item  The new item to store at the given index
  @return      A new collection with the value at the given index updated.
###
mugs.TreeSet.prototype.update = (index, item) -> 
  itm = this.get(index)
  this.buildFromTree(this.tree.insert(itm,item))

###*
  Returns a new collection without the item at the given index 

  @param index the index of the item to remove from the collection.
  @return A new collection without the item at the given index
###
mugs.TreeSet.prototype.removeAt = (index) ->
  itm = this.get(index).get()
  this.buildFromTree(this.tree.remove(itm))
  
###*
  Return the first item in the collection wrapped in mugs.Some if the collection is non-empty,
  otherwise a mugs.None.

  @return The first item in the collection wrapped in mugs.Some if the collection is non-empty,
          otherwise a mugs.None.
###
mugs.TreeSet.prototype.first = () ->
  this.get(0)

###*
  Return the tail of the collection. 

  @return The tail of the collection 
###
mugs.TreeSet.prototype.tail = () -> 
  this.removeAt(0)
  
###*
  Return the last item in the collection wrapped in mugs.Some if the collection is non-empty,
  otherwise a mugs.None.

  @return The last item in the collection wrapped in mugs.Some if the collection is non-empty,
          otherwise a mugs.None.
###
mugs.TreeSet.prototype.last = () -> 
  this.get(this.size()-1)
  
###*
  Return the head of the collection wrapped in mugs.Some if the collection is non-empty,
  otherwise a mugs.None. Is the equivalent to first. 

  @return The head of the collection wrapped in mugs.Some if the collection is non-empty,
          otherwise a mugs.None.
###
mugs.TreeSet.prototype.head = () -> 
  this.get(0).get()

###*
  Applies a binary operator on all items of this collection going left to right and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item. 

  @param {*} seed The value to use when the collection is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
###
mugs.TreeSet.prototype.foldLeft = (seed) -> (f) => 
  this.tree.values().foldLeft(seed)(f)

###*
  Applies a binary operator on all items of this collection going right to left and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that
  takes a function which will then be applied to the items. The function is binary where 
  the first parameter is the value of the fold so far and the second is the current item.

  @param {*} seed The value to use when the collection is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
###
mugs.TreeSet.prototype.foldRight = (seed) -> (f) => 
  this.tree.values().foldRight(seed)(f)
