###*
  Complete Binary Tree

  @fileoverview
  Implementation of a Complete Binary Tree. This tree is used in
  the implementation of Random Access List. Implementation follows
  the complete binary tree described in the paper Purely Functional
  Random Access List by Chris Okasaki.

  @author Mads Hartmann Jensen
###

###*
  The base prototype for the Complete Binary Tree implementation.
  This is implemented as an object literal because one instance of 
  this will only ever be needed. The sub-prototypes CompleteBinaryTreeNode
  and CompleteBinaryTreeLeaf are the concrete implementations. 
###
CompleteBinaryTree =
  get: (index) ->
    if index == 0
      this.item
    else if index > 0 && this.isLeaf
      throw new Error("Subscript error")
    else
      if index <= this.size / 2
        this.left.get(index-1)
      else
        this.right.get(index - 1 - this.left.size)
        
  update: (index, item) ->
    if index == 0 and this.isLeaf
      new CompleteBinaryTreeLeaf(item)
    else if index == 0 && !this.isLeaf
      new CompleteBinaryTreeNode(item, this.left, this.right)
    else if index > 0 && this.isLeaf
      throw new Error("Subscript error")
    else
      if index <= this.size / 2
        new CompleteBinaryTreeNode(this.item, this.left.update(index - 1, item), this.right)
      else 
        new CompleteBinaryTreeNode(this.item, this.left, this.right.update(index - 1 - this.left.size, item))


###*
  @class A leaf in a complete binary tree. 
  @param item The item to store at the leaf 
###
CompleteBinaryTreeLeaf = (item) ->
  this.item = item
  this.isLeaf = true 
  this.size = 1
  this

CompleteBinaryTreeLeaf.prototype = CompleteBinaryTree

###*
  @class A node in a complete binary tree 
  @param item   The item to store at the node
  @param left   The left subtree
  @param right  The right subtree
###
CompleteBinaryTreeNode = (item, left, right) ->
  this.item = item
  this.left = left
  this.right = right
  this.isLeaf = false
  this.size = 1 + left.size + right.size
  this

CompleteBinaryTreeNode.prototype = CompleteBinaryTree