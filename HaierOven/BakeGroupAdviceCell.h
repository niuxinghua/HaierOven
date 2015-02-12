//
//  BakeGroupAdviceCell.h
//  HaierOven
//
//  Created by dongl on 15/1/8.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cooker.h"
#import "Friend.h"

@class BakeGroupAdviceCell;
@protocol BackGroupAdviceCellDelegate <NSObject>

-(void)bakeGroupAdviceCell:(BakeGroupAdviceCell*)cell followed:(UIButton*)sender;

@end
@interface BakeGroupAdviceCell : UITableViewCell
@property (weak, nonatomic)id<BackGroupAdviceCellDelegate>delegate;

/**
 *  推荐用户
 */
@property (strong, nonatomic) Cooker* cooker;

@property (strong, nonatomic) Friend* searchedUser;

@end
