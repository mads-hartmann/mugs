###*
  @fileoverview

  A Red-black tree is a binary tree with two invariants that ensure
  that the tree is balanced to keep the height of the tree low.

  1. No red node has a red child
  2. Every path from the root to an empty node contains
     the same number of black nodes

  The insert and contains methods have been implemented following Chris Okasaki's
  book 'purely functional data structures' and the remove operations has been
  implemented following this blog: http://matt.might.net/articles/red-black-delete/

  @author Mads Hartmann Jensen (mads379@gmail.com)
### 

mugs.provide('mugs.RedBlack')
mugs.provide('mugs.RedBlackLeaf')
mugs.provide('mugs.RedBlackNode')

mugs.require("mugs.List")

# Constants used to color the trees. The proprty 'color' is only for debugging.
mugs.RedBlack = {}
mugs.RedBlack.RED = {
  color:      "RED",
  add:        () -> mugs.RedBlack.BLACK,
  subtract:   () -> mugs.RedBlack.NEGATIVE_BLACK
}
mugs.RedBlack.BLACK = {
  color:      "BLACK",
  add:        () -> mugs.RedBlack.DOUBLE_BLACK,
  subtract:   () -> mugs.RedBlack.RED
}
mugs.RedBlack.DOUBLE_BLACK = {
  color:      "DOUBLE BLACK",
  add:        () -> mugs.RedBlack.DOUBLE_BLACK,
  subtract:   () -> mugs.RedBlack.BLACK
}
mugs.RedBlack.NEGATIVE_BLACK = {
  color:      "NEGATIVE BLACK"
  add:        () -> mugs.RedBlack.RED
  subtract:   () -> mugs.RedBlack.NEGATIVE_BLACK
}

mugs.RedBlackLeaf = (color, comparator) ->
  this.color   = color
  this.left    = new mugs.None()
  this.right   = new mugs.None()
  this.key     = new mugs.None()
  this.value   = new mugs.None()
  this.comparator = if (comparator) then comparator else mugs.RedBlackNode.prototype.standard_comparator
  this

mugs.RedBlackLeaf.prototype.copy = (properties) ->
  new mugs.RedBlackLeaf(properties.color || this.color, properties.comparator || this.comparator)

mugs.RedBlackLeaf.prototype.isEmpty = () -> true
mugs.RedBlackLeaf.prototype.containsKey = (key) -> false
mugs.RedBlackLeaf.prototype.get = (key) -> new mugs.None()
mugs.RedBlackLeaf.prototype.keys = () -> new mugs.List()
mugs.RedBlackLeaf.prototype.remove = () -> this
mugs.RedBlackLeaf.prototype.values = () -> new mugs.List()
mugs.RedBlackLeaf.prototype.inorderTraversal = (f) -> return # nothing
mugs.RedBlackLeaf.prototype.insert = (key,value) -> 
  new mugs.RedBlackNode(mugs.RedBlack.RED, 
    new mugs.RedBlackLeaf(mugs.RedBlack.BLACK, this.comparator), 
    key, 
    value, 
    new mugs.RedBlackLeaf(mugs.RedBlack.BLACK, this.comparator),
    this.comparator)

mugs.RedBlackNode = (color, left, key, value, right, comparator) ->
  this.color      = color
  this.left       = left
  this.key        = key
  this.value      = value
  this.right      = right
  this.comparator = if (comparator) then comparator else mugs.RedBlackNode.prototype.standard_comparator
  using = if (comparator) then "custom" else "default"
  this

mugs.RedBlackNode.prototype.copy = (properties) ->
  new mugs.RedBlackNode(
    properties.color || this.color,
    properties.left || this.left,
    properties.key || this.key,
    properties.value || this.value, 
    properties.right || this.right,
    properties.comparator || this.comparator)

###*
  The standard compare function. It's used if the user doesn't
  supply one when creating the tree
###
mugs.RedBlackNode.prototype.standard_comparator = (elem1, elem2) ->
  if      (elem1 < elem2) then -1
  else if (elem1 > elem2) then  1
  else                          0

###*
  Given a key it finds the value, if any.
###
mugs.RedBlackNode.prototype.get = (key) ->
  comp = this.comparator(key, this.key)
  if      (comp < 0) then this.left.get(key)
  else if (comp > 0) then this.right.get(key)
  else                    new mugs.Some(this.value)

###*
  Returns the item at a given index. The item is found by doing 
  an inorder traversal of the tree subtracting 1 from the index at each node 
  until the index is 0. 
  
  @param  index The index of the item to retrieve 
  @return       Some(item) if the index is within the bounds of 
                size of the tree. otherwise None.
###
mugs.RedBlackNode.prototype.atIndex = (index) -> 
  result = new mugs.None()
  this.inorderTraversal( (kv) -> 
    if index == 0 
      result = new mugs.Some(kv.value)
      index--
    else
      index--
  )
  return result

###*
  Finds the smallest key in the tree
  Complexity of O ( log n )
###
mugs.RedBlackNode.prototype.minKey = () ->
  if (this.left.isEmpty()) then this.key else this.left.minKey()

###*
  Finds the largest key in the tree
  Complexity of O ( log n )
###
mugs.RedBlackNode.prototype.maxKey = () ->
  if (this.right.isEmpty()) then this.key else this.right.maxKey()

###*
  Checks if the given key exists in the tree
###
mugs.RedBlackNode.prototype.containsKey = (key) ->
  comp = this.comparator(key, this.key)
  if      (comp < 0) then this.left.containsKey(key)
  else if (comp > 0) then this.right.containsKey(key)
  else true

###*
  returns a sorted List with all of the keys stored in the tree
  @return {mugs.List} A sorted List with all of the key stored in the tree
###
mugs.RedBlackNode.prototype.keys = () ->
  elements = []
  this.inorderTraversal( (kv) -> elements.push(kv.key) )
  new mugs.List().buildFromArray(elements)

###*
  returns a sorted List with all of the values stored in the tree
  @return {mugs.List} A sorted List with all of the values stored in the tree
###
mugs.RedBlackNode.prototype.values = () ->
  elements = []
  this.inorderTraversal( (kv) -> elements.push(kv.value) )
  new mugs.List().buildFromArray(elements)

###*
  This will do an inorder traversal of the tree applying the function 'f'
  on each key/value pair in the tree. This doesn't return anything and is only
  executed for the side-effects of f.

  @param {Function} f A function taking one argument which is an object with
                      the properties 'key' and 'value'
###
mugs.RedBlackNode.prototype.inorderTraversal = (f) ->
  if !this.left.isEmpty() then this.left.inorderTraversal(f)
  f({key: this.key, value: this.value})
  if !this.right.isEmpty() then this.right.inorderTraversal(f)
  
###*
  Returns a new tree with the inserted element.  If the Tree already contains that key
  the old value is replaced with the new value
###
mugs.RedBlackNode.prototype.insert = (key,value) ->
  that = this
  __insert = (tree) ->
    {color: c, left: l, key: k, value: v, right: r} = tree
    compare = that.comparator(key, k)

    if (tree.isEmpty())
      new mugs.RedBlackNode(mugs.RedBlack.RED, new mugs.RedBlackLeaf(mugs.RedBlack.BLACK, that.comparator), key, value, new mugs.RedBlackLeaf(mugs.RedBlack.BLACK, that.comparator), that.comparator)
    else if (compare < 0)
      that.balance(c, __insert(l), k, v, r)
    else if (compare > 0)
      that.balance(c, l, k,v, __insert(r))
    else
      new mugs.RedBlackNode(mugs.RedBlack.RED, tree.left, key, value, tree.right, that.comparator)

  t = __insert(that)
  new mugs.RedBlackNode(mugs.RedBlack.BLACK, t.left, t.key, t.value, t.right, t.comparator)

###*
  Returns a new tree without the 'key'
  Port from this racket example: http://matt.might.net/articles/red-black-delete/
###
mugs.RedBlackNode.prototype.remove = (key) ->
  __rm = (tree) =>
    isExternalNode          = () -> tree.left.isEmpty() && tree.right.isEmpty()
    isInternalNode          = () -> !tree.left.isEmpty() && !tree.right.isEmpty()
    isNodeWithOneChildLeft  = () -> tree.right.isEmpty()
    isNodeWithOneChildRight = () -> tree.left.isEmpty()
    # The __rm call traversed all the way to the bottom of the tree. This happens
    # when the item to remove wasn't in the tree.
    if ( tree.isEmpty() )
      tree
    # Removing an external node
    else if (isExternalNode())
     if (tree.color == mugs.RedBlack.RED)
       new mugs.RedBlackLeaf(mugs.RedBlack.BLACK, tree.comparator)
     else if (tree.color == mugs.RedBlack.BLACK)
       new mugs.RedBlackLeaf(mugs.RedBlack.DOUBLE_BLACK, tree.comparator)

    # Removing a node with one child
    else if (isNodeWithOneChildLeft()) # I can probably use the option here (i.e.) this.right.getOrElse(this.left.getOrElse())
      new mugs.RedBlackNode( mugs.RedBlack.BLACK, tree.left.left, tree.left.key, tree.left.value, tree.left.right, tree.comparator)
    else if (isNodeWithOneChildRight())
      new mugs.RedBlackNode( mugs.RedBlack.BLACK, tree.right.left, tree.right.key, tree.right.value, tree.right.right, tree.comparator)

    # Removing an internal node
    else if (isInternalNode())
      # Convert a removal of an internal noe to a node with a most one child.
      # Find the largest element in the left subtree, use that value for the new tree
      # and remove the other node
      max         = tree.left.maxKey()
      value       = tree.left.get(max).get()
      newLeftTree = tree.left.remove(max)
      this.bubble( tree.color, newLeftTree, max, value, tree.right)
    else
      new mugs.RedBlackNode(tree.color, tree.left, tree.key, tree.value, tree.right, tree.comparator)

  # Search for the subtree to remove the element from. Keep the references
  # to the tree that don't contain the element. I.e. if the element we're looking
  # for is in the right subtree we can just reuse the reference to the left subtree
  # in the new tree we're creating.
  compare = this.comparator(key, this.key)
  if (compare < 0)
    new mugs.RedBlackNode(this.color, this.left.remove(key), this.key, this.value, this.right, this.comparator)
  else if (compare > 0)
    new mugs.RedBlackNode(this.color, this.left, this.key, this.value, this.right.remove(key), this.comparator)
  else
    __rm(this)

###*
  The bubble procedure moves double-blacks from children to parents,
  or eliminates them entirely if possible.
  A black is subtracted from the children, and added to the parent:
###
mugs.RedBlackNode.prototype.bubble = (color, left, key, value, right) ->
  if ( left.color == mugs.RedBlack.DOUBLE_BLACK || right.color == mugs.RedBlack.DOUBLE_BLACK)    
    this.balance(
      color.add(),
      left.copy( { color: left.color.subtract() } ),
      key,
      value,
      right.copy( { color: right.color.subtract() }))
  else
    new mugs.RedBlackNode(color, left, key, value, right, this.comparator)

###*
  This function balances the tree by eliminating any black-red-red path in the tree.
  This situation can occur in any of four configurations:

  Reading the nodes from top to bottom:

  1. Black node followed by a red left node followed by a red left node
  2. Black node followed by a red left node followed by a red right node
  3. Black node followed by a red right node followed by a red right node
  4. Black node followed by a red right node followed by a red left node

  The solution is always the same: Rewrite the black-red-red path as a red node with
  two black children.

  However to support removal two additional colors have been added to the mix:
  Negative-black and double black.

  The double black can occur instead of black in the four configurations above.
  The solution is then to convert it into a black node with two black children.

  Luckily the same code can handle both the black and double black cases by using a
  little trick: Each color has a `subtract` and an `add` method which returns another
  color (see each color object for more information). Instead of rewriting
  "the black/double black-red-red"" into a red node with two black children we just
  subtract the color of the root thus turning black into red and double-black into black.

  The negative black node can occur in the following two configurations:

  1. Double black followed by left negative black with two black children
  2. Double black followed by right negative black with two black children

  The solution is to transform it into a node with two black children and a left (or right
  depending on the initial configuration) red node.
###
mugs.RedBlackNode.prototype.balance = (color, left, key, value, right) ->
  leftFollowedByLeft   = () ->
    (!left.isEmpty() && !left.left.isEmpty()) &&
    (color == mugs.RedBlack.BLACK || color == mugs.RedBlack.DOUBLE_BLACK) and left.color == mugs.RedBlack.RED and left.left.color == mugs.RedBlack.RED

  leftFollowedByRight  = () ->
    (!left.isEmpty() && !left.right.isEmpty()) &&
    (color == mugs.RedBlack.BLACK || color == mugs.RedBlack.DOUBLE_BLACK) and left.color == mugs.RedBlack.RED and left.right.color == mugs.RedBlack.RED

  rightFollowedByLeft  = () ->
    (!right.isEmpty() && !right.left.isEmpty()) &&
    (color == mugs.RedBlack.BLACK || color == mugs.RedBlack.DOUBLE_BLACK) && right.color == mugs.RedBlack.RED && right.left.color  == mugs.RedBlack.RED

  rightFollowedByRight = () ->
    (!right.isEmpty() && !right.right.isEmpty()) &&
    (color == mugs.RedBlack.BLACK || color == mugs.RedBlack.DOUBLE_BLACK) && right.color == mugs.RedBlack.RED && right.right.color == mugs.RedBlack.RED

  leftIsNegativeBlack  = () -> (!left.isEmpty()) && left.color == mugs.RedBlack.NEGATIVE_BLACK

  rightIsNegativeBlack = () -> (!right.isEmpty()) && right.color == mugs.RedBlack.NEGATIVE_BLACK

  if (leftFollowedByLeft())
    new mugs.RedBlackNode(color.subtract(), # The root color is subtracted. This takes care of double black
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,left.left.left,left.left.key,left.left.value,left.left.right, this.comparator),
      left.key,
      left.value,
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,left.right,key, value,right, this.comparator),
      this.comparator)
  else if (leftFollowedByRight())
    new mugs.RedBlackNode(color.subtract(),
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,left.left,left.key,left.value,left.right.left,this.comparator),
      left.right.key,
      left.right.value,
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,right.right.right,key, value,right,this.comparator),
      this.comparator)
  else if (rightFollowedByLeft())
    new mugs.RedBlackNode(color.subtract(),
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,left,key, value,right.left.left,this.comparator),
      right.left.key,
      right.left.value,
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,right.left.right,right.key,right.value,right.right,this.comparator),
      this.comparator)
  else if (rightFollowedByRight())
    new mugs.RedBlackNode(color.subtract(),
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,left,key, value,right.left,this.comparator),
      right.key,
      right.value,
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,right.right.left,right.right.key,right.right.value,right.right.right,this.comparator),
      this.comparator)
  else if (leftIsNegativeBlack())
    new mugs.RedBlackNode(mugs.RedBlack.BLACK,
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,
        this.balance( mugs.RedBlack.RED,left.left.left, left.left.key,left.left.value, left.left.right ),
        left.key,
        left.value,
        left.right.left,
        this.comparator
      ),
      left.right.key,
      left.right.value,
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,right.left.right, key,value, right,this.comparator),
      this.comparator
    )
  else if (rightIsNegativeBlack())
    ###
      BEFORE        AFTER
        z             w
      1   x         z   x
        w   y      1 2 3  y
       2 3 4 5           4 5
    ###
    #w 
    new mugs.RedBlackNode(mugs.RedBlack.BLACK,
      #z 
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,
        left, #1
        key,
        value,
        right.left.left #2
      ),
       right.left.key,
       right.left.value,
      #x
      new mugs.RedBlackNode(mugs.RedBlack.BLACK,
        right.left.right, #3
        right.key,
        right.value,
        #y
        this.balance( mugs.RedBlack.RED, 
          right.right.left, #4
          right.right.key, 
          right.right.value, 
          right.right.right #5
        )
      )
    )
  else
    new mugs.RedBlackNode(color, left, key, value, right, this.comparator)

###*
  A node is never empty
###
mugs.RedBlackNode.prototype.isEmpty = () -> false

###
  RELATED TO TESTING
###

mugs.RedBlackLeaf.prototype.count_ = () -> 0
mugs.RedBlackLeaf.prototype.check_ = () -> 
  return 1 if this.color == mugs.RedBlack.BLACK
  return 2 if this.color == mugs.RedBlack.DOUBLE_BLACK

mugs.RedBlackNode.prototype.count_ = () -> 
  this.left.count_() + 1 + this.right.count_()

# returns the black-depth if three is well-formed, else throws an exception
mugs.RedBlackNode.prototype.check_ = () ->
  if this.color == RED && this.left.color == RED
    throw new Error("Red node has red child(" + node.key+","+node.value+")")
  blackDepth = this.left.check_()
  if blackDepth != this.right.check_()
    throw new Error("Black depths differ")
  else
    return blackDepth + 1 if this.color == mugs.RedBlack.BLACK
    return blackDepth + 2 if this.color == mugs.RedBlack.DOUBLE_BLACK
    return blackDepth     if this.color == mugs.RedBlack.RED
    return blackDepth - 1 if this.color == mugs.RedBlack.NEGATIVE_BLACK


