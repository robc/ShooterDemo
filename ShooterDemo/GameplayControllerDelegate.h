//
//  GameplayControllerDelegate.h
//  ShooterDemo
//
//  Created by Robert Caporetto on 9/10/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameplayControllerDelegate <NSObject>
@required
- (void)addPointsToScore:(NSUInteger)points;
- (void)handleGameOver;
- (void)playSoundEffectWithFilename:(NSString *)filename;
@end
