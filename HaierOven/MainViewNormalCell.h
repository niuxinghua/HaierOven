//
//  MainViewNormalCell.h
//  HaierOven
//
//  Created by dongl on 14/12/17.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerView.h"
#import "Cookbook.h"
@class MainViewNormalCell;
@protocol MainViewNormalCellDelegate <NSObject>
-(void)ChickLikeBtn:(id)cellClass andBtn:(UIButton*)btn;
-(void)ChickPlayBtn:(id)cellClass;
@end
@interface MainViewNormalCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *MainCellFoodBackground;
/**
 *  官方菜谱标签
 */
@property (strong, nonatomic) IBOutlet UIImageView *AuthorityLabel;

/**
 *  v标记
 */
@property (weak, nonatomic) IBOutlet UIImageView *cookStarImageView;

@property (strong, nonatomic) IBOutlet UIButton *chickGoodBtn;
@property (strong, nonatomic) IBOutlet UILabel *goodCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet ContainerView *bottomOrangeView;
@property (strong, nonatomic) IBOutlet UIButton *avater;
@property (strong, nonatomic) IBOutlet UILabel *cookerName;
@property (strong, nonatomic) IBOutlet UILabel *foodName;
@property (strong, nonatomic) IBOutlet UILabel *foodMakeFunction;
@property (strong, nonatomic) IBOutlet UIButton *vedioBtn;

@property (strong, nonatomic) Cookbook* cookbook;

@property (nonatomic) BOOL hadVideo;

@property (weak, nonatomic)id<MainViewNormalCellDelegate>delegate;
- (IBAction)Like:(UIButton *)sender;
- (IBAction)Play:(UIButton *)sender;
@end
