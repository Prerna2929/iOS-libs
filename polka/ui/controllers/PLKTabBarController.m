//
//  PLKTabBarController.m
//  App
//
//  Created by Alvaro Talavera on 5/29/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKTabBarController.h"
#import <objc/runtime.h>


#define _UITABBARHEIGHT 49.f

static void * TabBarControllerPropertyKey = &TabBarControllerPropertyKey;

@implementation UIViewController (PLKTabBarControllerItem)

- (PLKTabBarController *)tabBarController
{
    return objc_getAssociatedObject(self, TabBarControllerPropertyKey);
}

- (void)setTabBarController:(PLKTabBarController *)tabBarController
{
    objc_setAssociatedObject(self, TabBarControllerPropertyKey, tabBarController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation PLKTabBarController
{
    UIView *conteiner;
    UIViewController *current;
    NSMutableArray *items;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //[self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    current = nil;
}

- (void)removeViewControllers
{
    if(current != nil) {
        [current.view removeFromSuperview];
        current = nil;
    }
    
    [conteiner removeFromSuperview];
    conteiner = nil;
    
    [_tabBar setItems:nil];
    [_tabBar removeFromSuperview];
    _tabBar = nil;
    items = nil;
}

- (void)setViewControllers:(NSArray *)controllers
{
    _viewControllers = controllers;
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    
    _tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, rect.size.height - _UITABBARHEIGHT, 320, _UITABBARHEIGHT)];
    _tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [_tabBar setDelegate:self];
    
    conteiner = [[UIView alloc] initWithFrame:rect];
    conteiner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    
    items = [NSMutableArray arrayWithCapacity:_viewControllers.count];
    for (uint i=0; i<_viewControllers.count; i++) {
        UIViewController *controller = [_viewControllers objectAtIndex:i];
        [controller setAutomaticallyAdjustsScrollViewInsets:YES];
        
        [controller setTabBarController:self];
        [controller setPreferredContentSize:conteiner.frame.size];
        [controller.view setFrame:rect];

        
        // for navigation controller
        if(self.navigationController && [self.navigationController.navigationBar isTranslucent]) {
            if([PLKObjects classDescendsFromClass:[controller.view class] classB:[UIScrollView class]]) {
                UIEdgeInsets insets = [self insetsForView:controller];
                
                UIScrollView *scrollView = (UIScrollView *)controller.view;
                if([scrollView contentInset].top == 0) {
                    [scrollView setContentInset:insets];
                    [scrollView setScrollIndicatorInsets:insets];
                }
            }
        }
        
        // for tabbar
        if(self.navigationController && [self.navigationController.navigationBar isTranslucent]) {
            if([PLKObjects classDescendsFromClass:[controller.view class] classB:[UIScrollView class]]) {
                UIScrollView *scrollView = (UIScrollView *)controller.view;
                
                UIEdgeInsets insets = scrollView.contentInset;
                insets.bottom = _UITABBARHEIGHT;
                
                if([scrollView contentInset].bottom == 0) {
                    [scrollView setContentInset:insets];
                    [scrollView setScrollIndicatorInsets:insets];
                }
            }
        }
        
        controller.tabBarItem.tag = i;
        [items addObject:controller.tabBarItem];
    }
    
    [_tabBar setItems:items];
    
    [self.view addSubview:conteiner];
    [self.view addSubview:_tabBar];
    [self selectItemAtIndex:0];
}

- (void)selectItemAtIndex:(NSInteger)index
{
    UIViewController *next = [_viewControllers objectAtIndex:index];
    if(current == next) return;
    if(current != nil) {
        [current.view removeFromSuperview];
        current = nil;
    }
    
    current = next;
    
    if([[current class] conformsToProtocol:@protocol(PLKTabBarControllerDelegate)]) {
        if([current respondsToSelector:@selector(tabBarControllerDidSelect)]) {
            [current performSelector:@selector(tabBarControllerDidSelect) withObject:nil];
        }
    }
    
    
    [_tabBar setSelectedItem:[items objectAtIndex:index]];
    [conteiner addSubview:current.view];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [self selectItemAtIndex:item.tag];
}

- (UIEdgeInsets)insetsForView:(UIViewController *)controller
{
	UIViewController* viewController = self;
	
	//	Until root or a navigation controller
	if(![viewController isKindOfClass:[UINavigationController class]])
	{
		while(viewController.parentViewController != nil && ![viewController.parentViewController isKindOfClass:[UINavigationController class]])
			viewController = viewController.parentViewController;
	}
	
	const CGPoint convertedOrigin = [viewController.view convertPoint:controller.view.bounds.origin fromView:controller.view];
	
	const CGFloat topLayoutGuideLength = (([viewController respondsToSelector:@selector(topLayoutGuide)]) ? [viewController.topLayoutGuide length] : 0);
	
	const UIEdgeInsets rawInsets = UIEdgeInsetsMake(topLayoutGuideLength - convertedOrigin.y, 0, 0, 0);
	
	return UIEdgeInsetsMake(MAX(0, rawInsets.top) + ABS(MIN(0, self.view.frame.origin.y + convertedOrigin.y)),
							MAX(0, rawInsets.left),
							MAX(0, rawInsets.bottom),
							MAX(0, rawInsets.right));
}



@end
