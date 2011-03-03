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
*/var BLACK, Cons, DOUBLE_BLACK, List, NEGATIVE_BLACK, Nil, None, Option, RED, RedBlackLeaf, RedBlackNode, Some;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof require != "undefined" && require !== null) {
  Option = require('./option');
  Some = Option.Some;
  None = Option.None;
  List = require('./list').List;
  Cons = require('./list').Cons;
  Nil = require('./list').Nil;
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
RedBlackLeaf = (function() {
  function RedBlackLeaf(color) {
    this.color = color;
    this.left = new None();
    this.right = new None();
    this.key = new None();
    this.value = new None();
  }
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
    return new Nil();
  };
  RedBlackLeaf.prototype.values = function() {
    return new Nil();
  };
  RedBlackLeaf.prototype.inorderMap = function(func) {
    return new Nil();
  };
  return RedBlackLeaf;
})();
RedBlackNode = (function() {
  var balance, bubble, standard_comparator;
  standard_comparator = function(elem1, elem2) {
    if (elem1 < elem2) {
      return -1;
    } else if (elem1 > elem2) {
      return 1;
    } else {
      return 0;
    }
  };
  RedBlackNode.color;
  RedBlackNode.left;
  RedBlackNode.key;
  RedBlackNode.value;
  RedBlackNode.right;
  RedBlackNode.comparator;
  function RedBlackNode(color, left, key, value, right, comparator) {
    this.color = color;
    this.left = left;
    this.key = key;
    this.value = value;
    this.right = right;
    this.comparator = comparator ? void 0 : standard_comparator;
  }
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
  RedBlackNode.prototype.minKey = function() {
    if (this.left.isEmpty()) {
      return this.key;
    } else {
      return this.left.minKey();
    }
  };
  RedBlackNode.prototype.maxKey = function() {
    if (this.right.isEmpty()) {
      return this.key;
    } else {
      return this.right.maxKey();
    }
  };
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
  RedBlackNode.prototype.keys = function() {
    return this.inorderMap(function(key, value) {
      return key;
    });
  };
  RedBlackNode.prototype.values = function() {
    return this.inorderMap(function(key, value) {
      return value;
    });
  };
  RedBlackNode.prototype.inorderMap = function(f) {
    var bigger, smaller, that;
    smaller = !this.left.isEmpty() ? this.left.inorderMap(f) : new Nil();
    bigger = !this.right.isEmpty() ? this.right.inorderMap(f) : new Nil();
    that = new List(f(this.key, this.value));
    return smaller.append(that).append(bigger);
  };
  RedBlackNode.prototype.insert = function(key, value) {
    var t, __insert;
    __insert = __bind(function(tree) {
      var c, compare, k, l, r, v;
      c = tree.color, l = tree.left, k = tree.key, v = tree.value, r = tree.right;
      compare = this.comparator(key, k);
      if (tree.isEmpty()) {
        return new RedBlackNode(RED, new RedBlackLeaf(BLACK), key, value, new RedBlackLeaf(BLACK));
      } else if (compare < 0) {
        return balance(c, __insert(l), k, v, r);
      } else if (compare > 0) {
        return balance(c, l, k, v, __insert(r));
      } else {
        return tree;
      }
    }, this);
    t = __insert(this);
    return new RedBlackNode(BLACK, t.left, t.key, t.value, t.right);
  };
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
        return bubble(tree.color, newLeftTree, max, value, tree.right);
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
  bubble = function(color, left, key, value, right) {
    if (left.color === DOUBLE_BLACK || right.color === DOUBLE_BLACK) {
      return balance(color.add(), new RedBlackNode(left.color.subtract(), left.left, left.key, left.value, left.right), key, value, new RedBlackNode(right.color.subtract(), right.left, right.key, right.value, right.right));
    } else {
      return new RedBlackNode(color, left, key, value, right);
    }
  };
  balance = function(color, left, key, value, right) {
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
      return new RedBlackNode(BLACK, new RedBlackNode(BLACK, balance(RED, left.left.left, left.left.key, left.left.value, left.left.right), left.key, left.value, left.right.left), left.right.key, left.right.value, new RedBlackNode(BLACK, right.left.right, key, value, right));
    } else if (rightIsNegativeBlack()) {
      return new RedBlackNode(BLACK, new RedBlackNode(BLACK, left, right.key, right.value, right.left.left), right.right.key, right.right.value, new RedBlackNode(BLACK, right.left.right, key, value, balance(RED, right.right.left, right.left.key, right.left.value, right.right.right)));
    } else {
      return new RedBlackNode(color, left, key, value, right);
    }
  };
  RedBlackNode.prototype.isEmpty = function() {
    return false;
  };
  return RedBlackNode;
})();
if (typeof exports != "undefined" && exports !== null) {
  exports.Leaf = RedBlackLeaf;
  exports.RedBlackNode = RedBlackNode;
  exports.RED = RED;
  exports.BLACK = BLACK;
}