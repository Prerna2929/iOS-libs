//
//  PLKTableViewCellSizeManager.m
//  App
//
//  Created by Alvaro Talavera on 6/25/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKTableViewCellSizeManager.h"

@implementation PLKTableViewCellSizeManager
{
    NSMutableDictionary *cells;
    NSMutableDictionary *cache;
}


- (id)initWithDelegate:(id<PLKTableViewCellSizeManagerDelegate>)delegate
{
    self = [super init];
    if(self) {
        self.delegate = delegate;
        
        cells = [[NSMutableDictionary alloc] init];
        cache = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)registerClass:(__unsafe_unretained Class)tclass forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCell *cell = [[tclass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    [cells setObject:cell forKey:reuseIdentifier];
}

- (void)reloadData
{
    [cache removeAllObjects];
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath andReuseIdentifier:(NSString *)reuseIdentifier
{
    NSValue *value = [cache objectForKey:indexPath];
    if(value) {
        return [value CGSizeValue];
    }
    
    UITableViewCell<PLKTableViewCellSizeManagerForCellDelegate> *cell = [self cellForReuseIdentifier:reuseIdentifier];
    if(cell) {
        // [cell prepareForReuse];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:contentForIndexPath:)]) {
            [self.delegate tableViewCell:cell contentForIndexPath:indexPath];
        }
        /*
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        */
        
        CGSize size = CGSizeZero;
        
        if([cell respondsToSelector:@selector(estimateCellSize)]) {
            size = [cell estimateCellSize];
        }
        
        
        [cache setObject:[NSValue valueWithCGSize:size] forKey:indexPath];
        return size;
    }
    
    return CGSizeZero;
}



- (UITableViewCell<PLKTableViewCellSizeManagerForCellDelegate> *)cellForReuseIdentifier:(NSString *)reuseIdentifier
{
    return [cells objectForKey:reuseIdentifier];
}

@end
