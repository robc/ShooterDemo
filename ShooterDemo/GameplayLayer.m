//
//  GameplayLayer.m
//  ShooterDemo
//
//  Created by Robert Caporetto on 8/10/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import "GameplayLayer.h"
#import "PlayerSprite.h"
#import "ZBMathUtilities.h"

#define kNumberOfPlayerBulletsInPool    15
#define kNumberOfEnemiesInPool          5
#define kBulletReloadTime               0.33
#define kPointsPerEnemy                 300

@interface GameplayLayer()
@property (nonatomic, assign, getter = isPlayerReadyToFire) BOOL playerReadyToFire;
@property (nonatomic, retain) CCSpriteBatchNode *spriteBatchNode;

- (void)movePlayerToPoint:(CGPoint)point;
- (void)testPlayerEnemyCollisions;
- (void)testActiveBulletEnemyCollisions;
- (void)spawnEnemy;
- (void)fireBullet;
- (void)handleGameOver;
@end


@implementation GameplayLayer
@synthesize delegate=delegate_;
@synthesize playerReadyToFire=playerReadyToFire_;
@synthesize spriteBatchNode=spriteBatchNode_;
@synthesize player=player_;
@synthesize playerBulletsArray=playerBulletsArray_;
@synthesize enemiesArray=enemiesArray_;

- (id)init
{
    self = [super init];
    if (self)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        hideNodeBlock = ^(CCNode *node) {
            CCSprite *sprite = (CCSprite *)node;
            sprite.visible = NO;
        };
        
        enumerateAndHideSprites = ^(id obj, NSUInteger idx, BOOL *stop) {
            CCSprite *sprite = (CCSprite *)obj;
            sprite.visible = NO;
        };
        
        // =====================================================================
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        spriteBatchNode_ = [[CCSpriteBatchNode alloc] initWithFile:@"Sprites.png" capacity:100];
        [self addChild:spriteBatchNode_];

        // =====================================================================
        
        CCSpriteFrameCache *sharedSpriteFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [sharedSpriteFrameCache addSpriteFramesWithFile:@"Sprites.plist"];
        
        // =====================================================================
        
        CCSpriteFrame *playerSpriteFrame = [sharedSpriteFrameCache spriteFrameByName:@"TripleEngineFighter.png"];
        player_ = [[PlayerSprite alloc] initWithSpriteFrame:playerSpriteFrame];
        [player_ setPosition:CGPointMake(winSize.width / 2, [player_ boundingBox].size.height / 2)];
        [player_ setMovementPerSecond:150.0];
        [spriteBatchNode_ addChild:player_ z:10];
        
        // =====================================================================
        
        playerBulletsArray_ = [[NSMutableArray alloc] init];
        CCSpriteFrame *bulletSpriteFrame = [sharedSpriteFrameCache spriteFrameByName:@"Bullet.png"];
        for (NSUInteger count = 0; count < kNumberOfPlayerBulletsInPool; count++)
        {
            CCSprite *bullet = [[CCSprite alloc] initWithSpriteFrame:bulletSpriteFrame];
            [bullet setVisible:NO];
            [bullet setScaleX:2];
            [bullet setScaleY:4];
            [bullet setPosition:CGPointMake(-winSize.width, -winSize.height)];
            [spriteBatchNode_ addChild:bullet z:9];
            [playerBulletsArray_ addObject:bullet];
            [bullet release];
        }
        
        // =====================================================================
        
        enemiesArray_ = [[NSMutableArray alloc] init];
        CCSpriteFrame *enemySpriteFrame = [sharedSpriteFrameCache spriteFrameByName:@"InterceptorEnemy.png"];
        for (NSUInteger count = 0; count < kNumberOfEnemiesInPool; count++)
        {
            CCSprite *enemy = [[CCSprite alloc] initWithSpriteFrame:enemySpriteFrame];
            [enemy setVisible:NO];
            [enemy setRotation:180];
            [enemy setPosition:CGPointMake(-winSize.width, -winSize.height)];
            [spriteBatchNode_ addChild:enemy z:11];
            [enemiesArray_ addObject:enemy];
            [enemy release];
        }
        
        [self setIsTouchEnabled:YES];
        [self setPlayerReadyToFire:YES];
        [self schedule:@selector(spawnEnemy) interval:2];
        [self schedule:@selector(testPlayerEnemyCollisions) interval:0.2];
        [self schedule:@selector(testActiveBulletEnemyCollisions) interval:0.2];
    }

    return self;
}

- (void)dealloc
{
    [self unscheduleAllSelectors];
    
    [spriteBatchNode_ release];
    [player_ release];
    [playerBulletsArray_ release];
    [enemiesArray_ release];

    [super dealloc];
}

- (void)testPlayerEnemyCollisions;
{
    [self.enemiesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CCSprite *sprite = (CCSprite *)obj;
        if (sprite.visible)
        {
            CGRect intersection = CGRectIntersection(sprite.boundingBox, self.player.boundingBox);
        
            // If we have a non-null rect, then there is an intersection, which means
            // GAME OVER MAN!
            if (!CGRectIsNull(intersection))
            {
                *stop = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleGameOver];
                });
            }
        }
    }];
}

- (void)testActiveBulletEnemyCollisions;
{
    // Ultimately this brute-force approach isn't the best solution for handling
    // this in a more complex game. Ideally, there would be some better storage
    // of the enemies here so that we only check the closest ones instead of all
    // of them.
    [self.playerBulletsArray enumerateObjectsUsingBlock:^(id bulletObj, NSUInteger bulletIdx, BOOL *bulletStop)
    {
        CCSprite *bullet = (CCSprite *)bulletObj;
        if (bullet.visible)
        {
            [self.enemiesArray enumerateObjectsUsingBlock:^(id enemyObj, NSUInteger enemyIdx, BOOL *enemyStop)
            {
                CCSprite *enemy = (CCSprite *)enemyObj;
                if (enemy.visible)
                {
                    CGRect intersection = CGRectIntersection(enemy.boundingBox, bullet.boundingBox);
                    if (!CGRectIsNull(intersection))
                    {
                        [bullet stopAllActions]; bullet.visible = NO; *bulletStop = YES;
                        [enemy stopAllActions]; enemy.visible = NO; *enemyStop = YES;

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate playSoundEffectWithFilename:@"Explosion.caf"];
                            [self.delegate addPointsToScore:kPointsPerEnemy];
                        });
                    }
                }
            }];
        }
    }];
}

- (void)spawnEnemy;
{
    [self unschedule:@selector(spawnEnemy)];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [self.enemiesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CCSprite *enemy = (CCSprite *)obj;
        if (!enemy.visible)
        {
            enemy.visible = YES;
            CGFloat enemyX = [ZBMathUtilities randomNumberBetween:enemy.boundingBox.size.width
                                                              and:(winSize.width - enemy.boundingBox.size.width)];

            enemy.position = CGPointMake(enemyX, winSize.height + enemy.boundingBox.size.height);
            
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:5 position:CGPointMake(enemyX, -enemy.boundingBox.size.height)];
            CCCallBlockN *postMoveCleanup = [CCCallBlockN actionWithBlock:hideNodeBlock];
            [enemy runAction:[CCSequence actions:moveTo, postMoveCleanup, nil]];
            
            *stop = YES;
        }
    }];

    // Ideally, we want to increase the spawn rate here.
    // As enemies are spawned, over time, we want to decreate the rate
    // so there's more difficulty there.
    [self schedule:@selector(spawnEnemy) interval:2];
}

- (void)handleGameOver;
{
    [self unscheduleAllSelectors];

    self.player.visible = NO;
    [self.playerBulletsArray enumerateObjectsUsingBlock:enumerateAndHideSprites];
    [self.enemiesArray enumerateObjectsUsingBlock:enumerateAndHideSprites];
    [self.delegate playSoundEffectWithFilename:@"Explosion.caf"];
    [self.delegate handleGameOver];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // If the player's not visible (which should be the case if it's GAME OVER)
    // then abort.
    if (!self.player.visible) return;

    // As we're not using multitouch for the moment, we can get away with
    // just grabbing any touch from the set.    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    // Check to see if we touched the player. If we did, then we want to fire
    // a bullet, otherwise we'll move the player to another position.
    if ([self.player touchAtPointIsOnPlayer:touchLocation] && self.isPlayerReadyToFire)
        [self fireBullet];
    else
    {
        // If we're just moving, then we need to calculate what the new position
        // of the player is, ensuring that they don't go beyond the bounds of the screen.
        CGSize winSize = [CCDirector sharedDirector].winSize;
        float playerHalfWidth = self.player.boundingBox.size.width / 2;
        float newx = fminf(fmaxf(playerHalfWidth, touchLocation.x), winSize.width - playerHalfWidth);
        [self movePlayerToPoint:CGPointMake(newx, self.player.position.y)];
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // As we're not using multitouch for the moment, we can get away with
    // just grabbing any touch from the set.    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

    // Unlike when starting a touch, we aren't going to check to see if we're
    // touching the player, so dragging your finger will allow you to just move,
    // but if you want to fire, you'll have to tap again.
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float playerHalfWidth = self.player.boundingBox.size.width / 2;
    float newx = fminf(fmaxf(playerHalfWidth, touchLocation.x), winSize.height - playerHalfWidth);
    [self movePlayerToPoint:CGPointMake(newx, self.player.position.y)];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.player stopAllActions];
}

- (void)movePlayerToPoint:(CGPoint)point;
{
    [self.player stopAllActions];
    
    // Determines how far the player has to move, and computes how long this
    // action needs to run for.
    CGFloat distanceToMove = ccpDistance(self.player.position, point);
    ccTime timeToMove = distanceToMove / self.player.movementPerSecond;
    [self.player runAction:[CCMoveTo actionWithDuration:timeToMove position:point]];
}

- (void)fireBullet
{
    __block NSUInteger bulletIndex = NSNotFound;
    [self.playerBulletsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CCSprite *sprite = (CCSprite *)obj;
        if (!sprite.visible) {
            bulletIndex = idx;
            *stop = YES;
        }
    }];
    
    if (bulletIndex != NSNotFound)
    {
        self.playerReadyToFire = NO;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *sprite = [self.playerBulletsArray objectAtIndex:bulletIndex];
        sprite.position = self.player.position;
        sprite.visible = YES;

        CCMoveTo *bulletTarget = [CCMoveTo actionWithDuration:3 position:CGPointMake(self.player.position.x, winSize.height * 1.25)];
        CCCallBlockN *bulletCompleteBlock = [CCCallBlockN actionWithBlock:hideNodeBlock];
        
        CCSequence *bulletSequence = [CCSequence actions:bulletTarget, bulletCompleteBlock, nil];
        [sprite runAction:bulletSequence];

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kBulletReloadTime * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.playerReadyToFire = YES;
        });
        
        [self.delegate playSoundEffectWithFilename:@"Blaster.caf"];
    }
}

@end
