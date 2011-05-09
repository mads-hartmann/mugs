###*
  @fileoverview Contains the implementation of the Set data structure based on a Left Leaning Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
###

mugs.provide("mugs.LLRBSet")

mugs.require("mugs.LLRBNode")
mugs.require("mugs.LLRBLeaf") 

###*
  @augments mugs.Collection
  @class mugs.LLRBSet Contains the implementation of the Set data structure based on a Left Leaning Red-Black Tree
  @public
###
mugs.LLRBSet = (items,comparator) ->
  treeUnderConstruction = new mugs.LLRBLeaf() 
  if items instanceof Array and items.length > 0
    for item in items
      treeUnderConstruction = treeUnderConstruction.insert(item, item)
  this.tree = treeUnderConstruction  
  this.tree.comparator = comparator if comparator?
  this

mugs.LLRBSet.prototype = new mugs.Extensible()

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
  @private
###
mugs.LLRBSet.prototype.buildFromArray = (arr) ->
  new mugs.LLRBSet(arr, this.comparator)

###*
  Applies function 'f' on each value in the map. This return nothing and is only invoked
  for the side-effects of f.
  @param f The unary function to apply on each element in the set.
  @see mugs.Collection
###
mugs.LLRBSet.prototype.forEach = ( f ) ->
  # the tree that the set is based on stores key-value pair on each node so we only
  # have to apply the function on the key and then just return that value. 
  q = (kv) -> 
    newValue = f(kv.key)
    { key: newValue, value: newValue }
  this.tree.inorderTraversal( q )

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
