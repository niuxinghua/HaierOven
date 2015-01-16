//
//  NormalTableViewCell.h
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NormalTableViewCellDelegate <NSObject>
@required
-(void)ChangeController:(UIView*)btn;

@end

@interface NormalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellSelectedView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *notificationCount;
@property (weak, nonatomic) id<NormalTableViewCellDelegate>delegate;
@end
