//
//  DeleteCookCell.h
//  HaierOven
//
//  Created by dongl on 15/1/7.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeleteCookCell;
@protocol DeleteCookCellDelegate <NSObject>

-(void)DeleteFoodCell:(UITableViewCell*)cell
         adnDeleteBtn:(UIButton *)btn;

@end
@interface DeleteCookCell : UITableViewCell
@property (weak, nonatomic)id<DeleteCookCellDelegate>delegate;
/**
 *  是否点击全选
 */
@property (nonatomic) BOOL isAllselected;
/**
 *  食物名字
 */
@property (strong, nonatomic)NSString *cookString;
@end
