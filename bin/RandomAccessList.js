mugs.provide("mugs.RandomAccessList");
mugs.require("mugs.CompleteBinaryTreeNode");
mugs.require("mugs.List");
/**
  Random Access List

  Implementation of a Random Access List as described in the
  paper Purely Functional Random Access List by Chris Okasaki.

  <pre>
  --------------------------------------------------------
  Core operations of the Random Access List ADT
  --------------------------------------------------------
  prepend(item)                                   O(1)
  head()                                          O(1)
  tail()                                          O(1)
  get(item)                                       O(log n)
  update(index,item)                              O(log n)
  </pre>

  @author Mads Hartmann Jensen

  @class  Random Access List
  @param  items An array with the he items to add to the
                Random Access List
*/
mugs.RandomAccessList = function(items) {
  var item, ral, reversed, _i, _len, _ref;
  if ((items != null) && items.length > 0) {
    reversed = [];
    for (item = _ref = items.length - 1; (_ref <= 0 ? item <= 0 : item >= 0); (_ref <= 0 ? item += 1 : item -= 1)) {
      reversed.push(items[item]);
    }
    ral = this.buildFromList(new mugs.List());
    for (_i = 0, _len = reversed.length; _i < _len; _i++) {
      item = reversed[_i];
      ral = this.cons(item, ral);
    }
    return ral;
  } else {
    this.__trees = new mugs.List();
    return this;
  }
};
mugs.RandomAccessList.prototype = new mugs.Traversable();
/**
  Create a new list by prepending the item

  @param  item The item to be the new head
  @return A new list with the item as the head
*/
mugs.RandomAccessList.prototype.prepend = function(item) {
  return this.cons(item, this);
};
/**
  Returns the first item in the list
  @return The first item in the list
*/
mugs.RandomAccessList.prototype.head = function() {
  return this.__trees.head().get(0);
};
/**
  Returns the rest of the list
  @return The rest of the list
*/
mugs.RandomAccessList.prototype.tail = function() {
  var list, tree;
  tree = this.__trees.head();
  if (tree.isLeaf) {
    return this.buildFromList(this.__trees.tail());
  } else {
    list = this.__trees.tail().prepend(tree.right).prepend(tree.left);
    return this.buildFromList(list);
  }
};
/**
  Returns the number of items in the collection

  @return The number of items in the collection
*/
mugs.RandomAccessList.prototype.size = function() {
  var recSize;
  recSize = function(treeList) {
    if (treeList.isEmpty()) {
      return 0;
    } else {
      return treeList.head().size + recSize(treeList.tail());
    }
  };
  return recSize(this.__trees);
};
/**
  Gets the element at the given index

  @param  index  The index of the element to get
  @return        The element at location index
*/
mugs.RandomAccessList.prototype.get = function(index) {
  var recget;
  recget = function(treeList, index) {
    var tree;
    tree = treeList.head();
    if (index < tree.size) {
      return tree.get(index);
    } else {
      return recget(treeList.tail(), index - tree.size);
    }
  };
  return recget(this.__trees, index);
};
/**
  Creates a new RandomAccessList which is identical to this one
  except for the element at the given index which is replaced
  with item

  TODO: Can this be implemented w/o recursion?

  @param  index  The index of the item you want to replace
  @param  item   The item you want to replace with the existing one
  @return        A new RandomAccessList with the element at the given
                 index replaced with the item
*/
mugs.RandomAccessList.prototype.update = function(index, item) {
  var recUpdate;
  recUpdate = function(treeList, index) {
    var tree;
    tree = treeList.head();
    if (index < tree.size) {
      return treeList.tail().prepend(tree.update(index, item));
    } else {
      return recUpdate(treeList.tail(), index - tree.size).prepend(tree);
    }
  };
  return this.buildFromList(recUpdate(this.__trees, index));
};
/**
  Creates a Random Access List from an item and another Random
  Access List Trees.

  @private
  @param item The item to add to the front of the list
  @param ral  The Random Access List to prepend the item to
  @return     A new Random Access List with the new element as the head
*/
mugs.RandomAccessList.prototype.cons = function(item, ral) {
  var newList, size1, size2, trees;
  trees = ral.__trees;
  if (!trees.get(0).isEmpty() && !trees.get(1).isEmpty()) {
    size1 = trees.get(0).get().size;
    size2 = trees.get(1).get().size;
    if (size1 === size2) {
      newList = new mugs.List().cons(new mugs.CompleteBinaryTreeNode(item, trees.get(0).get(), trees.get(1).get()), trees.tail().tail());
      return this.buildFromList(newList);
    } else {
      newList = new mugs.List().cons(new mugs.CompleteBinaryTreeLeaf(item), trees);
      return this.buildFromList(newList);
    }
  } else {
    newList = new mugs.List().cons(new mugs.CompleteBinaryTreeLeaf(item), trees);
    return this.buildFromList(newList);
  }
};
/**
  Creates a new RandomAccessList without the item stored at given
  index

  @param index  The index of the element to remove
  @return       A new RandomAccessList without the item stored at given
                index
*/
/**
  Constructs a new RandomAccessList from a list of Complete Binary
  Trees. This is used internally.

  @private
*/
mugs.RandomAccessList.prototype.buildFromList = function(list) {
  var ral;
  ral = new mugs.RandomAccessList();
  ral.__trees = list;
  return ral;
};
/*
  Related to Traversable
*/
mugs.RandomAccessList.prototype.buildFromArray = function(items) {
  return new mugs.RandomAccessList(items);
};
mugs.RandomAccessList.prototype.forEach = function(f) {
  return this.__trees.forEach(function(tree) {
    return tree.preorderTraversal(f);
  });
};