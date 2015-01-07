//
//  CookStarDetailTopView.h
//  HaierOven
//
//  Created by dongl on 15/1/6.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CookStarDetailTopView;
@protocol CookStarDetailTopViewDelegate <NSObject>

-(void)chickTags:(UIButton *)btn;
-(void)ponnedHeadView:(NSInteger)height
                  top:(NSInteger)top
            AndBottom:(NSInteger)Bottom;
-(void)follow:(UIButton *)sender;
-(void)leaveMessage;
-(void)playVideo;
-(void)studyCook;
@end
@interface CookStarDetailTopView : UIView
/**
 *  设置标签数字
 */
@property (strong, nonatomic) NSArray *tags;

@property (weak, nonatomic)id<CookStarDetailTopViewDelegate>delegate;
/**
 *  播放视频imageview
 */
@property (strong, nonatomic) IBOutlet UIImageView *vedioImage;@end
