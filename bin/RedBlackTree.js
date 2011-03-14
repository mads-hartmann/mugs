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
*/var BLACK, DOUBLE_BLACK, List, NEGATIVE_BLACK, None, Option, RED, RedBlackLeaf, RedBlackNode, Some;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof require != "undefined" && require !== null) {
  Option = require('./option');
  Some = Option.Some;
  None = Option.None;
  List = require('./list').List;
}
RED = {
  color: "RED",
  add: function() {
    return BLACK;
  },
  subtract: function() {
    return NEGATIVE_BLACK;
  }
};
BLACK = {
  color: "BLACK",
  add: function() {
    return DOUBLE_BLACK;
  },
  subtract: function() {
    return RED;
  }
};
DOUBLE_BLACK = {
  color: "DOUBLE BLACK",
  add: function() {
    return DOUBLE_BLACK;
  },
  subtract: function() {
    return BLACK;
  }
};
NEGATIVE_BLACK = {
  color: "NEGATIVE BLACK",
  add: function() {
    return RED;
  },
  subtract: function() {
    return NEGATIVE_BLACK;
  }
};
RedBlackLeaf = function(color) {
  this.color = color;
  this.left = new None();
  this.right = new None();
  this.key = new None();
  this.value = new None();
  return this;
};
RedBlackLeaf.prototype.isEmpty = function() {
  return true;
};
RedBlackLeaf.prototype.containsKey = function(key) {
  return false;
};
RedBlackLeaf.prototype.get = function(key) {
  return new None();
};
RedBlackLeaf.prototype.keys = function() {
  return new List();
};
RedBlackLeaf.prototype.values = function() {
  return new List();
};
RedBlackLeaf.prototype.inorderTraversal = function(f) {};
RedBlackLeaf.prototype.insert = function(key, value) {
  return new RedBlackNode(RED, new RedBlackLeaf(BLACK), key, value, new RedBlackLeaf(BLACK));
};
RedBlackNode = function(color, left, key, value, right, comparator) {
  this.color = color;
  this.left = left;
  this.key = key;
  this.value = value;
  this.right = right;
  this.comparator = comparator ? void 0 : RedBlackNode.prototype.standard_comparator;
  return this;
};
/**
  The standard compare function. It's used if the user doesn't
  supply one when creating the tree
*/
RedBlackNode.prototype.standard_comparator = function(elem1, elem2) {
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
RedBlackNode.prototype.get = function(key) {
  var comp;
  comp = this.comparator(key, this.key);
  if (comp < 0) {
    return this.left.get(key);
  } else if (comp > 0) {
    return this.right.get(key);
  } else {
    return new Some(this.value);
  }
};
/**
  Finds the smallest key in the tree
  Complexity of O ( log n )
*/
RedBlackNode.prototype.minKey = function() {
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
RedBlackNode.prototype.maxKey = function() {
  if (this.right.isEmpty()) {
    return this.key;
  } else {
    return this.right.maxKey();
  }
};
/**
  Checks if the given key exists in the tree
*/
RedBlackNode.prototype.containsKey = function(key) {
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
  @return {List} A sorted List with all of the key stored in the tree
*/
RedBlackNode.prototype.keys = function() {
  var elements;
  elements = [];
  this.inorderTraversal(function(kv) {
    return elements.push(kv.key);
  });
  return new List().buildFromArray(elements);
};
/**
  returns a sorted List with all of the values stored in the tree
  @return {List} A sorted List with all of the values stored in the tree
*/
RedBlackNode.prototype.values = function() {
  var elements;
  elements = [];
  this.inorderTraversal(function(kv) {
    return elements.push(kv.value);
  });
  return new List().buildFromArray(elements);
};
/**
  This will do an inorderTraversal of the tree applying the function 'f'
  on each key/value pair in the tree. This doesn't return anything and is only
  executed for the side-effects of f.

  @param {Function} f A function taking one arguments with properties key and value
*/
RedBlackNode.prototype.inorderTraversal = function(f) {
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
RedBlackNode.prototype.insert = function(key, value) {
  var t, that, __insert;
  that = this;
  __insert = function(tree) {
    var c, compare, k, l, r, v;
    c = tree.color, l = tree.left, k = tree.key, v = tree.value, r = tree.right;
    compare = that.comparator(key, k);
    if (tree.isEmpty()) {
      return new RedBlackNode(RED, new RedBlackLeaf(BLACK), key, value, new RedBlackLeaf(BLACK));
    } else if (compare < 0) {
      return that.balance(c, __insert(l), k, v, r);
    } else if (compare > 0) {
      return that.balance(c, l, k, v, __insert(r));
    } else {
      return new RedBlackNode(RED, tree.left, key, value, tree.right);
    }
  };
  t = __insert(that);
  return new RedBlackNode(BLACK, t.left, t.key, t.value, t.right);
};
/**
  Returns a new tree without the 'key'
  Port from this racket example: http://matt.might.net/articles/red-black-delete/
*/
RedBlackNode.prototype.remove = function(key) {
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
      return (tree.color === BLACK) && (tree.left.color === RED && tree.right.isEmpty());
    };
    isNodeWithOneChildRight = function() {
      return (tree.color === BLACK) && (tree.right.color === RED && tree.left.isEmpty());
    };
    if (tree.isEmpty()) {
      return tree;
    } else if (isExternalNode()) {
      if (tree.color === RED) {
        return new RedBlackLeaf(BLACK);
      } else if (tree.color === BLACK) {
        return new RedBlackLeaf(DOUBLE_BLACK);
      }
    } else if (isNodeWithOneChildLeft()) {
      return new RedBlackNode(BLACK, tree.left.left, tree.left.key, tree.left.value, tree.left.right);
    } else if (isNodeWithOneChildRight()) {
      return new RedBlackNode(BLACK, tree.right.left, tree.right.key, tree.right.value, tree.right.right);
    } else if (isInternalNode()) {
      max = tree.left.maxKey();
      value = tree.get(max).get;
      newLeftTree = tree.left.remove(max);
      return this.bubble(tree.color, newLeftTree, max, value, tree.right);
    } else {
      return new RedBlackNode(tree.color, tree.left, tree.key, tree.value, tree.right);
    }
  }, this);
  compare = this.comparator(key, this.key);
  if (compare < 0) {
    return new RedBlackNode(this.color, this.left.remove(key), this.key, this.value, this.right);
  } else if (compare > 0) {
    return new RedBlackNode(this.color, this.left, this.key, this.value, this.right.remove(key));
  } else {
    return __rm(this);
  }
};
/**
  The bubble procedure moves double-blacks from children to parents,
  or eliminates them entirely if possible.
  A black is subtracted from the children, and added to the parent:
*/
RedBlackNode.prototype.bubble = function(color, left, key, value, right) {
  if (left.color === DOUBLE_BLACK || right.color === DOUBLE_BLACK) {
    return this.balance(color.add(), new RedBlackNode(left.color.subtract(), left.left, left.key, left.value, left.right), key, value, new RedBlackNode(right.color.subtract(), right.left, right.key, right.value, right.right));
  } else {
    return new RedBlackNode(color, left, key, value, right);
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
RedBlackNode.prototype.balance = function(color, left, key, value, right) {
  var leftFollowedByLeft, leftFollowedByRight, leftIsNegativeBlack, rightFollowedByLeft, rightFollowedByRight, rightIsNegativeBlack;
  leftFollowedByLeft = function() {
    return (!left.isEmpty() && !left.left.isEmpty()) && (color === BLACK || color === DOUBLE_BLACK) && left.color === RED && left.left.color === RED;
  };
  leftFollowedByRight = function() {
    return (!left.isEmpty() && !left.right.isEmpty()) && (color === BLACK || color === DOUBLE_BLACK) && left.color === RED && left.right.color === RED;
  };
  rightFollowedByLeft = function() {
    return (!right.isEmpty() && !right.left.isEmpty()) && (color === BLACK || color === DOUBLE_BLACK) && right.color === RED && right.left.color === RED;
  };
  rightFollowedByRight = function() {
    return (!right.isEmpty() && !right.right.isEmpty()) && (color === BLACK || color === DOUBLE_BLACK) && right.color === RED && right.right.color === RED;
  };
  leftIsNegativeBlack = function() {
    return (!left.isEmpty()) && left.color === NEGATIVE_BLACK;
  };
  rightIsNegativeBlack = function() {
    return (!right.isEmpty()) && right.color === NEGATIVE_BLACK;
  };
  if (leftFollowedByLeft()) {
    return new RedBlackNode(color.subtract(), new RedBlackNode(BLACK, left.left.left, left.left.key, left.left.value, left.left.right), left.key, left.value, new RedBlackNode(BLACK, left.right, key, value, right));
  } else if (leftFollowedByRight()) {
    return new RedBlackNode(color.subtract(), new RedBlackNode(BLACK, left.left, left.key, left.value, left.right.left), left.right.key, left.right.value, new RedBlackNode(BLACK, right.right.right, key, value, right));
  } else if (rightFollowedByLeft()) {
    return new RedBlackNode(color.subtract(), new RedBlackNode(BLACK, left, key, value, right.left.left), right.left.key, right.left.value, new RedBlackNode(BLACK, right.left.right, right.key, right.value, right.right));
  } else if (rightFollowedByRight()) {
    return new RedBlackNode(color.subtract(), new RedBlackNode(BLACK, left, key, value, right.left), right.key, right.value, new RedBlackNode(BLACK, right.right.left, right.right.key, right.right.value, right.right.right));
  } else if (leftIsNegativeBlack()) {
    return new RedBlackNode(BLACK, new RedBlackNode(BLACK, this.balance(RED, left.left.left, left.left.key, left.left.value, left.left.right), left.key, left.value, left.right.left), left.right.key, left.right.value, new RedBlackNode(BLACK, right.left.right, key, value, right));
  } else if (rightIsNegativeBlack()) {
    return new RedBlackNode(BLACK, new RedBlackNode(BLACK, left, right.key, right.value, right.left.left), right.right.key, right.right.value, new RedBlackNode(BLACK, right.left.right, key, value, this.balance(RED, right.right.left, right.left.key, right.left.value, right.right.right)));
  } else {
    return new RedBlackNode(color, left, key, value, right);
  }
};
/**
  A node is never empty
*/
RedBlackNode.prototype.isEmpty = function() {
  return false;
};
if (typeof exports != "undefined" && exports !== null) {
  exports.Leaf = RedBlackLeaf;
  exports.RedBlackNode = RedBlackNode;
  exports.RED = RED;
  exports.BLACK = BLACK;
}