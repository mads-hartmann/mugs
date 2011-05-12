/**
  @fileoverview Contains the implementation of the Stack data structure based on a List <br />

  @author Mads Hartmann Jensen (mads379@gmail.com)
*/var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
mugs.provide("mugs.Stack");
mugs.require("mugs.List");
/**
  Stack provides the implementation of the abstract data type Stack based on a List. The
  Stack contains the following operations:

  <pre>
  --------------------------------------------------------
  Core operations of the Stack ADT
  --------------------------------------------------------
  pop()                                               O(1)
  push( elem )                                        O(1)
  top()                                               O(1)
  --------------------------------------------------------
  </pre>

  @class Stack provides the implementation of the abstract data type Stack based on a List
  @param items An array of the items to construct the stack from. The last element will be
               at the bottom of the stack.
  @public
*/
mugs.Stack = function(items) {
  this.list = new mugs.List(items);
  return this;
};
mugs.Stack.prototype = new mugs.Indexed();
/**
  Removes the top element from the stack.

  @return A new stack without the former top element
  @complexity O(1)
*/
mugs.Stack.prototype.pop = function() {
  return this.buildFromList(this.list.tail());
};
/**
  Push an element on the stack

  @param elem the element to push on the stack
  @return A new stack with the new element on top
  @complexity O(1)
*/
mugs.Stack.prototype.push = function(elem) {
  return this.buildFromList(this.list.prepend(elem));
};
/**

*/
mugs.Stack.prototype.pushAll = function(items) {
  var item, newStack, _i, _len;
  newStack = this;
  for (_i = 0, _len = items.length; _i < _len; _i++) {
    item = items[_i];
    newStack = newStack.push(item);
  }
  return newStack;
};
/**
  Returns the top element of the stack.

  @return the top element.
  @complexity O(1)
*/
mugs.Stack.prototype.top = function() {
  return this.list.head();
};
/**
  Returns a List with all of the elements in the stack

  @return A list with all of the elements in the Stack
  @complexity O(1)
*/
mugs.Stack.prototype.values = function() {
  return this.list;
};
/**
  This will build a new Stack from a List. This is used internally.

  @complexity O(1)
  @private
*/
mugs.Stack.prototype.buildFromList = function(list) {
  var stack;
  stack = new mugs.Stack();
  stack.list = list;
  return stack;
};
/*
---------------------------------------------------------------------------------------------
Collection interface
---------------------------------------------------------------------------------------------
*/
/**
  Return true if the collection is empty, otherwise false

  @return True if the collection is empty, otherwise false
*/
mugs.Stack.prototype.isEmpty = function() {
  return this.list.isEmpty();
};
mugs.Stack.prototype.forEach = function(f) {
  return this.list.forEach(f);
};
mugs.Stack.prototype.buildFromArray = function(arr) {
  return new mugs.Stack(arr);
};
/*
---------------------------------------------------------------------------------------------
Extensible interface
---------------------------------------------------------------------------------------------
*/
/**
  Inserts the new item at the top of the Stack. This is equivalent to push(). This is needed so a
  Stack can be treated as an Extensible collection. runs in O(mugs.Stack.push)

  @param item The item to add to the top of the Stack
*/
mugs.Stack.prototype.insert = function(item) {
  return this.push(item);
};
/*
  Removes an item from the Stack. Runs in O(n).

  @param item The item to remove from the Stack.
*/
mugs.Stack.prototype.remove = function(item) {
  return this.buildFromList(this.list.remove(item));
};
/*
---------------------------------------------------------------------------------------------
Indexed interface
---------------------------------------------------------------------------------------------
*/
mugs.Stack.prototype.get = function(index) {
  return this.list.get(index);
};
mugs.Stack.prototype.update = function(index, item) {
  return this.buildFromList(this.list.update(index, item));
};
mugs.Stack.prototype.removeAt = function(index) {
  return this.buildFromList(this.list.removeAt(index));
};
/*
---------------------------------------------------------------------------------------------
Sequenced interface
---------------------------------------------------------------------------------------------
*/
/**
  Returns a mugs.Some with the last item in the collection if it's non-empty.
  otherwise, mugs.None

  @return a mugs.Some with the last item in the collection if it's non-empty.
          otherwise, mugs.None
*/
mugs.Stack.prototype.last = function() {
  return this.list.last();
};
/**
  Returns a mugs.Some with the first item in the collection if it's non-empty.
  otherwise, mugs.None

  @return a mugs.Some with the first item in the collection if it's non-empty.
          otherwise, mugs.None
*/
mugs.Stack.prototype.first = function() {
  return this.list.first();
};
/**
  Returns the remainder of the list after removing the top item

  @return The remainder of the list after removing the top item
  @complexity O(1)
*/
mugs.Stack.prototype.tail = function() {
  return this.buildFromList(this.list.tail());
};
/**
  Returns the first item in the collection. Throws an exception if the collection
  is empty.

  @return The first item in the collection. Throws an exception if the collection
          is empty.
*/
mugs.Stack.prototype.head = function() {
  return this.list.head();
};
/**

*/
mugs.Stack.prototype.foldLeft = function(seed) {
  return __bind(function(f) {
    return this.list.foldLeft(seed)(f);
  }, this);
};
mugs.Stack.prototype.foldRight = function(seed) {
  return __bind(function(f) {
    return this.list.foldRight(seed)(f);
  }, this);
};
/*
---------------------------------------------------------------------------------------------
Directed interface
---------------------------------------------------------------------------------------------
*/
/**
  Appends an item to the end (bottom) of the Stack.

  @return A new Stack with item at the bottom of the Stack
*/
mugs.Stack.prototype.append = function(item) {
  return this.buildFromList(this.list.append(item));
};
/**
  Creates a new Stack with the items appended

  @example
  new mugs.Stack([1,2,3]).appendAll([4,5,6]);
  // returns a Stack with the element 1,2,3,4,5,6
  @param  items An array with the items to append to this Stack.
  @return       A new Stack with the items appended
*/
mugs.Stack.prototype.appendAll = function(items) {
  return this.buildFromList(this.list.appendAll(items));
};
/**
  Prepends a new item to the top of the Stack. Equivalent to push().

  @return A new stack with the item on top
*/
mugs.Stack.prototype.prepend = function(item) {
  return this.push(item);
};
/**
  Creates a new Stack with all of the items prepended

  @return A new Stack with all of the items prepended
*/
mugs.Stack.prototype.prependAll = function(items) {
  return this.buildFromList(this.list.prependAll(items));
};
/**
  Returns a new Stack with the elements in reversed order

  @return A new Stack with the elements in reversed order
*/
mugs.Stack.prototype.reverse = function() {
  return this.buildFromList(this.list.reverse());
};