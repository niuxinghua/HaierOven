//
//  MenuDraftTableViewCell.h
//  HaierOven
//
//  Created by dongl on 14/12/28.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuDraftTableViewCell;
@protocol MenuDraftTableViewCellDelegate <NSObject>

-(void)DeleteDraftMneu:(UITableViewCell*)cell;

@end
@interface MenuDraftTableViewCell : UITableViewCell
@property (nonatomic) BOOL isEdit;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *deleteBg;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, weak)id<MenuDraftTableViewCellDelegate> delegate;
- (IBAction)DeleteDraft:(id)sender;

@end
