###*
@fileoverview Contains the implementation of the List data structure.
@author Mads Hartmann Jensen (mads379@gmail.com)
### 
if require?
  Option   = require './option'
  Some     = Option.Some
  None     = Option.None

###*
  @class List
###
class List 
  
  this.head
  this.tail 
  
  # Helper method to construct a list from a value and another list 
  cons = (head, tail) ->
    l = new List(head)
    l.tail = tail
    return l
  
  # Creates a List from multiple values.
  # 
  # Example: New List(1,2,3,4,5,6)
  constructor: (elements...) ->
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
      
  isEmpty: () -> false 

  # Update the value with index 'index'. This will copy all values up to the
  # given index. 
  update: (index, element) -> 
    if index < 0 
      throw new Error("Index out of bounds by #{index}")
    else if (index == 0)
      cons(element, this.tail)
    else 
      cons(this.head, this.tail.update(index-1,element))
  
  # Return an Option containt the nth element in the list. Some(element) if it
  # exists. Otherwise None
  get: (index) -> 
    if index < 0
      new None()
    else if (index == 0)
      new Some(this.head)
    else 
      this.tail.get(index-1)
  
  # Returns an Option containing the last element in the list  
  last: () -> if this.tail.isEmpty() then new Some(this.head) else this.tail.last()

  # Returns an Option containing the first element in the list
  first: () -> new Some(this.head)

  # Create a new list by appending this value
  append:  (element) -> 
    cons(this.head, this.tail.append(element))
    
  # Create a new list by prepending this value
  prepend: (element) -> 
    cons(element,this)

  # Creates a list by appending the argument list to 'this' list.
  #
  # Consider two lists. A is the argument passed to the method append
  # of list T. R is the resulting list. x2 is a copy of x1 etc.
  # 
  # A: a -> b -> c -> Nil  
  # T: x -> y -> z -> Nil   
  # R: x2 -> y2 -> z2 -> A  
  #
  # Thus all of the elements of A are reused.
  appendList: (list) -> 
    cons(this.head, this.tail.appendList(list))
    
  # Creates a new list by copying all of the items in the argument 'list'
  # before of 'this' list
  #
  # Consider two lists. A is the argument passed to the method prepend
  # of list T. R is the resulting list. a2 is a copy of a1 etc.
  #
  # A: a -> b -> c -> Nil       
  # T: x -> y -> z -> Nil   
  # R: a2 -> b2 -> c3 -> T   
  #
  # Thus all of the elements of T are reused
  prependList: (list) -> 
    if list.isEmpty() then this else cons(list.head, this.prependList(list.tail))
  
  # Applies a binary operator to a start value and all elements of this list, 
  # going left to right
  foldLeft: (seed) -> (f) =>
    __foldLeft = (acc, xs) -> 
      if (xs.isEmpty())
        acc
      else 
        __foldLeft( f(acc, xs.head), xs.tail)
    __foldLeft(seed,this)

  # Applies a binary operator to a start value and all elements of this list, 
  # going right to left
  foldRight: (seed) -> (f) =>
    __foldRight = (xs) -> 
      if (xs.isEmpty())
        seed
      else
        f( xs.head, __foldRight(xs.tail))
    __foldRight(this) 

###*
  @class Represents an empty list
###      
class Nil 

  constructor: () -> 
    this.head = new None()
    this.tail = new None()

  isEmpty:     ()              -> true
  append:      (element)       -> new List(element)
  prepend:     (element)       -> new List(element)
  appendList:  (list)          -> list
  prependList: (list)          -> list
  last:        ()              -> new None()
  first:       ()              -> new None()
  get:         (index)         -> new None()
  update:      (index,element) -> throw new Error("Index out of bounds by #{index}")

if exports?
  exports.List = List
  exports.Nil  = Nil 