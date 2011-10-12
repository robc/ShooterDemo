//
//  TitleLayer.m
//  ShooterDemo
//
//  Created by Robert Caporetto on 12/10/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import "TitleLayer.h"
#import "BackgroundLayer.h"
#import "SimpleAudioEngine.h"
#import "GameplayScene.h"

@interface TitleLayer()
@property (nonatomic, retain) CCLabelBMFont *titleLabel;
@property (nonatomic, retain) CCMenu        *mainMenu;
@end

@implementation TitleLayer
@synthesize titleLabel=titleLabel_;
@synthesize mainMenu=mainMenu_;

+ (id)scene
{
    CCScene *scene = [CCScene node];
    
    BackgroundLayer *backgroundLayer = [[BackgroundLayer alloc] initWithSpriteFile:@"Stars.png"];
    [backgroundLayer setAnchorPoint:CGPointZero];
    [backgroundLayer setPosition:CGPointZero];
    [scene addChild:backgroundLayer];
    [backgroundLayer release];
    
    TitleLayer *titleLayer = [[TitleLayer alloc] init];
    [titleLayer setAnchorPoint:CGPointZero];
    [titleLayer setPosition:CGPointZero];
    [scene addChild:titleLayer];
    [titleLayer release];
    
    return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Start.caf"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        titleLabel_ = [[CCLabelBMFont alloc] initWithString:@"Space Shooter Game" fntFile:@"Wendy-32.fnt"];
        [titleLabel_ setPosition:CGPointMake((winSize.width / 2), (winSize.height * 0.7))];
        [self addChild:titleLabel_];

        CCLabelBMFont *startGameLabel = [CCLabelBMFont labelWithString:@"Start Game" fntFile:@"Wendy-32.fnt"];
        CCMenuItemLabel *startGameItem = [CCMenuItemLabel itemWithLabel:startGameLabel block:^(id sender) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"Start.caf"];
            [[CCDirector sharedDirector] replaceScene:[GameplayScene node]];
        }];
        
        mainMenu_ = [[CCMenu menuWithItems:startGameItem, nil] retain];
        [mainMenu_ alignItemsVertically];
        [mainMenu_ setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
        [self addChild:mainMenu_];
    }
    
    return self;
}

- (void)onExit
{
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"Start.caf"];
}

- (void)dealloc
{
    [titleLabel_ release];
    titleLabel_ = nil;
    
    [mainMenu_ release];
    mainMenu_ = nil;
    
    [super dealloc];
}

@end
