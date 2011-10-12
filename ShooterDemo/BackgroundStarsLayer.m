//
//  BackgroundStarsLayer.m
//  Phase_0_Input
//
//  Created by Rob Caporetto on 24/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundStarsLayer.h"
#import "ZBMathUtilities.h"

#define kBackgroundStarsOffscreenMargin             30.0

@interface BackgroundStarsLayer()

@property (nonatomic, retain) CCNode                *trackedNode;
@property (nonatomic, assign) CGPoint               nodeLastPosition;
@property (nonatomic, assign) CGRect                layerBounds;
@property (nonatomic, assign) CGFloat               starForwardSpeed;

@property (nonatomic, retain) CCSpriteBatchNode     *spriteBatchNode;
@property (nonatomic, retain) CCSpriteFrameCache    *spriteFrameCache;

@end

// =================================

@implementation BackgroundStarsLayer
@synthesize trackedNode=trackedNode_;
@synthesize nodeLastPosition=nodeLastPosition_;
@synthesize spriteBatchNode=spriteBatchNode_;
@synthesize spriteFrameCache=spriteFrameCache_;
@synthesize layerBounds=layerBounds_;
@synthesize starForwardSpeed=starForwardSpeed_;

- (id)initWithNodeToTrack:(CCNode *)node
    spriteTextureFilename:(NSString *)textureFilename
     spriteFramesFilename:(NSString *)framesFilename;
{
    self = [super init];
    if (self) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        layerBounds_ = CGRectMake(-kBackgroundStarsOffscreenMargin, -kBackgroundStarsOffscreenMargin,
                                  screenSize.width + (2 * kBackgroundStarsOffscreenMargin),
                                  screenSize.height + (2 * kBackgroundStarsOffscreenMargin));
        
        trackedNode_ = [node retain];
        nodeLastPosition_ = [trackedNode_ position];

        spriteBatchNode_ = [[CCSpriteBatchNode alloc] initWithFile:textureFilename capacity:1000];
        [self addChild:spriteBatchNode_];

        spriteFrameCache_ = [[CCSpriteFrameCache sharedSpriteFrameCache] retain];
        [spriteFrameCache_ addSpriteFramesWithFile:framesFilename];

        // [self scheduleUpdate];
        [self schedule:@selector(update:) interval:(1/30)];
    }
    
    return self;
}

- (void)dealloc
{
    [self unscheduleUpdate];
    
    [trackedNode_ release];
    [spriteBatchNode_ release];
    [spriteFrameCache_ release];
    [super dealloc];
}

- (void)removeAllStarSprites;
{
    [self.spriteBatchNode removeAllChildrenWithCleanup:YES];
}

- (void)addStarSpritesWithFrameName:(NSString *)frameName numberOfStars:(NSInteger)numberOfStars forwardSpeed:(CGFloat)speed;
{
    self.starForwardSpeed = -speed;
    
    for (NSInteger count = 0; count < numberOfStars; count++)
    {
        CCSpriteFrame *spriteFrame = [self.spriteFrameCache spriteFrameByName:frameName];
        CCSprite *starSprite = [CCSprite spriteWithSpriteFrame:spriteFrame];

        CGFloat x = [ZBMathUtilities randomNumberBetween:CGRectGetMinX(self.layerBounds) and:CGRectGetMaxX(self.layerBounds)];
        CGFloat y = [ZBMathUtilities randomNumberBetween:CGRectGetMinY(self.layerBounds) and:CGRectGetMaxY(self.layerBounds)];
        starSprite.position = CGPointMake(x, y);

        [self.spriteBatchNode addChild:starSprite];
    }
}

- (void)update:(ccTime)delta
{
    // Calculate the player's movement & normalise it.
    CGPoint targetMovementDelta = ccpSub(self.trackedNode.position, self.nodeLastPosition);
    if (fabsf(targetMovementDelta.x) > 0.0001 && fabsf(targetMovementDelta.y) > 0.0001)
    {
        // Calculate a scaled amount based on that.
        CGPoint normalisedMovementDelta = ccpNormalize(targetMovementDelta);
        CGPoint scaledMovementDelta = ccpMult(normalisedMovementDelta, (self.starForwardSpeed * delta));
        
        for (CCSprite *sprite in self.spriteBatchNode.children)
        {
            CGPoint newSpritePosition = ccpAdd(sprite.position, scaledMovementDelta);
            
            if (fminf(sprite.position.x, CGRectGetMinX(self.layerBounds)) == sprite.position.x)
                newSpritePosition.x = CGRectGetMaxX(self.layerBounds) - kBackgroundStarsOffscreenMargin;
            else if (fmaxf(sprite.position.x, CGRectGetMaxX(self.layerBounds)) == sprite.position.x)
                newSpritePosition.x = CGRectGetMinX(self.layerBounds) + kBackgroundStarsOffscreenMargin;

            if (fminf(sprite.position.y, CGRectGetMinY(self.layerBounds)) == sprite.position.y)
                newSpritePosition.y = CGRectGetMaxY(self.layerBounds) - kBackgroundStarsOffscreenMargin;
            else if (fmaxf(sprite.position.y, CGRectGetMaxY(self.layerBounds)) == sprite.position.y)
                newSpritePosition.y = CGRectGetMinY(self.layerBounds) + kBackgroundStarsOffscreenMargin;

            
            sprite.position = newSpritePosition;
        }        
    }

    self.nodeLastPosition = self.trackedNode.position;
}

@end
