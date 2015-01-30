//
//  SkillCell.h
//  HaierOven
//
//  Created by 刘康 on 15/1/30.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SkillCellDelegate <NSObject>

@required
- (void)startCook;

@end

@interface SkillCell : UITableViewCell

/**
 *  技巧小贴士
 */
@property (weak, nonatomic) IBOutlet UILabel *skillLabel;


@property (weak, nonatomic) id <SkillCellDelegate> delegate;


@end
