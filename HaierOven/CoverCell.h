//
//  CoverCell.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoverCell;
@protocol CoverCellDelegate <NSObject>

-(void)changeCover;

@end
@interface CoverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) UIImage* coverImage;
@property (weak, nonatomic)id <CoverCellDelegate>delegate;
@end
