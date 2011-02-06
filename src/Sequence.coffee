###
  This class represents a basic sequence. This should be considered an abstract 
  class and has only been created for code re-use
###  

class Sequence 
  
  # TODO. This seems like a horrible solution to the circular 
  # require problem.
  Cons = undefined
  Nil  = undefined 
  
  requires = () -> 
    ListWrapper = require('./list')
    Cons        = ListWrapper.Cons
    Nil         = ListWrapper.Nil
    
  this.head 
  this.tail
  
  elements: () -> 
    __elements = (xs) ->
      if (xs.isEmpty())
        []
      else 
        [xs.head].concat(__elements(xs.tail))
    __elements(this)
  
  ###
    Applies a binary operator to a start value and all elements of this list, 
    going left to right
  ###
  foldLeft: (seed, f) -> 
    __foldLeft = (acc, xs) -> 
      if (xs.isEmpty()) 
        acc
      else 
        __foldLeft( f(acc, xs.head), xs.tail )
    __foldLeft(seed, this)

  ###
    DOESN'T WORK. 'this' is no longer bound to the 
    instance of sequence.
  ###
  foldLeftCurried: (seed) -> (f) -> 
    __foldLeft = (acc, xs) -> 
      if (xs.isEmpty())
        acc
      else 
        __foldLeft( f(acc, xs.head), xs.tail)
    __foldLeft(seed,this)

  ###
    Applies a binary operator to a start value and all elements of this list, 
    going right to left
  ###
  foldRight: (seed, f) ->
    __foldRight = (xs) -> 
      if (xs.isEmpty())
        seed
      else
        f( xs.head, __foldRight(xs.tail))
    __foldRight(this) 
  
  ###
    Creates a new list with all of the elements of 'this' list 
    followed by all of the elements of argument list.
  ###
  append: (list) -> 
    requires()
    __append = (xs) ->
      if (xs.isEmpty()) then list else new Cons(xs.head, __append(xs.tail, list))
    __append(this)

  ###
    Creates a new list with all of the argument list followed by all 
    of the elements of 'this' list.
  ###
  prepend: (list) -> 
    requires()
    if (list.isEmpty())
      this
    else 
      new Cons(list.head, this.append(list.tail))

exports.Sequence = () -> Sequence