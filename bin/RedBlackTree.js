/**
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
*/var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
mugs.provide('mugs.RedBlack');
mugs.provide('mugs.RedBlackLeaf');
mugs.provide('mugs.RedBlackNode');
mugs.require("mugs.List");
mugs.RedBlack = {};
mugs.RedBlack.RED = {
  color: "RED",
  add: function() {
    return mugs.RedBlack.BLACK;
  },
  subtract: function() {
    return mugs.RedBlack.NEGATIVE_BLACK;
  }
};
mugs.RedBlack.BLACK = {
  color: "BLACK",
  add: function() {
    return mugs.RedBlack.DOUBLE_BLACK;
  },
  subtract: function() {
    return mugs.RedBlack.RED;
  }
};
mugs.RedBlack.DOUBLE_BLACK = {
  color: "DOUBLE BLACK",
  add: function() {
    return mugs.RedBlack.DOUBLE_BLACK;
  },
  subtract: function() {
    return mugs.RedBlack.BLACK;
  }
};
mugs.RedBlack.NEGATIVE_BLACK = {
  color: "NEGATIVE BLACK",
  add: function() {
    return mugs.RedBlack.RED;
  },
  subtract: function() {
    return mugs.RedBlack.NEGATIVE_BLACK;
  }
};
mugs.RedBlackLeaf = function(color) {
  this.color = color;
  this.left = new mugs.None();
  this.right = new mugs.None();
  this.key = new mugs.None();
  this.value = new mugs.None();
  return this;
};
mugs.RedBlackLeaf.prototype.isEmpty = function() {
  return true;
};
mugs.RedBlackLeaf.prototype.containsKey = function(key) {
  return false;
};
mugs.RedBlackLeaf.prototype.get = function(key) {
  return new mugs.None();
};
mugs.RedBlackLeaf.prototype.keys = function() {
  return new mugs.List();
};
mugs.RedBlackLeaf.prototype.values = function() {
  return new mugs.List();
};
mugs.RedBlackLeaf.prototype.inorderTraversal = function(f) {};
mugs.RedBlackLeaf.prototype.insert = function(key, value) {
  return new mugs.RedBlackNode(mugs.RedBlack.RED, new mugs.RedBlackLeaf(mugs.RedBlack.BLACK), key, value, new mugs.RedBlackLeaf(mugs.RedBlack.BLACK));
};
mugs.RedBlackNode = function(color, left, key, value, right, comparator) {
  this.color = color;
  this.left = left;
  this.key = key;
  this.value = value;
  this.right = right;
  this.comparator = comparator ? void 0 : mugs.RedBlackNode.prototype.standard_comparator;
  return this;
};
/**
  The standard compare function. It's used if the user doesn't
  supply one when creating the tree
*/
mugs.RedBlackNode.prototype.standard_comparator = function(elem1, elem2) {
  if (elem1 < elem2) {
    return -1;
  } else if (elem1 > elem2) {
    return 1;
  } else {
    return 0;
  }
};
/**
  Given a key it finds the value, if any.
*/
mugs.RedBlackNode.prototype.get = function(key) {
  var comp;
  comp = this.comparator(key, this.key);
  if (comp < 0) {
    return this.left.get(key);
  } else if (comp > 0) {
    return this.right.get(key);
  } else {
    return new mugs.Some(this.value);
  }
};
/**
  Finds the smallest key in the tree
  Complexity of O ( log n )
*/
mugs.RedBlackNode.prototype.minKey = function() {
  if (this.left.isEmpty()) {
    return this.key;
  } else {
    return this.left.minKey();
  }
};
/**
  Finds the largest key in the tree
  Complexity of O ( log n )
*/
mugs.RedBlackNode.prototype.maxKey = function() {
  if (this.right.isEmpty()) {
    return this.key;
  } else {
    return this.right.maxKey();
  }
};
/**
  Checks if the given key exists in the tree
*/
mugs.RedBlackNode.prototype.containsKey = function(key) {
  var comp;
  comp = this.comparator(key, this.key);
  if (comp < 0) {
    return this.left.containsKey(key);
  } else if (comp > 0) {
    return this.right.containsKey(key);
  } else {
    return true;
  }
};
/**
  returns a sorted List with all of the keys stored in the tree
  @return {mugs.List} A sorted List with all of the key stored in the tree
*/
mugs.RedBlackNode.prototype.keys = function() {
  var elements;
  elements = [];
  this.inorderTraversal(function(kv) {
    return elements.push(kv.key);
  });
  return new mugs.List().buildFromArray(elements);
};
/**
  returns a sorted List with all of the values stored in the tree
  @return {mugs.List} A sorted List with all of the values stored in the tree
*/
mugs.RedBlackNode.prototype.values = function() {
  var elements;
  elements = [];
  this.inorderTraversal(function(kv) {
    return elements.push(kv.value);
  });
  return new mugs.List().buildFromArray(elements);
};
/**
  This will do an inorderTraversal of the tree applying the function 'f'
  on each key/value pair in the tree. This doesn't return anything and is only
  executed for the side-effects of f.

  @param {Function} f A function taking one arguments with properties key and value
*/
mugs.RedBlackNode.prototype.inorderTraversal = function(f) {
  var bigger, smaller;
  smaller = !this.left.isEmpty() ? this.left.inorderTraversal(f) : void 0;
  f({
    key: this.key,
    value: this.value
  });
  return bigger = !this.right.isEmpty() ? this.right.inorderTraversal(f) : void 0;
};
/**
  Returns a new tree with the inserted element.  If the Tree already contains that key
  the old value is replaced with the new value
*/
mugs.RedBlackNode.prototype.insert = function(key, value) {
  var t, that, __insert;
  that = this;
  __insert = function(tree) {
    var c, compare, k, l, r, v;
    c = tree.color, l = tree.left, k = tree.key, v = tree.value, r = tree.right;
    compare = that.comparator(key, k);
    if (tree.isEmpty()) {
      return new mugs.RedBlackNode(mugs.RedBlack.RED, new mugs.RedBlackLeaf(mugs.RedBlack.BLACK), key, value, new mugs.RedBlackLeaf(mugs.RedBlack.BLACK));
    } else if (compare < 0) {
      return that.balance(c, __insert(l), k, v, r);
    } else if (compare > 0) {
      return that.balance(c, l, k, v, __insert(r));
    } else {
      return new mugs.RedBlackNode(mugs.RedBlack.RED, tree.left, key, value, tree.right);
    }
  };
  t = __insert(that);
  return new mugs.RedBlackNode(mugs.RedBlack.BLACK, t.left, t.key, t.value, t.right);
};
/**
  Returns a new tree without the 'key'
  Port from this racket example: http://matt.might.net/articles/red-black-delete/
*/
mugs.RedBlackNode.prototype.remove = function(key) {
  var compare, __rm;
  __rm = __bind(function(tree) {
    var isExternalNode, isInternalNode, isNodeWithOneChildLeft, isNodeWithOneChildRight, max, newLeftTree, value;
    isExternalNode = function() {
      return tree.left.isEmpty() && tree.right.isEmpty();
    };
    isInternalNode = function() {
      return !tree.left.isEmpty() && !tree.right.isEmpty();
    };
    isNodeWithOneChildLeft = function() {
      return (tree.color === mugs.RedBlack.BLACK) && (tree.left.color === mugs.RedBlack.RED && tree.right.isEmpty());
    };
    isNodeWithOneChildRight = function() {
      return (tree.color === mugs.RedBlack.BLACK) && (tree.right.color === mugs.RedBlack.RED && tree.left.isEmpty());
    };
    if (tree.isEmpty()) {
      return tree;
    } else if (isExternalNode()) {
      if (tree.color === mugs.RedBlack.RED) {
        return new mugs.RedBlackLeaf(mugs.RedBlack.BLACK);
      } else if (tree.color === mugs.RedBlack.BLACK) {
        return new mugs.RedBlackLeaf(mugs.RedBlack.DOUBLE_BLACK);
      }
    } else if (isNodeWithOneChildLeft()) {
      return new mugs.RedBlackNode(mugs.RedBlack.BLACK, tree.left.left, tree.left.key, tree.left.value, tree.left.right);
    } else if (isNodeWithOneChildRight()) {
      return new mugs.RedBlackNode(mugs.RedBlack.BLACK, tree.right.left, tree.right.key, tree.right.value, tree.right.right);
    } else if (isInternalNode()) {
      max = tree.left.maxKey();
      value = tree.get(max).get;
      newLeftTree = tree.left.remove(max);
      return this.bubble(tree.color, newLeftTree, max, value, tree.right);
    } else {
      return new mugs.RedBlackNode(tree.color, tree.left, tree.key, tree.value, tree.right);
    }
  }, this);
  compare = this.comparator(key, this.key);
  if (compare < 0) {
    return new mugs.RedBlackNode(this.color, this.left.remove(key), this.key, this.value, this.right);
  } else if (compare > 0) {
    return new mugs.RedBlackNode(this.color, this.left, this.key, this.value, this.right.remove(key));
  } else {
    return __rm(this);
  }
};
/**
  The bubble procedure moves double-blacks from children to parents,
  or eliminates them entirely if possible.
  A black is subtracted from the children, and added to the parent:
*/
mugs.RedBlackNode.prototype.bubble = function(color, left, key, value, right) {
  if (left.color === mugs.RedBlack.DOUBLE_BLACK || right.color === mugs.RedBlack.DOUBLE_BLACK) {
    return this.balance(color.add(), new mugs.RedBlackNode(left.color.subtract(), left.left, left.key, left.value, left.right), key, value, new mugs.RedBlackNode(right.color.subtract(), right.left, right.key, right.value, right.right));
  } else {
    return new mugs.RedBlackNode(color, left, key, value, right);
  }
};
/**
  This function balances the tree by eliminating any black-red-red path in the tree.
  This situation can occur in any of four configurations:

  Reading the nodes from top to bottom:

  1. Black node followed by a red left node followed by a red left node
  2. Black node followed by a red left node followed by a red right node
  3. Black node followed by a red right node followed by a red right node
  4. Black node followed by a red right node followed by a red left node

  The solution is always the same: Rewrite the black-red-red path as a red node with
  two black children.

  However to support removal two additional colors have been addded to the mix:
  Negative-black and double black.

  The double black can occur instead of black in the four configurations above.
  The solution is then to convert it into a black node with two black children.

  Luckily the same code can handle both the black and double black cases by using a
  little trick: Each color has a `subtract` and an `add` method which returns another
  color (see each color object for more information). Instead of rewriting
  "the black/double black-red-red"" into a red node with two black children we just
  subtract the color of the root thus turning black into red and double-black into black.

  The negative black node can occur in the following two configurations:

  1. Double black followed by left negative black whith two black children
  2. Double black followed by right negative black with two black children

  The solution is to transform it into a node with two black children and a left (or right
  depending on the initial configuration) red node.
*/
mugs.RedBlackNode.prototype.balance = function(color, left, key, value, right) {
  var leftFollowedByLeft, leftFollowedByRight, leftIsNegativeBlack, rightFollowedByLeft, rightFollowedByRight, rightIsNegativeBlack;
  leftFollowedByLeft = function() {
    return (!left.isEmpty() && !left.left.isEmpty()) && (color === mugs.RedBlack.BLACK || color === mugs.RedBlack.DOUBLE_BLACK) && left.color === mugs.RedBlack.RED && left.left.color === mugs.RedBlack.RED;
  };
  leftFollowedByRight = function() {
    return (!left.isEmpty() && !left.right.isEmpty()) && (color === mugs.RedBlack.BLACK || color === mugs.RedBlack.DOUBLE_BLACK) && left.color === mugs.RedBlack.RED && left.right.color === mugs.RedBlack.RED;
  };
  rightFollowedByLeft = function() {
    return (!right.isEmpty() && !right.left.isEmpty()) && (color === mugs.RedBlack.BLACK || color === mugs.RedBlack.DOUBLE_BLACK) && right.color === mugs.RedBlack.RED && right.left.color === mugs.RedBlack.RED;
  };
  rightFollowedByRight = function() {
    return (!right.isEmpty() && !right.right.isEmpty()) && (color === mugs.RedBlack.BLACK || color === mugs.RedBlack.DOUBLE_BLACK) && right.color === mugs.RedBlack.RED && right.right.color === mugs.RedBlack.RED;
  };
  leftIsNegativeBlack = function() {
    return (!left.isEmpty()) && left.color === mugs.RedBlack.NEGATIVE_BLACK;
  };
  rightIsNegativeBlack = function() {
    return (!right.isEmpty()) && right.color === mugs.RedBlack.NEGATIVE_BLACK;
  };
  if (leftFollowedByLeft()) {
    return new mugs.RedBlackNode(color.subtract(), new mugs.RedBlackNode(mugs.RedBlack.BLACK, left.left.left, left.left.key, left.left.value, left.left.right), left.key, left.value, new mugs.RedBlackNode(mugs.RedBlack.BLACK, left.right, key, value, right));
  } else if (leftFollowedByRight()) {
    return new mugs.RedBlackNode(color.subtract(), new mugs.RedBlackNode(mugs.RedBlack.BLACK, left.left, left.key, left.value, left.right.left), left.right.key, left.right.value, new mugs.RedBlackNode(mugs.RedBlack.BLACK, right.right.right, key, value, right));
  } else if (rightFollowedByLeft()) {
    return new mugs.RedBlackNode(color.subtract(), new mugs.RedBlackNode(mugs.RedBlack.BLACK, left, key, value, right.left.left), right.left.key, right.left.value, new mugs.RedBlackNode(mugs.RedBlack.BLACK, right.left.right, right.key, right.value, right.right));
  } else if (rightFollowedByRight()) {
    return new mugs.RedBlackNode(color.subtract(), new mugs.RedBlackNode(mugs.RedBlack.BLACK, left, key, value, right.left), right.key, right.value, new mugs.RedBlackNode(mugs.RedBlack.BLACK, right.right.left, right.right.key, right.right.value, right.right.right));
  } else if (leftIsNegativeBlack()) {
    return new mugs.RedBlackNode(mugs.RedBlack.BLACK, new mugs.RedBlackNode(mugs.RedBlack.BLACK, this.balance(mugs.RedBlack.RED, left.left.left, left.left.key, left.left.value, left.left.right), left.key, left.value, left.right.left), left.right.key, left.right.value, new mugs.RedBlackNode(mugs.RedBlack.BLACK, right.left.right, key, value, right));
  } else if (rightIsNegativeBlack()) {
    return new mugs.RedBlackNode(mugs.RedBlack.BLACK, new mugs.RedBlackNode(mugs.RedBlack.BLACK, left, right.key, right.value, right.left.left), right.right.key, right.right.value, new mugs.RedBlackNode(mugs.RedBlack.BLACK, right.left.right, key, value, this.balance(mugs.RedBlack.RED, right.right.left, right.left.key, right.left.value, right.right.right)));
  } else {
    return new mugs.RedBlackNode(color, left, key, value, right);
  }
};
/**
  A node is never empty
*/
mugs.RedBlackNode.prototype.isEmpty = function() {
  return false;
};