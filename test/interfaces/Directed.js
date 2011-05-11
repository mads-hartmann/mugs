/*
  Test the checks that a specific implementation conforms to the Directed interfaces 
*/

$(document).ready(function() {
   
   var implements_Directed = function(name, Constructor){
       
       module(name + " (Directed)");
       
       test("append",function() {
           var col = new Constructor([1,2,3]);
           ok( equalsArr(col.append(4).asArray() , [1,2,3,4]));
       });

       test("appendAll",function() {
           var col = new Constructor([1,2,3]);
           ok( equalsArr( col.appendAll([4,5]).asArray(), [1,2,3,4,5]));
       }); 

       test("prepend",function() {
           var col = new Constructor([1,2,3]);
           ok( equalsArr(col.prepend(4).asArray(), [4,1,2,3]));
       });

       test("prependAll",function() {
           var col = new Constructor([1,2,3]);
           ok( equalsArr(col.prependAll([4,5]).asArray(), [4,5,1,2,3]));
       });
       
       test("reverse",function() {
           var col = new Constructor([1,2,3]);
           ok( equalsArr( col.reverse().asArray(), [3,2,1] ));
       });
   };    
   
   implements_Directed("List",  mugs.List);
   implements_Directed("Stack", mugs.Stack);
   implements_Directed("Queue", mugs.Queue);
});