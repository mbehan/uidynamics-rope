MBRope
======

I've made rope simulations for games with Box2D before but I wanted to see if I could make a rope that could be used easily with UIKit elements, and without having to use Box2D directly. Below is the result, a highly practical user interface, I'm sure you'll agree!

![A UIButton dangling on the end of a swaying rope](https://iosapp.dev/static/img/rope.gif)

There are 2 distinct problems to consider when create a rope:

1. The physics joint that connects two elements together as though they were connected with a rope
2. Drawing the rope

Box2D has a bunch of different joints for connecting physics bodies and `b2RopeJoint` is just what you need to solve problem 1. UIDynamics though, only exposes 1 joint for us to join dynamic bodies through `UIAttachmentBehavior`. Fortunately the joint it appears to be using under the hood is `b2DistanceJoint` which, with the right amount of parameter fiddling, can be made into a `b2RopeJoint`.

So thats problem 1 sorted, right? Just draw the rope with the help of some [verlet integration](http://en.wikipedia.org/wiki/Verlet_integration) and you're done? Well I could be done, but I wanted to try something different and a bit more light weight, something that didn't involve wikipedia pages full of equations to understand fully. 

## More Chain Than Rope

By simply connecting a series of small views by their ends with `UIAttachmentBehavior` you get a chain, with enough links in that chain, and with the right attachment parameters you can get something that behaves pretty rope like. You can attach one view to another like so:

```objective-c
UIAttachmentBehavior *chainAttachment = [[UIAttachmentBehavior alloc] initWithItem:view1 attachedToItem:view2];
```

I just do this in a loop, joining together a whole bunch of views. It ends up looking like this not very ropey looking thing.

![Connected boxes make up the rope segments](https://iosapp.dev/static/img/rope-2.png)

But there's no reason why, just because we're using the views to create the rope like joint, that we have to look at the views. Instead I draw a path connecting their centres 

```objective-c
[path moveToPoint:[links[0] center]];
for(int i = 1; i < links.count; i++)
{
   [path addLineToPoint:[links[i]center]];
}
```

and we end up with what you see up top. 

### The Code

It still needs a bit of work but you can get a simple rope up and running with just a couple of lines of code. Import the header and do something like this:

```objective-c
MBRope *rope = [[MBRope alloc] initWithFrame:CGRectMake(350, 180, 5, 200) numSegments:15];
[self.view addSubview:rope];
[rope addRopeToAnimator:animator];
```

To attach something, like the button in the example, you can get the last view by calling `attachmentView` on the rope and attach your other view with your own `UIAttachmentBehavior`. The top of your rope will be fixed to the origin of the rect supplied when you init the rope, but it wouldn't take much to change it so you can attach your own stuff to both ends.
