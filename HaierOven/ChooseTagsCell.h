//
//  ChooseTagsCell.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoSizeLabelView.h"
@interface ChooseTagsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cookName;
@property (weak, nonatomic) IBOutlet AutoSizeLabelView *tagsView;

@end
