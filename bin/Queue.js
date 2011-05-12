/**
  @fileoverview Contains the implementation of the Queue ADT based on two Lists as
                described in Chris Okasaki's book Purely Functional Data Structures. <br />

  @author Mads Hartmann Jensen (mads379@gmail.com)
*/mugs.provide("mugs.Queue");
mugs.require("mugs.List");
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
mugs.Queue = function(items) {
  var f, half, r, size;
  if (!(items != null) || items.length === 0) {
    this.front__ = new mugs.List();
    this.rear__ = new mugs.List();
  } else {
    size = items.length;
    half = Math.ceil(size / 2);
    f = items.slice(0, half);
    r = items.slice(half, size);
    this.front__ = new mugs.List(f);
    this.rear__ = new mugs.List(r).reverse();
  }
  return this;
};
mugs.Queue.prototype = new mugs.Traversable();
/**
  Removes the front element from the queue

  @return A new queue without the former front element
*/
mugs.Queue.prototype.dequeue = function() {
  return this.buildFromLists(this.front__.tail(), this.rear__);
};
/**
  Adds a new element to the queue

  @param elem The element to add to the queue
  @return A new queue with the element in the back of the queue
*/
mugs.Queue.prototype.enqueue = function(elem) {
  return this.buildFromLists(this.front__, this.rear__.prepend(elem));
};
/**
  Reads the front element in the queue

  @return The front element in the queue
*/
mugs.Queue.prototype.front = function() {
  return this.front__.head();
};
/**
  Returns a List with all of the elements in the queue.

  @return A List with all of the elements in the queue.
*/
mugs.Queue.prototype.values = function() {
  return this.front__.appendList(this.rear__.reverse());
};
/**
  Given two lists this will create a new queue. This is the method that makes sure the
  invariant "front is empty only if rear is empty" is kept.

  @param front The list that's going to be the front of the queue
  @param rear The list that's going to be the rear of the queue
  @private
*/
mugs.Queue.prototype.buildFromLists = function(front, rear) {
  var queue;
  queue = new mugs.Queue();
  if (front.isEmpty()) {
    queue.front__ = rear.reverse();
    queue.rear__ = front;
  } else {
    queue.rear__ = rear;
    queue.front__ = front;
  }
  return queue;
};
/*
# Methods that traversable requires
*/
mugs.Queue.prototype.forEach = function(f) {
  this.front__.forEach(f);
  return this.rear__.reverse().forEach(f);
};
mugs.Queue.prototype.buildFromArray = function(arr) {
  return new mugs.Queue(arr);
};