/**
  @fileoverview Contains the implementation of the Stack data structure based on a List <br />

  @author Mads Hartmann Jensen (mads379@gmail.com)
*/var List, Stack;
var __slice = Array.prototype.slice;
if (typeof require != "undefined" && require !== null) {
  List = require('./list');
}
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
  @param elements A repeatable argument with the elements you want on the Stack. The last
                  element will be on top of the stack.
  @public
*/
Stack = function() {
  var elements;
  elements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  this.list = new List(elements).reverse();
  return this;
};
/**
  Removes the top element from the stack.

  @return A new stack without the former top element
  @complexity O(1)
*/
Stack.prototype.pop = function() {
  return this.buildFromList(this.list.tail());
};
/**
  Push an element on the stack

  @param elem the element to push on the stack
  @return A new stack with the new element on top
  @complexity O(1)
*/
Stack.prototype.push = function(elem) {
  return this.buildFromList(this.list.prepend(elem));
};
/**
  Returns the top element of the stack.

  @return the top element.
  @complexity O(1)
*/
Stack.prototype.top = function() {
  return this.list.head();
};
/**
  Returns a List with all of the elements in the stack

  @return A list with all of the elements in the Stack
  @complexity O(1)
*/
Stack.prototype.values = function() {
  return this.list;
};
/**
  This will build a new Stack from a List. This is used internally.

  @complexity O(1)
  @private
*/
Stack.prototype.buildFromList = function(list) {
  var stack;
  stack = new Stack();
  stack.list = list;
  return stack;
};
if (typeof exports != "undefined" && exports !== null) {
  exports.Stack = Stack;
}