//
//  ZBMathUtilities.m
//  Phase_0_Input
//
//  Created by Rob Caporetto on 14/03/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import "ZBMathUtilities.h"
#import "cocos2d.h"

#define PI_ON_180           (M_PI / 180.0)
#define ARC4RANDOM_MAX      0x100000000

@implementation ZBMathUtilities

+ (CGFloat)calculateHeadingForVectorAtPoint:(CGPoint)start toEnd:(CGPoint)end;
{
    // See http://stackoverflow.com/questions/3441782/how-to-calculate-the-angle-of-a-vector-from-the-vertical/3442618#3442618
    // for how this breaks down.
    float angleRad = atan2f(end.x - start.x, end.y - start.y);
    float angleDeg = angleRad * (180 / M_PI);
    
    // At this stage, angleDeg is clamped between -180 & +180.
    // If it's negative, we add 360 to ensure it's a continuous circle.
    if (angleDeg < 0) angleDeg += 360;
    return angleDeg;
}

+ (CGFloat)calculateShortestRotationDegreeAngleFromStart:(CGFloat)start toEnd:(CGFloat)end;
{
    CGFloat shortestRadians = [ZBMathUtilities calculateShortestRotationRadianAngleFromStart:CC_DEGREES_TO_RADIANS(start)
                                                                                       toEnd:CC_DEGREES_TO_RADIANS(end)];
    return CC_RADIANS_TO_DEGREES(shortestRadians);
}

+ (CGFloat)calculateShortestRotationRadianAngleFromStart:(CGFloat)start toEnd:(CGFloat)end;
{
    // Math.atan2(Math.sin(targetrotation-originalrotation),Math.cos(targetrotation-originalrotation));
    
    // http://board.flashkit.com/board/showthread.php?t=766397 - Review THIS!
    
    return atan2f(sinf(end - start), cosf(end - start));
}

+ (CGFloat)randomNumberBetween:(CGFloat)minimum and:(CGFloat)maximum;
{
    // Taken from: http://iphonedevelopment.blogspot.com/2008/10/random-thoughts-rand-vs-arc4random.html
    CGFloat range = maximum - minimum;
    return (((CGFloat)arc4random() / ARC4RANDOM_MAX) * range) + minimum;
}

@end
