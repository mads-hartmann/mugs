$(document).ready(function() {
    
    var implements_OrderedSet = function(name, Constructor){
        
        module("OrderedSet ("+name+")");
        
        var Person = function(name,age){
            this.name = name;
            this.age  = age;
            return this;
        };
        
        var comp_func = function(obj1,obj2) {
            if (obj1.name < obj2.name) {
                return -1;
            } else if (obj1.name > obj2.name) {
                return 1;
            } else {
                return 0;
            }
        };
        
        var people = [
            new Person("Mads",21),
            new Person("Eva",21)
        ];
        
        var set = new Constructor(people, comp_func);
        
        test("get",function() {
            ok(set.get(0).get() === people[1]);
            ok(set.get(1).get() === people[0]);
            ok(set.size() === 2);
        });
        
    };
    
    implements_OrderedSet("TreeSet", mugs.TreeSet);
    implements_OrderedSet("LLRBSet", mugs.LLRBSet);
    
});