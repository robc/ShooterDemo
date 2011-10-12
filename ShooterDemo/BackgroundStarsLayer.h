//
//  BackgroundStarsLayer.h
//  Phase_0_Input
//
//  Created by Rob Caporetto on 24/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface BackgroundStarsLayer : CCLayer

- (id)initWithNodeToTrack:(CCNode *)node
    spriteTextureFilename:(NSString *)textureFilename
     spriteFramesFilename:(NSString *)framesFilename;

- (void)removeAllStarSprites;
- (void)addStarSpritesWithFrameName:(NSString *)frameName numberOfStars:(NSInteger)numberOfStars forwardSpeed:(CGFloat)speed;

@end
