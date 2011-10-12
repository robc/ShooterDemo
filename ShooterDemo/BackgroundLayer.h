//
//  BackgroundLayer.h
//  Phase_0_Input
//
//  Created by Rob Caporetto on 4/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundLayer : CCLayer {
    CCSprite *sprite;
}

- (id)initWithSpriteFile:(NSString *)spriteFileName;

@end
