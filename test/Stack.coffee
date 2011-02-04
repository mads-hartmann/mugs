Stack = require('../src/stack')

# isEmpty
ok Stack.isEmpty([1]) is false
ok Stack.isEmpty([]) is true

# equals
ok Stack.equals([1,2,3],[1,2,3]) is true
ok Stack.equals([1],[1,2,3]) is false

# cons
ok Stack.equals(Stack.cons(2, [1]) , [2,1] ) is true
ok Stack.equals(cons(2,cons(1,[])) , [2,1]) is true

# head
ok (Stack.head([2,1]) == 2) is true
ok (Stack.head([2,1]) == 1) is false
ok (Stack.head([]) == undefined) is true
ok (Stack.head([]) == 1) is false

#tail
ok Stack.equals( (Stack.tail([1,2])), [2] ) is true
ok Stack.equals( (Stack.tail([1,2])), [] ) is false