$(document).ready(function() {
   
   module("range");
   
   test("to",function() {
       ok( equalsArr(mugs.range.to(0,10), [0,1,2,3,4,5,6,7,8,9,10] ));
   });
   
   test("until",function() {
      ok( equalsArr(mugs.range.until(0,10), [0,1,2,3,4,5,6,7,8,9] ));
   });
   
});