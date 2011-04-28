/**
  Complete Binary Tree

  @fileoverview
  Implementation of a Complete Binary Tree. This tree is used in
  the implementation of Random Access List. Implementation follows
  the complete binary tree described in the paper Purely Functional
  Random Access List by Chris Okasaki.

  @author Mads Hartmann Jensen
*/
/**
  The base prototype for the Complete Binary Tree implementation.
  The sub-prototypes CompleteBinaryTreeNode and CompleteBinaryTreeLeaf
  are the concrete implementations.
*/mugs.provide('mugs.CompleteBinaryTree');
mugs.provide('mugs.CompleteBinaryTreeNode');
mugs.provide('mugs.CompleteBinaryTreeLeaf');
mugs.CompleteBinaryTree = function() {
  return this;
};
mugs.CompleteBinaryTree.prototype.get = function(index) {
  if (index === 0) {
    return this.item;
  } else if (index > 0 && this.isLeaf) {
    throw new Error("Subscript error");
  } else {
    if (index <= this.size / 2) {
      return this.left.get(index - 1);
    } else {
      return this.right.get(index - 1 - this.left.size);
    }
  }
};
mugs.CompleteBinaryTree.prototype.update = function(index, item) {
  if (index === 0 && this.isLeaf) {
    return new mugs.CompleteBinaryTreeLeaf(item);
  } else if (index === 0 && !this.isLeaf) {
    return new mugs.CompleteBinaryTreeNode(item, this.left, this.right);
  } else if (index > 0 && this.isLeaf) {
    throw new Error("Subscript error");
  } else {
    if (index <= this.size / 2) {
      return new mugs.CompleteBinaryTreeNode(this.item, this.left.update(index - 1, item), this.right);
    } else {
      return new mugs.CompleteBinaryTreeNode(this.item, this.left, this.right.update(index - 1 - this.left.size, item));
    }
  }
};
mugs.CompleteBinaryTree.prototype.preorderTraversal = function(f) {
  if (!this.isLeaf) {
    f(this.item);
    this.left.preorderTraversal(f);
    return this.right.preorderTraversal(f);
  } else {
    return f(this.item);
  }
};
/**
  @class A leaf in a complete binary tree.
  @param item The item to store at the leaf
*/
mugs.CompleteBinaryTreeLeaf = function(item) {
  this.item = item;
  this.isLeaf = true;
  this.size = 1;
  return this;
};
mugs.CompleteBinaryTreeLeaf.prototype = new mugs.CompleteBinaryTree();
/**
  @class A node in a complete binary tree
  @param item   The item to store at the node
  @param left   The left subtree
  @param right  The right subtree
*/
mugs.CompleteBinaryTreeNode = function(item, left, right) {
  this.item = item;
  this.left = left;
  this.right = right;
  this.isLeaf = false;
  this.size = 1 + left.size + right.size;
  return this;
};
mugs.CompleteBinaryTreeNode.prototype = new mugs.CompleteBinaryTree();