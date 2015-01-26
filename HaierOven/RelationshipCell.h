//
//  RelationshipCell.h
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@class RelationshipCell;
@protocol RelationshipCellDelegate <NSObject>

@required
- (void)RelationshipCell:(RelationshipCell*)cell watchingButtonTapped:(UIButton*)sender;

@end

@interface RelationshipCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avaterImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *watchingBtn;

@property (strong, nonatomic) Friend* user;

@property (weak, nonatomic) id <RelationshipCellDelegate> delegate;

@end
