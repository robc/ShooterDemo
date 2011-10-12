//
//  GameplayLayer.h
//  ShooterDemo
//
//  Created by Robert Caporetto on 8/10/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameplayControllerDelegate.h"
#import "SimpleAudioEngine.h"

@class PlayerSprite;
@interface GameplayLayer : CCLayer {
    void (^hideNodeBlock)(CCNode *);
    void (^enumerateAndHideSprites)(id, NSUInteger, BOOL *);
}

@property (nonatomic, assign)   id<GameplayControllerDelegate> delegate;
@property (nonatomic, retain)   PlayerSprite    *player;
@property (nonatomic, retain)   NSMutableArray  *playerBulletsArray;
@property (nonatomic, retain)   NSMutableArray  *enemiesArray;

@end
