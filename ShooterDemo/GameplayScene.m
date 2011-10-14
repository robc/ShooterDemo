//
//  GameplayScene.m
//  ShooterDemo
//
//  Created by Robert Caporetto on 8/10/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import "GameplayScene.h"
#import "GameplayHUDLayer.h"
#import "GameplayLayer.h"
#import "BackgroundLayer.h"
#import "TitleLayer.h"

@interface GameplayScene()
@property (nonatomic, retain) SimpleAudioEngine     *simpleAudioEngine;
@property (nonatomic, assign) NSUInteger            score;
@property (nonatomic, retain) GameplayHUDLayer      *hudLayer;
@property (nonatomic, retain) GameplayLayer         *gameplayLayer;
@end

@implementation GameplayScene
@synthesize simpleAudioEngine=simpleAudioEngine_;
@synthesize score=score_;
@synthesize hudLayer=hudLayer_;
@synthesize gameplayLayer=gameplayLayer_;

- (id)init
{
    self = [super init];
    if (self)
    {
        BackgroundLayer *starsFixedBackground = [[BackgroundLayer alloc] initWithSpriteFile:@"Stars.png"];
        [self addChild:starsFixedBackground z:-255];
        [starsFixedBackground release];

        hudLayer_ = [[GameplayHUDLayer alloc] init];
        [hudLayer_ setPosition:CGPointZero];
        [self addChild:hudLayer_ z:200];

        gameplayLayer_ = [[GameplayLayer alloc] init];
        [gameplayLayer_ setPosition:CGPointZero];
        [gameplayLayer_ setDelegate:self];
        [self addChild:gameplayLayer_ z:100];
        
        score_ = 0;

        [CDSoundEngine setMixerSampleRate:44100];
        [[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
        simpleAudioEngine_ = [[SimpleAudioEngine sharedEngine] retain];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [simpleAudioEngine_ preloadEffect:@"Blaster.caf"];
            [simpleAudioEngine_ preloadEffect:@"Explosion.caf"];
        });
    }

    return self;
}

- (void)onExit
{
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"Blaster.caf"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"Explosion.caf"];
}

- (void)dealloc
{
    [hudLayer_ release];
    hudLayer_ = nil;
    
    [gameplayLayer_ release];
    gameplayLayer_ = nil;
    
    [simpleAudioEngine_ release];
    simpleAudioEngine_ = nil;
    
    [super dealloc];
}

#pragma mark - GameplayControllerDelegate methods
- (void)addPointsToScore:(NSUInteger)points;
{
    self.score += points;
    [self.hudLayer.scoreLabel setString:[NSString stringWithFormat:@"%06d", self.score]];
}

- (void)handleGameOver;
{
    self.hudLayer.gameOverLabel.visible = YES;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[CCDirector sharedDirector] replaceScene:[TitleLayer scene]];
    });
}

- (void)playSoundEffectWithFilename:(NSString *)filename;
{
    [self.simpleAudioEngine playEffect:filename];
}

@end
