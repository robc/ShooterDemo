//
//  GameplayHUDLayer.m
//  ShooterDemo
//
//  Created by Robert Caporetto on 8/10/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import "GameplayHUDLayer.h"


@implementation GameplayHUDLayer
@synthesize scoreLabel=scoreLabel_;
@synthesize gameOverLabel=gameOverLabel_;

- (id)init
{
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        scoreLabel_ = [[CCLabelBMFont alloc] initWithString:@"000000" fntFile:@"Wendy-32.fnt"];
        [scoreLabel_ setAnchorPoint:CGPointZero];
        [scoreLabel_ setPosition:CGPointMake(0, winSize.height - [scoreLabel_ boundingBox].size.height)];
        [self addChild:scoreLabel_ z:200];
        
        gameOverLabel_ = [[CCLabelBMFont alloc] initWithString:@"GAME OVER" fntFile:@"Wendy-32.fnt"];
        [gameOverLabel_ setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
        [gameOverLabel_ setVisible:NO];
        [self addChild:gameOverLabel_ z:200];
    }
    
    return self;
}

- (void)dealloc
{
    [scoreLabel_ release];
    scoreLabel_ = nil;
    
    [gameOverLabel_ release];
    gameOverLabel_ = nil;
    
    [super dealloc];
}

@end
