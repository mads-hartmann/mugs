/**
  @fileoverview Contains the implementation of the Queue ADT based on two Lists as
                described in Chris Okasaki's book Purely Functional Data Structures. <br />

  @author Mads Hartmann Jensen (mads379@gmail.com)
*/var List, Queue;
var __slice = Array.prototype.slice;
if (typeof require != "undefined" && require !== null) {
  List = require('./list');
}
/**
  Queue provides the implementation of the abstract data type Queue based on two Lists as
  described in Chris Okasaki's book Purely Functional Data Structures. The Queue contains
  the following operations:

  <pre>
  --------------------------------------------------------
  Core operations of the Queue ADT
  --------------------------------------------------------
  enqueue()                               (amortized) O(1)
  dequeue(elem)                                       O(1)
  top()                                               O(1)
  --------------------------------------------------------
  </pre>

  @class Queue provides an implementation of the Queue ADT based on two Lists.
  @public
*/
Queue = function() {
  var elements, f, half, r, size;
  elements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  size = elements.length;
  half = Math.ceil(size / 2);
  f = elements.slice(0, half);
  r = elements.slice(half, size);
  this.front__ = new List(f);
  this.rear__ = new List(r).reverse();
  return this;
};
/**
  Removes the front element from the queue

  @return A new queue without the former front element
*/
Queue.prototype.dequeue = function() {
  return this.buildFromLists(this.front__.tail(), this.rear__);
};
/**
  Adds a new element to the queue

  @param elem The element to add to the queue
  @return A new queue with the element in the back of the queue
*/
Queue.prototype.enqueue = function(elem) {
  return this.buildFromLists(this.front__, this.rear__.prepend(elem));
};
/**
  Reads the front element in the queue

  @return The front element in the queue
*/
Queue.prototype.front = function() {
  return this.front__.head();
};
/**
  Returns a List with all of the elements in the queue.

  @return A List with all of the elements in the queue.
*/
Queue.prototype.values = function() {
  return this.front__.appendList(this.rear__.reverse());
};
/**
  Given two lists this will create a new queue. This is the method that makes sure the
  invariant "front is empty only if rear is empty" is kept.

  @param front The list that's going to be the front of the queue
  @param rear The list that's going to be the rear of the queue
  @private
*/
Queue.prototype.buildFromLists = function(front, rear) {
  var queue;
  queue = new Queue();
  if (front.isEmpty()) {
    queue.front__ = rear.reverse();
    queue.rear__ = front;
  } else {
    queue.rear__ = rear;
    queue.front__ = front;
  }
  return queue;
};