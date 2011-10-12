//
//  ZBMathUtilities.h
//  Phase_0_Input
//
//  Created by Rob Caporetto on 14/03/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZBMathUtilities : NSObject {
}

+ (CGFloat)calculateHeadingForVectorAtPoint:(CGPoint)start toEnd:(CGPoint)end;

+ (CGFloat)calculateShortestRotationDegreeAngleFromStart:(CGFloat)start toEnd:(CGFloat)end;
+ (CGFloat)calculateShortestRotationRadianAngleFromStart:(CGFloat)start toEnd:(CGFloat)end;

+ (CGFloat)randomNumberBetween:(CGFloat)minimum and:(CGFloat)maximum;
@end
