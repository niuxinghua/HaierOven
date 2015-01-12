//
//  BakeGroupAdviceCell.h
//  HaierOven
//
//  Created by dongl on 15/1/8.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cooker.h"
@class BakeGroupAdviceCell;
@protocol BackGroupAdviceCellDelegate <NSObject>

-(void)followed:(UIButton*)sender;

@end
@interface BakeGroupAdviceCell : UITableViewCell
@property (weak, nonatomic)id<BackGroupAdviceCellDelegate>delegate;

@property (strong, nonatomic) Cooker* cooker;

@end
