###
    _____             _    ____                       
   / ____|           | |  |  _ \                      
  | |      ___   ___ | |  | |_) | ___  __ _ _ __  ___ 
  | |     / _ \ / _ \| |  |  _ < / _ \/ _` | '_ \/ __|
  | |____| (_) | (_) | |  | |_) |  __/ (_| | | | \__ \
   \_____|\___/ \___/|_|  |____/ \___|\__,_|_| |_|___/
    
  List. 
  
  Mads Hartmann Jensen (mads379@gmail.com)
###

Sequence = require('./sequence').Sequence
Option   = require './option'
Some     = Option.Some
None     = Option.None

class List extends Sequence
  
  constructor: (elements...) ->
    if (elements.length == 0)
      return new Nil()
    else
      [x,xs...] = elements 
      return new Cons(x,xs)
      
  isEmpty: () -> 
    throw new Error("Not implemented in List")

class Cons extends List
      
  constructor: (hd, tl) ->
    this.head = hd      
    if (tl == undefined or (tl instanceof Array and tl.length == 0))
      this.tail = new Nil()
    else 
      if (tl instanceof Array)
        [x,xs...] = tl
        this.tail = new Cons(x,xs)
      else 
        this.tail = tl
      
  isEmpty: () -> false
  
class Nil extends List

  constructor: () -> 
    this.head = new None()
    this.tail = new None()

  isEmpty:     () -> true

exports.List = List
exports.Cons = Cons
exports.Nil  = Nil 
