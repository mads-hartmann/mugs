###*
  @fileoverview Contains the implementation of the Stack data structure based on a List <br />
  
  @author Mads Hartmann Jensen (mads379@gmail.com)
###
if require?
  List = require './list'


###*
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
###
Stack = (elements...) ->
  this.list = new List(elements).reverse()
  this

###*
  Removes the top element from the stack.
  
  @return A new stack without the former top element
  @complexity O(1)
###  
Stack.prototype.pop = () ->
  this.buildFromList(this.list.tail())

###*
  Push an element on the stack
  
  @param elem the element to push on the stack
  @return A new stack with the new element on top
  @complexity O(1)
###
Stack.prototype.push = (elem) -> 
  this.buildFromList(this.list.prepend(elem))

###*
  Returns the top element of the stack.
  
  @return the top element.
  @complexity O(1)
###
Stack.prototype.top = () -> 
  this.list.head()

###*
  Returns a List with all of the elements in the stack
  
  @return A list with all of the elements in the Stack 
  @complexity O(1)
###
Stack.prototype.values = () -> 
  this.list 
  
###*
  This will build a new Stack from a List. This is used internally. 
  
  @complexity O(1)
  @private
###
Stack.prototype.buildFromList = (list) -> 
  stack = new Stack()
  stack.list = list 
  stack 
  
if exports?
  exports.Stack = Stack