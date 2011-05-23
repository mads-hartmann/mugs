$(document).ready(function() {
    
    var implements_OrderedMap = function(name, Constructor){
        
        module("OrderedMap ("+name+")");
        
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
        
        var kvs = [
            { "key" : people[0], "value" : "00000000" },
            { "key" : people[1],  "value" : "00000001" }
        ];
        
        var map = new Constructor(kvs, comp_func);
        
        test("get",function() {
            ok(map.get(people[0]).get() === "00000000");
            ok(map.get(people[1]).get() === "00000001");
            ok(map.size() === 2);
        });
        
    };
    
    implements_OrderedMap("TreeMap", mugs.TreeMap);
    implements_OrderedMap("LLRBMap", mugs.LLRBMap);
    
});