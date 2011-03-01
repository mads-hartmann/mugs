$(document).ready(function(){
  
  module('Some');
  
  test("Test that you can wrap a value inside Some", function() {
    var some = new Some(42);
    ok(some.get() === 42);
  });
  
  test("Test that Some is not empty", function() {
    ok(!new Some(42).isEmpty());
  });
  
  test("Test that map on Some returns a Some with mapped value", function() {
    var some = new Some(21);
    ok(some.map( function(e){ return e*2; }).get() == 42);
  });
  
  test("Test that flatMap on Some returns mapped value", function() {
    var some = new Some(21);
    ok(some.flatMap( function(e){ return e*2; }) == 42);
  });
  
  test("Test that forEach on Some executes once with the contained value", function() {
    var sideEffectVariable = null; 
    new Some(42).foreach( function(e) { sideEffectVariable = e; });
    ok( sideEffectVariable === 42 );
  });
  
  test("Test that filter on Some returns Some if true", function() {
    var val = new Some(42).filter( function(e) { return e > 40; });
    ok( val.get() == 42);
  });
  
  test("Test that filter on Some returns None if false", function() {
    var val = new Some(42).filter( function(e) { return e < 40; });
    ok( val.isEmpty() );
  });
  
  test("Test that getOrElse on Some returns contained value", function() {
    ok( new Some(42).getOrElse(0) === 42);
  });
  
  module('None');
  
  test("Test that None is always empty", function() {
    ok( new None().isEmpty() );
  });
  
  test("Test that map on None returns None", function() {
    ok( new None().map( function(elem) { return elem+10; }).isEmpty() );
  });
  
  test("Test that flatMap on None returns None", function() {
    ok( new None().flatMap( function(elem) { return elem+10; }).isEmpty() );
  });
  
  test("Test that forEach on doesn't execute anything", function() {
    var sideEffectVariable = 42; 
    new None().foreach( function(e) { sideEffectVariable = "this shouldn't run"; });
    ok( sideEffectVariable === 42 );
  });
  
  test("Test that filter on None returns None", function() {
    ok( new None().filter(function(e) { return true; }).isEmpty() );
  });
  
  test("Test that getOrElse on None returns the fallback value", function() {
    ok( new None().getOrElse(42) == 42);
  });
  
});