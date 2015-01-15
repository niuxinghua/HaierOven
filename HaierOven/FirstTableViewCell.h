//
//  FirstTableViewCell.h
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FirstTableViewCell;
@protocol FirstTableViewCellDelegate <NSObject>
@required
-(void)signIn:(UIButton*)btn;

@end
@interface FirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avaterImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *siginBtn;
@property (weak, nonatomic) id<FirstTableViewCellDelegate>delegate;
- (IBAction)Sginin:(UIButton *)sender;
@end
