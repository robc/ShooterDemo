//
//  PlayerSprite.m
//  ShooterDemo
//
//  Created by Robert Caporetto on 8/10/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import "PlayerSprite.h"

@implementation PlayerSprite
@synthesize movementPerSecond=movementPerSecond_;

- (id)init
{
    self = [super init];
    if (self) {
        movementPerSecond_ = 30;
    }
    
    return self;
}

- (void)dealloc
{
    [self stopAllActions];
    [self unscheduleAllSelectors];
    [super dealloc];
}

- (BOOL)touchAtPointIsOnPlayer:(CGPoint)touchLocation;
{
    return CGRectContainsPoint(self.boundingBox, touchLocation);
}

@end
