//
//  MBRope.m
//  LightingTest
//
//  Created by Michael Behan on 25/02/2014.
//  Copyright (c) 2014 Michael Behan. All rights reserved.
//

#import "MBRope.h"

@interface MBRope()
{
    NSMutableArray *links;
    float segmentLength;
    NSTimer *test;
    CGRect originalFrame;
    float ropeWidth;
}

@end

@implementation MBRope

- (id)initWithFrame:(CGRect)frame numSegments:(int)numSegments
{
    self = [super initWithFrame:CGRectMake(0, 0, 768, 1024)];
    //self = [super initWithFrame:frame];
    if (self)
    {
        originalFrame = frame;
        ropeWidth = originalFrame.size.width;
        links = [[NSMutableArray alloc] initWithCapacity:numSegments];

        segmentLength = frame.size.height / (numSegments * 1.0);
        
        for(int i = 0; i < numSegments; i++)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originalFrame.origin.x, originalFrame.origin.y + (i * segmentLength), 10, segmentLength)];
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
            
            [links addObject:view];
        }
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)addRopeToAnimator:(UIDynamicAnimator *)animator
{
    for(int i = 0; i < [links count]; i++)
    {
        UIAttachmentBehavior *attachment;
        if(i == 0)
        {
            attachment = [[UIAttachmentBehavior alloc] initWithItem:links[i] attachedToAnchor:[links[0] center]];
        }
        else
        {
            attachment = [[UIAttachmentBehavior alloc] initWithItem:links[i] offsetFromCenter:UIOffsetMake(0, -(segmentLength / 2.0)) attachedToItem:links[i-1] offsetFromCenter:UIOffsetMake(0, segmentLength / 2.0)];
        }
        
        [attachment setLength:0];
        [attachment setDamping:INT_MAX];
        [attachment setFrequency:INT_MAX];
        
        [animator addBehavior:attachment];
    }
    
    [self performSelector:@selector(updateRope) withObject:nil afterDelay:1/60.0];
}

-(void)updateRope
{
    [self setNeedsDisplay];
    [self performSelector:@selector(updateRope) withObject:nil afterDelay:1/60.0];
}

-(UIView *)attachmentView
{
    return [links lastObject];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = ropeWidth;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    [path moveToPoint:[links[0] center]];
    
    for(int i = 1; i < links.count; i++)
    {
        [path addLineToPoint:[links[i]center]];
    }
    
    [[UIColor redColor] setStroke];
    [path stroke];
}


@end
