//
//  PLKScrollViewPaginator.m
//  TableTest
//
//  Created by Alvaro Talavera on 4/30/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKScrollViewPaginator.h"

#define _LOADER_BOTTOM_INSET 50.f

@implementation PLKScrollViewPaginator
{
    BOOL isLoading;
    UIActivityIndicatorView *activityLoader;
}

- (id)initWithScrollView:(UIScrollView *)scrollView target:(id<PLKScrollViewPaginatorDelegate>)target
{
    self = [super init];
    if(self) {
        self.delegate       = target;
        self.scrollView     = scrollView;
        self.scrollFactor   = 80.0f;
        self.insetBottom    = 0.0f;
        self.enabled        = YES;
        
        isLoading           = NO;
        activityLoader      = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [activityLoader setHidesWhenStopped:YES];
        
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    float currOffsetY = self.scrollView.contentOffset.y;
    
    if(!enabled) {
        if((currOffsetY+(self.scrollView.bounds.size.height-self.insetBottom)) >= (self.scrollView.contentSize.height)) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, currOffsetY-_LOADER_BOTTOM_INSET)];
            }];
        }
        
    }
}

- (void)stopLoading
{
    float currOffsetY = self.scrollView.contentOffset.y;
    
    UIEdgeInsets scrollInsets = self.scrollView.contentInset;
    scrollInsets.bottom = self.insetBottom;
    // scrollInsets.bottom-=_LOADER_BOTTOM_INSET;
    
    [self.scrollView setContentInset:scrollInsets];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, currOffsetY)];
    
    [activityLoader stopAnimating];
    [activityLoader removeFromSuperview];
    
    isLoading = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if(!self.enabled) return;
    
    if ([keyPath isEqual:@"contentOffset"]) {
        CGFloat factor = self.scrollFactor;
        CGFloat offset = self.scrollView.contentOffset.y;
        CGFloat height = self.scrollView.contentSize.height;
        CGFloat screenHeight = self.scrollView.window.frame.size.height;
        
        if (height > screenHeight) {
            if ((offset + factor) > (height - screenHeight) && !isLoading) {
                isLoading = YES;
                
                UIEdgeInsets scrollInsets = self.scrollView.contentInset;
                scrollInsets.bottom = self.insetBottom + _LOADER_BOTTOM_INSET;
                [self.scrollView setContentInset:scrollInsets];
                
                CGRect frame = activityLoader.frame;
                frame.origin.x = (self.scrollView.frame.size.width / 2) - (frame.size.width / 2);
                frame.origin.y = self.scrollView.contentSize.height + 15;
                [activityLoader setFrame:frame];
                
                [self.scrollView addSubview:activityLoader];
                [activityLoader startAnimating];
                
                if([self.delegate respondsToSelector:@selector(scrollViewDidStartLoading:)])
                    [self.delegate performSelector:@selector(scrollViewDidStartLoading:) withObject:self.scrollView];
            }
        }
    }
}


@end
