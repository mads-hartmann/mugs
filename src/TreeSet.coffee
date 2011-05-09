###*
  @fileoverview Contains the implementation of the Set data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
###

mugs.provide('mugs.TreeSet')

mugs.require('mugs.RedBlackLeaf')
mugs.require('mugs.RedBlackNode')

###*
  @augments mugs.Extensible
  @class mugs.TreeSet provides the implementation of the abstract data type Set based on a Red Black Tree
  @public
###
mugs.TreeSet = (elements,comparator) ->
  treeUnderConstruction = new mugs.RedBlackLeaf(mugs.RedBlack.BLACK)
  if elements instanceof Array and elements.length > 0
    for element in elements
      treeUnderConstruction = treeUnderConstruction.insert(element, element)
    this.tree = treeUnderConstruction
  else
    this.tree = new mugs.RedBlackLeaf(mugs.RedBlack.BLACK)
  this.tree.comparator = comparator if comparator?
  this

mugs.TreeSet.prototype = new mugs.Extensible()

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