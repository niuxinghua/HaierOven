//
//  AddStepDetailCell.h
//  HaierOven
//
//  Created by dongl on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddStepDetailCell;
@protocol AddStepCellDetailDelegate <NSObject>

-(void)AddStepImage:(UIImageView*)imageview;
-(void)AddStepDescription:(UILabel*)label;
-(void)DeleteStepsAtIndex:(NSInteger)index;
@end

typedef NS_ENUM(NSUInteger, EditStyle) {
    EditStyleNone = 0,
    EditStyleDelete = 1,
    
};

@interface AddStepDetailCell : UITableViewCell
@property (nonatomic)EditStyle editStyle;
@property (strong, nonatomic) IBOutlet UIImageView *stepImage;
@property (strong, nonatomic) IBOutlet UILabel *stepIndexLabel;
@property (strong, nonatomic) IBOutlet UILabel *stepDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic)id<AddStepCellDetailDelegate>delegate;
/**
 *  添加步骤文字说明
 */
@property (strong, nonatomic) NSString *stepDescriptionString;

/**
 *  添加步骤下标
 */
@property (strong, nonatomic) NSString *stepIndexString;
@end
