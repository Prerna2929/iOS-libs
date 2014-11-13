//
//  PLKTableViewCellSizeManager.h
//  App
//
//  Created by Alvaro Talavera on 6/25/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLKObjects.h"

@protocol PLKTableViewCellSizeManagerDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell contentForIndexPath:(NSIndexPath *)indexPath;

@end

@protocol PLKTableViewCellSizeManagerForCellDelegate <NSObject>

- (CGSize)estimateCellSize;

@end


@interface PLKTableViewCellSizeManager : PLKObjects

@property (strong, nonatomic) id<PLKTableViewCellSizeManagerDelegate> delegate;

- (id) initWithDelegate:(id<PLKTableViewCellSizeManagerDelegate>)delegate;

- (void)registerClass:(__unsafe_unretained Class)tclass forCellReuseIdentifier:(NSString *)reuseIdentifier;

- (void)reloadData;

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath andReuseIdentifier:(NSString *)reuseIdentifier;

@end
