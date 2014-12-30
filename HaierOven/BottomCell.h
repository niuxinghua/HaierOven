//
//  BottomCell.h
//  HaierOven
//
//  Created by dongl on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *saveDraftBtn;
@property (strong, nonatomic) IBOutlet UIButton *publicBtn;
@property (strong, nonatomic) IBOutlet UILabel *myPS_Label;

@property (strong, nonatomic) NSString *myPS_String;
@end
