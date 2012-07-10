//
//  AppDelegate.h
//  nibswap
//
//  Created by Ethan Sherbondy on 7/9/12.
//  Copyright (c) 2012 MIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExampleViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    ExampleViewController *_viewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
