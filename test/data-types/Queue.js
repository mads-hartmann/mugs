$(document).ready(function() {

    Queue = mugs.Queue;

    var implements_Queue = function(name, Queue){

        module(name);

        test("It's possible to create a queue with multiple elements",function() {
            var queue = new Queue([1,2,3,4,5]);
            ok(queue !== undefined);
        });

        test("It's possible to read the front element in the queue",function() {
            var queue = new Queue([1,2,3,4,5]);
            ok(queue.front() === 1);
        });

        test("It's possible to get a List with all of the elements in the Queue",function() {
            var queue = new Queue([1,2,3]),
            list = queue.values();

            ok(list.get(0).get() === 1);
            ok(list.get(1).get() === 2);
            ok(list.get(2).get() === 3);
        });

        test("It's possible to dequeue an element from the queue",function() {
            var queue = new Queue([1,2,3,4,5,6]).dequeue(),
            list = queue.values();

            ok(list.get(0).get() === 2);
            ok(list.get(5).isEmpty());
        });

        test("enqueueAll", function() {
            var queue = new Queue([1,2,3,4,5]).enqueueAll([6,7]);
            ok( equalsArr( queue.asArray(), [1,2,3,4,5,6,7]));
        });
    };

    implements_Queue("Queue", mugs.Queue);
});