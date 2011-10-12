//
//  BackgroundLayer.m
//  Phase_0_Input
//
//  Created by Rob Caporetto on 4/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

- (id)initWithSpriteFile:(NSString *)spriteFileName;
{
    if ((self = [super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGRect repeatRect = CGRectMake(0, 0, size.width, size.height);

        sprite = [[CCSprite spriteWithFile:spriteFileName rect:repeatRect] retain];
		sprite.position = CGPointMake((size.width / 2), (size.height / 2));
        [self addChild:sprite];

        ccTexParams params = {
            GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT
        };
        [sprite.texture setTexParameters:&params];
    }
    
    return self;
}
 
- (void)dealloc 
{
    [sprite release];
    [super dealloc];
}

@end
