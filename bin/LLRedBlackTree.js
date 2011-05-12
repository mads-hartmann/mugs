/**
@author Mads Hartmann Jensen (2011, mads379@gmail.com)
*/mugs.provide("mugs.LLRBNode");
mugs.provide("mugs.LLRBLeaf");
mugs.require("mugs.List");
mugs.LLRBNode = (function() {
  /*
      Immutable implementation of Left Leaning Red Black Tree as
      described in this paper: http://www.cs.princeton.edu/~rs/talks/LLRB/LLRB.pdf

      Invariant 1: No red node has a red child
      Invariant 2: Every leaf path has the same number of black nodes
      Invariant 3: Only the left child can be red (left leaning)
    */
  /*
      Public interface
    */  var BLACK, F, RED, check, checkMaxDepth, colorFlip, containsKey, count, fixUp, get, inorderTraversal, insert, isRed, keys, min, moveRedLeft, moveRedRight, remove, removeMin, rotateLeft, rotateRight, standard_comparator, values, _;
  F = function(key, value, color, left, right) {
    this.key = key;
    this.value = value;
    this.color = color != null ? color : RED;
    this.left = left != null ? left : new mugs.None();
    this.right = right != null ? right : new mugs.None();
    this.comparator = standard_comparator;
    return this;
  };
  F.prototype.copy = function(key, value, color, left, right) {
    return new mugs.LLRBNode((key != null) && key !== _ ? key : this.key, (value != null) && value !== _ ? value : this.value, (color != null) && color !== _ ? color : this.color, (left != null) && left !== _ ? left : this.left, (right != null) && right !== _ ? right : this.right);
  };
  F.prototype.insert = function(key, item) {
    return insert(new mugs.Some(this), key, item).copy(_, _, BLACK, _, _);
  };
  F.prototype.remove = function(key) {
    return remove(new mugs.Some(this), key).get().copy(_, _, BLACK, _, _);
  };
  F.prototype.removeMinKey = function() {
    return removeMin(new mugs.Some(this)).get().copy(_, _, BLACK, _, _);
  };
  F.prototype.minKey = function() {
    return min(new mugs.Some(this)).get().key;
  };
  F.prototype.get = function(key) {
    return get(new mugs.Some(this), key);
  };
  F.prototype.count = function() {
    return count(new mugs.Some(this));
  };
  F.prototype.isEmpty = function() {
    return false;
  };
  F.prototype.containsKey = function(key) {
    return containsKey(new mugs.Some(this), key);
  };
  F.prototype.values = function() {
    return values(new mugs.Some(this));
  };
  F.prototype.keys = function() {
    return keys(new mugs.Some(this));
  };
  F.prototype.inorderTraversal = function(f) {
    return inorderTraversal(new mugs.Some(this), f);
  };
  /*
      Private : ADT Operations
    */
  get = function(optionNode, key) {
    var cmp;
    while (!optionNode.isEmpty()) {
      cmp = optionNode.get().comparator(key, optionNode.get().key);
      if (cmp === 0) {
        return new mugs.Some(optionNode.get().value);
      } else if (cmp < 0) {
        optionNode = optionNode.get().left;
      } else if (cmp > 0) {
        optionNode = optionNode.get().right;
      }
    }
    return new mugs.None();
  };
  containsKey = function(optionNode, key) {
    var cmp, found;
    found = false;
    while (!optionNode.isEmpty() && !found) {
      cmp = optionNode.get().comparator(key, optionNode.get().key);
      if (cmp === 0) {
        return true;
      } else if (cmp < 0) {
        optionNode = optionNode.get().left;
      } else if (cmp > 0) {
        optionNode = optionNode.get().right;
      }
    }
    return false;
  };
  min = function(optionNode) {
    var n;
    if (optionNode.isEmpty()) {
      return new mugs.None();
    }
    n = optionNode.get();
    if (n.left.isEmpty()) {
      return new mugs.Some(n);
    } else {
      return min(n.left);
    }
  };
  insert = function(optionNode, key, item) {
    var cmp, n;
    if (optionNode.isEmpty()) {
      return new mugs.LLRBNode(key, item);
    }
    n = optionNode.get();
    cmp = n.comparator(key, n.key);
    if (cmp < 0) {
      n = n.copy(_, _, _, new mugs.Some(insert(n.left, key, item)), _);
    } else if (cmp === 0) {
      n = n.copy(_, item, _, _, _);
    } else {
      n = n.copy(_, _, _, _, new mugs.Some(insert(n.right, key, item)));
    }
    return fixUp(n);
  };
  removeMin = function(optionNode) {
    var n;
    if (optionNode.isEmpty() || optionNode.get().left.isEmpty()) {
      return new mugs.None();
    }
    n = optionNode.get();
    if (!isRed(n.left) && !isRed(n.left.get().left)) {
      n = moveRedLeft(n);
    }
    n = n.copy(_, _, _, removeMin(n.left), _);
    return new mugs.Some(fixUp(n));
  };
  remove = function(optionNode, key) {
    var n, smallest;
    if (optionNode.isEmpty()) {
      return new mugs.None();
    }
    n = optionNode.get();
    if (n.comparator(key, n.key) < 0) {
      if (!n.left.isEmpty() && !isRed(n.left) && !isRed(n.left.get().left)) {
        n = moveRedLeft(n);
      }
      n = n.copy(_, _, _, remove(n.left, key), _);
    } else {
      if (isRed(n.left)) {
        n = rotateRight(n);
      }
      if (!n.right.isEmpty() && !isRed(n.right) && !isRed(n.right.get().left)) {
        n = moveRedRight(n);
      }
      if (n.comparator(key, n.key) === 0) {
        if (n.right.isEmpty()) {
          return new mugs.None();
        } else {
          smallest = min(n.right).get();
          n = n.copy(smallest.key, smallest.val, _, _, removeMin(n.right));
        }
      }
      n = n.copy(_, _, _, _, remove(n.right, key));
    }
    return new mugs.Some(fixUp(n));
  };
  /*
      Methods not directly related to the ADT but very handy
    */
  /*
    Returns the values in the tree in sorted order.
  */
  values = function(optionNode) {
    var arr;
    arr = [];
    inorderTraversal(optionNode, function(node) {
      return arr.push(node.value);
    });
    return new mugs.List().buildFromArray(arr);
  };
  /*
    Returns the keys in the tree in sorted order.
  */
  keys = function(optionNode) {
    var arr;
    arr = [];
    inorderTraversal(optionNode, function(node) {
      return arr.push(node.key);
    });
    return new mugs.List().buildFromArray(arr);
  };
  /*
      This will do an inorderTraversal of the tree applying the function 'f'
      on each key/value pair in the tree. This doesn't return anything and is only
      executed for the side-effects of f.
    */
  inorderTraversal = function(optionNode, f) {
    var that;
    if (!optionNode.isEmpty()) {
      that = optionNode.get();
      inorderTraversal(that.left, f);
      f({
        key: that.key,
        value: that.value
      });
      return inorderTraversal(that.right, f);
    }
  };
  /*
      Misc. other relevant functions
    */
  count = function(optionNode) {
    var n;
    if (optionNode.isEmpty()) {
      return 0;
    } else {
      n = optionNode.get();
      return count(n.left) + 1 + count(n.right);
    }
  };
  /*
      Private : Bunch of small helper functions (related to comforming to the invariants)
    */
  RED = true;
  BLACK = false;
  _ = {};
  isRed = function(optionNode) {
    return optionNode.map(function(n) {
      return n.color;
    }).getOrElse(false);
  };
  standard_comparator = function(elem1, elem2) {
    if (elem1 < elem2) {
      return -1;
    } else if (elem1 > elem2) {
      return 1;
    } else {
      return 0;
    }
  };
  fixUp = function(n) {
    if (isRed(n.right) && !isRed(n.left)) {
      n = rotateLeft(n);
    }
    if (isRed(n.left) && isRed(n.left.get().left)) {
      n = rotateRight(n);
    }
    if (isRed(n.left) && isRed(n.right)) {
      n = colorFlip(n);
    }
    return n;
  };
  moveRedLeft = function(node) {
    var n;
    n = colorFlip(node);
    if (isRed(n.right.get().left)) {
      n = n.copy(_, _, _, _, new mugs.Some(rotateRight(n.right.get())));
      n = rotateLeft(n);
      n = colorFlip(n);
    }
    return n;
  };
  moveRedRight = function(node) {
    var n;
    n = colorFlip(node);
    if (isRed(n.left.get().left)) {
      n = rotateRight(n);
      n = colorFlip(n);
    }
    return n;
  };
  rotateLeft = function(node) {
    var nl;
    nl = node.copy(_, _, RED, _, node.right.get().left);
    return node.right.get().copy(_, _, node.color, new mugs.Some(nl), _);
  };
  rotateRight = function(node) {
    var nr;
    nr = node.copy(_, _, RED, node.left.get().right, _);
    return node.left.get().copy(_, _, node.color, _, new mugs.Some(nr));
  };
  colorFlip = function(node) {
    var left, right;
    left = node.left.get().copy(_, _, !node.left.get().color, _, _);
    right = node.right.get().copy(_, _, !node.right.get().color, _, _);
    return node.copy(_, _, !node.color, new mugs.Some(left), new mugs.Some(right));
  };
  /*
      These methods are only for test purposes
    */
  checkMaxDepth = function(node) {
    var blackDepth;
    blackDepth = check(new mugs.Some(node));
    if (Math.pow(2.0, blackDepth) <= count(new mugs.Some(node)) + 1) {
      return true;
    } else {
      return false;
    }
  };
  check = function(optionNode) {
    var blackDepth, node;
    if (optionNode.isEmpty()) {
      return 0;
    } else {
      node = optionNode.get();
      if (isRed(optionNode) && isRed(optionNode.get().left)) {
        throw new Error("Red node has red child(" + node.key + "," + node.value + ")");
      }
      if (isRed(node.right)) {
        throw new Error("Right child of (" + node.key + "," + node.value + ") is red");
      }
      blackDepth = check(node.left);
      if (blackDepth !== check(node.right)) {
        throw new Error("Black depths differ");
      } else {
        return blackDepth + (isRed(optionNode) ? 0 : 1);
      }
    }
  };
  F.prototype.checkMaxDepth = function() {
    return checkMaxDepth(this);
  };
  F.prototype.rotateRight = function() {
    return rotateRight(this);
  };
  F.prototype.rotateLeft = function() {
    return rotateLeft(this);
  };
  return F;
})();
/**
   A Leaf Leaning Red Black Leaf. This isn't used in the implementation of LLRBNode
   but is only meant as a convenience prototype for handling the empty case of LLRBSet
   and LLRBMap.
*/
mugs.LLRBLeaf = function() {};
mugs.LLRBLeaf.prototype.insert = function(key, item) {
  return new mugs.LLRBNode(key, item);
};
mugs.LLRBLeaf.prototype.remove = function(key) {
  throw new Error("Can't remove an item from a leaf");
};
mugs.LLRBLeaf.prototype.removeMinKey = function() {
  return this;
};
mugs.LLRBLeaf.prototype.minKey = function() {
  throw new Error("Can't get the minimum key of a leaf");
};
mugs.LLRBLeaf.prototype.get = function(key) {
  return new mugs.None();
};
mugs.LLRBLeaf.prototype.count = function() {
  return 0;
};
mugs.LLRBLeaf.prototype.isEmpty = function() {
  return true;
};
mugs.LLRBLeaf.prototype.containsKey = function(key) {
  return false;
};
mugs.LLRBLeaf.prototype.values = function() {
  return new mugs.List();
};
mugs.LLRBLeaf.prototype.inorderTraversal = function(f) {};