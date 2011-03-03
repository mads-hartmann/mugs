###*
  @fileoverview Contains the implementation of the List abstract data type.
  @author Mads Hartmann Jensen (mads379@gmail.com)
### 
if require?
  Option   = require './option'
  Some     = Option.Some
  None     = Option.None
  Traversable = (require './Traversable').Traversable

###*
  List provides the implementation of the abstract data type List based on a Singly-Linked list. The 
  list contains the following operations:
  
  <pre>
  --------------------------------------------------------
  Core operations of the List ADT 
  --------------------------------------------------------
  append( element )                                   O(n)
  prepend( element )                                  O(1)
  update( index, element )                            O(n)
  get( index )                                        O(n)
  remove( index )                                     O(n)
  --------------------------------------------------------
  Methods inherited from Traversable  
  --------------------------------------------------------
  map( f )                                            O(n)    
  flatMap( f )                                        O(n)    
  filter( f )                                         O(n)    
  forEach( f )                                        O(n)    
  foldLeft(s)(f)                                      O(n)    
  isEmpty()                                           O(1)    
  contains( element )                                 O(n)    TODO
  forAll( f )                                         O(n)    TODO
  take( x )                                           O(n)    TODO
  takeWhile( f )                                      O(n)    TODO
  size()                                              O(n)    TODO
  --------------------------------------------------------
  </pre>
  @class List provides the implementation of the abstract data type List based on a Singly-Linked list
  @public
###
List = (elements...) ->
  [x,xs...] = elements    
  if (x == undefined or (x instanceof Array and x.length == 0))
    return new Nil()
  if (x instanceof Array) 
    [hd, tl...] = x
    this.head = hd
    this.tail = new List(tl)
  else 
    this.head = x
    this.tail = new List(xs) 
  this

List.prototype = new mahj.Traversable() 

List.prototype.constructor = List

###
---------------------------------------------------------------------------------------------
Methods related to the List ADT
---------------------------------------------------------------------------------------------
###

###*
  Create a new list by appending this value
  @param {*} element The element to append to the List
  @return {List} A new list containing all the elements of the old with followed by the element 
###
List.prototype.append = (element) -> 
  this.cons(this.head, this.tail.append(element))
    
###*
  Create a new list by prepending this value
  @param {*} element The element to prepend to the List
  @return {List} A new list containing all the elements of the old list prepended with the element
###
List.prototype.prepend = (element) -> 
  this.cons(element,this)

###* 
  Update the value with the given index.
  @param {number} index The index of the element to update
  @param {*} element The element to replace with the current element 
  @return {List} A new list with the updated value.
###
List.prototype.update = (index, element) -> 
  if index < 0 
    throw new Error("Index out of bounds by #{index}")
  else if (index == 0)
    this.cons(element, this.tail)
  else 
    this.cons(this.head, this.tail.update(index-1,element))
  
###*
  Return an Option containing the nth element in the list.
  @param {number} index The index of the element to get
  @return {Some|None} Some(element) is it exists, otherwise None
###
List.prototype.get = (index) -> 
  if index < 0
    new None()
  else if (index == 0)
    new Some(this.head)
  else 
    this.tail.get(index-1)
  
###* 
  Removes the element at the given index. Runs in O(n) time.
  @param {number} index The index of the element to remove
  @return {List} A new list without the element at the given index
###  
List.prototype.remove = (index) -> 
  if index == 0  
    # can remove the following if/else with this.tail().getOrElse(new Nil) once 
    # tail and head are functions that return an option instead. 
    if !this.tail.isEmpty() 
      this.cons(this.tail.first().get(), this.tail.tail)
    else
      new Nil
  else 
    this.cons(this.head, this.tail.remove(index-1))
      
###* 
  The last element in the list  
  @return {Some|None} Some(last) if it exists, otherwise None
###
List.prototype.last = () -> if this.tail.isEmpty() then new Some(this.head) else this.tail.last()

###*
  The first element in the list
  @return {Some|None} Some(first) if it exists, otherwise None
###  
List.prototype.first = () -> new Some(this.head)

###*
  Creates a list by appending the argument list to 'this' list.

  @example 
  new List(1,2,3).appendList(new List(4,5,6)); 
  // returns a list with the element 1,2,3,4,5,6
  @param {List} list The list to append to this list.
  @return {List} A new list containing the elements of the appended List and the elements of the original List.
###
List.prototype.appendList = (list) -> 
  this.cons(this.head, this.tail.appendList(list))
    
###*
  Creates a new list by copying all of the items in the argument 'list'
  before of 'this' list

  @example 
  new List(4,5,6).prependList(new List(1,2,3)); 
  // returns a list with the element 1,2,3,4,5,6
  @param {List} list The list to prepend to this list.
  @return {List} A new list containing the elements of the prepended List and the elements of the original List.
###
List.prototype.prependList = (list) -> 
  if list.isEmpty() then this else this.cons(list.head, this.prependList(list.tail))

###
---------------------------------------------------------------------------------------------
Methods related to Traversable prototype 
---------------------------------------------------------------------------------------------
### 

List.prototype.buildFromArray = (arr) -> 
  new List(arr)

List.prototype.forEach = ( f ) -> 
  if !this.isEmpty()
    f(this.head) 
    this.tail.forEach(f)

###
---------------------------------------------------------------------------------------------
Miscellaneous Methods
---------------------------------------------------------------------------------------------
###
  
###*
  Helper method to construct a list from a value and another list 
  @private
###
List.prototype.cons = (head, tail) ->
  l = new List(head)
  l.tail = tail
  return l
  
###*
  Checks if the list is empty
  @return {boolean} true if container is empty, otherwise false. 
###
List.prototype.isEmpty = () -> false 
  
###* 
  Applies a binary operator on all elements of this list going left to right and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that 
  takes a function which will then be applied to the elements
  
  @example 
  new List(1,2,3,4,5).foldLeft(0)(function(acc,current){ acc+current })
  // returns 15 (the sum of the elements in the list)
  
  @param {*} seed The value to use when the list is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
###
List.prototype.foldLeft = (seed) -> (f) =>
  __foldLeft = (acc, xs) -> 
    if (xs.isEmpty())
      acc
    else 
      __foldLeft( f(acc, xs.head), xs.tail)
  __foldLeft(seed,this)

###
  Applies the function ‘f’ on each element in the collection and returns a new collection with the 
  values returned from applying the function ‘f’.
  
  @param {Function(*)} f The function to apply on each element
  @return A new list with the values of applying the function 'f' on each element
### 
# List.prototype.map = (f) -> 
#   that = this
#   this.foldRight(new Nil())( (acc, elem) -> that.cons( f(elem), acc ))

###* 
  Applies a binary operator on all elements of this list going right to left and ending with the
  seed value. This is a curried function that takes a seed value which returns a function that 
  takes a function which will then be applied to the elements.
  
  @example 
  new List(1,2,3,4,5).foldRight(0)(function(acc,current){ acc+current })
  // returns 15 (the sum of the elements in the list)
  
  @param {*} seed The value to use when the list is empty
  @return {function(function(*, *):*):*} A function which takes a binary function
###
List.prototype.foldRight = (seed) -> (f) =>
  __foldRight = (xs) -> 
    if (xs.isEmpty())
      seed
    else
      f(__foldRight(xs.tail), xs.head)
  __foldRight(this) 

Nil = () -> 
  this.head = throw new Error("Can't access head of an empty list")
  this.tail = throw new Error("Can't access tail of an empty list")
  this


Nil.prototype.constructor = Nil
Nil.prototype.isEmpty =     ()              -> true
Nil.prototype.append =      (element)       -> new List(element)
Nil.prototype.prepend =     (element)       -> new List(element)
Nil.prototype.appendList =  (list)          -> list
Nil.prototype.prependList = (list)          -> list
Nil.prototype.last =        ()              -> new None()
Nil.prototype.first =       ()              -> new None()
Nil.prototype.forEach =     (f)             -> # nothing
Nil.prototype.get =         (index)         -> new None()
Nil.prototype.remove =      (index)         -> new Nil()
Nil.prototype.map =         (f)             -> new Nil()
Nil.prototype.update =      (index,element) -> throw new Error("Index out of bounds by #{index}")

if exports?
  exports.List = List
  exports.Nil  = Nil