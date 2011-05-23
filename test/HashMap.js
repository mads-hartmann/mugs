$(document).ready(function() {
    
    module("HashMap");
    
    var Person = function(name,age){
        this.name = name;
        this.age  = age;
        return this;
    };
    
    var people = [
        new Person("Mads",21),
        new Person("Eva",21)
    ];
    
    var kvs = [
        { "key" : people[0], "value" : "00000000" },
        { "key" : people[1],  "value" : "00000001" }
    ];
    
    var map = new mugs.HashMap(kvs);
    
    test("get",function() {
        ok(map.get(people[0]).get() === "00000000");
        ok(map.get(people[1]).get() === "00000001");
        ok(map.size() === 2);
    });
    
    
    
});