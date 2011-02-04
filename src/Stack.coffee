###
	Stack implementation
	
	@author Mads Hartmann Jensen
###

empty = []

equals = (stack1, stack2) ->
	x1    = head(stack1)
	x2    = head(stack2)
	return true if isEmpty(stack1) and isEmpty(stack2)
	return false if x1 != x2 
	equals( tail(stack1), tail(stack2)) if x1 == x2 
	
isEmpty = (stack) -> 
	if stack.length == 0 then true else false

cons = (x,xs) -> 
	[x].concat(xs)

head = (stack) -> 		
	[x, xs...] = stack
	x

tail = (stack) -> 		
	[x, xs...] = stack
	xs
	
exports.equals  = equals 
exports.isEmpty = isEmpty
exports.cons    = cons
exports.head    = head
exports.tail    = tail