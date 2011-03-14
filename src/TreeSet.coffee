###*
  @fileoverview Contains the implementation of the Set data structure based on a Red-Black Tree
  @author Mads Hartmann Jensen (mads379@gmail.com)
###
if require?
  RedBlackNodeWrapper = require('../src/RedBlackTree')
  RedBlackNode        = RedBlackNodeWrapper.RedBlackNode
  RedBlackLeaf        = RedBlackNodeWrapper.Leaf
  RED                 = RedBlackNodeWrapper.RED
  BLACK               = RedBlackNodeWrapper.BLACK
  Traversable = (require './Traversable').Traversable

###*
  
###  
TreeSet = (elements,comparator) ->
  if elements instanceof Array and elements.length > 0 
    treeUnderConstruction = new RedBlackLeaf(BLACK)
    for element in elements
      treeUnderConstruction = treeUnderConstruction.insert(element, element)
    this.tree = treeUnderConstruction  
  else
    this.tree = new RedBlackLeaf(BLACK)
  this.tree.comparator = comparator if comparator?
  this

###*
  
###
TreeSet.prototype.insert = ( element ) -> 
  this.buildFromTree(this.tree.insert(element,element))

###*
  
###
TreeSet.prototype.remove = ( element ) ->
  this.buildFromTree(this.tree.remove(element))

###*
  
###
TreeSet.prototype.contains = ( element ) -> 
  this.tree.containsKey( element )

###*
  Used to construct a TreeMap from RedBlackTree. This is intended 
  for internal use only. Would've marked it private if I could.
  @private
###
TreeSet.prototype.buildFromTree = (tree) -> 
  set = new TreeSet(this.comparator)
  set.tree = tree
  set

###
---------------------------------------------------------------------------------------------
Methods related to Traversable prototype 
---------------------------------------------------------------------------------------------
###

###*
  @private
###
TreeSet.prototype.buildFromArray = (arr) -> 
  new TreeSet(arr, this.comparator)

###*
  Applies function 'f' on each value in the map. This return nothing and is only invoked
  for the side-effects of f. 
  @see mahj.Traversable
###
TreeSet.prototype.forEach = ( f ) -> 
  this.tree.inorderTraversal( f )

if exports?
  exports.TreeSet = TreeSet