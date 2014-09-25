//
//  PLKScrollViewPaginator.h
//  TableTest
//
//  Created by Alvaro Talavera on 4/30/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PLKScrollViewPaginatorDelegate <NSObject>

- (void)scrollViewDidStartLoading:(UIScrollView *)scrollView;

@end

@interface PLKScrollViewPaginator : NSObject

@property (strong, nonatomic) id<PLKScrollViewPaginatorDelegate> delegate;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) CGFloat scrollFactor;
@property (assign, nonatomic) CGFloat insetBottom;

@property (readonly, nonatomic) BOOL enabled;

- (id)initWithScrollView:(UIScrollView *)scrollView target:(id<PLKScrollViewPaginatorDelegate>)target;

- (void)setEnabled:(BOOL)enabled;

- (void)stopLoading;

@end
