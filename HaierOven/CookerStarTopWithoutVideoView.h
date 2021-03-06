//
//  CookerStarTopWithoutVideoView.h
//  HaierOven
//
//  Created by 刘康 on 15/3/1.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoSizeLabelView.h"
#import "CookStarPullView.h"

@class CookStarDetailTopView;


@protocol CookerStarTopWithoutVideoViewDelegate <NSObject>

-(void)chickTags:(UIButton *)btn;
-(void)ponnedHeadView:(NSInteger)height
                  top:(NSInteger)top
            AndBottom:(NSInteger)Bottom;
-(void)follow:(UIButton *)sender;
-(void)leaveMessage;
-(void)playVideo;
-(void)studyCook;
//-(void)UpLoadHeadViewHeight:(CGFloat)height;
- (void)updateHeadViewHeight:(CGFloat)height;

@end

@interface CookerStarTopWithoutVideoView : UIView
/**
 *  设置标签数字
 */
@property (strong, nonatomic) NSArray *tags;

@property (weak, nonatomic)id <CookerStarTopWithoutVideoViewDelegate> delegate;


/**
 *  关注按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (strong, nonatomic) AutoSizeLabelView *tagsView;

/**
 *  container
 */
@property (strong, nonatomic) IBOutlet UIView *backDownView;//计算用

/**
 *  底部下拉view
 */
@property (strong, nonatomic) IBOutlet CookStarPullView *bottomView;


@property (strong, nonatomic) IBOutlet UIButton *studyCook;

@property (strong, nonatomic) IBOutlet UIImageView *avaterImage;

/**
 *  级别图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  签名
 */
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

/**
 *  简介
 */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@property (strong, nonatomic) CookerStar* cookerStar;


@end
