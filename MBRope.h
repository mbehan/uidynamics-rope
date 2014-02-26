//
//  MBRope.h
//  LightingTest
//
//  Created by Michael Behan on 25/02/2014.
//  Copyright (c) 2014 Michael Behan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBRope : UIView

- (id)initWithFrame:(CGRect)frame numSegments:(int)numSegments;
- (void)addRopeToAnimator:(UIDynamicAnimator *)animator;
-(UIView *)attachmentView;

@end
