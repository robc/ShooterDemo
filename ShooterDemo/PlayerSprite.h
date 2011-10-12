//
//  PlayerSprite.h
//  ShooterDemo
//
//  Created by Robert Caporetto on 8/10/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayerSprite : CCSprite {
}

@property (nonatomic, assign) float movementPerSecond;

- (BOOL)touchAtPointIsOnPlayer:(CGPoint)touchLocation;

@end
