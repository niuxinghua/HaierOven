//
//  StudyCookCell.h
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyCookView.h"
@class StudyCookCell;
@protocol StudyCookCellDelegate <NSObject>

-(void)fixedCell:(StudyCookCell*)cell;
@end

@interface StudyCookCell : UITableViewCell
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *bkImage;
@property (strong, nonatomic) NSArray *details;
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic)id<StudyCookCellDelegate,StudyCookViewDelegate>delegate;
@end
