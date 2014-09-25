//
//  PLKTabBarController.h
//  App
//
//  Created by Alvaro Talavera on 5/29/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLKTabBarControllerDelegate <NSObject>

- (void)tabBarControllerDidSelect;

@end


@interface PLKTabBarController : UIViewController <UITabBarDelegate>

@property (strong, nonatomic, readonly) NSArray *viewControllers;

@property (strong, nonatomic, readonly) UITabBar *tabBar;

- (void)setViewControllers:(NSArray *)controllers;

- (void)removeViewControllers;

@end

@interface UIViewController (PLKTabBarControllerItem)

@property(strong, nonatomic) PLKTabBarController *tabBarController;

@end
