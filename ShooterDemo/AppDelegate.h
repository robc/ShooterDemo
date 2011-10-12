//
//  AppDelegate.h
//  ShooterDemo
//
//  Created by Robert Caporetto on 8/10/11.
//  Copyright N/A 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
