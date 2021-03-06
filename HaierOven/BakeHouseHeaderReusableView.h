//
//  BakeHouseHeaderReusableView.h
//  HaierOven
//
//  Created by dongl on 15/1/12.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionFiexibleView.h"
@class BakeHouseHeaderReusableView;
@protocol BakeHouseHeaderReusableViewDelegate <NSObject>
-(void)GetfiexibleBtnSelected:(UIButton *)sender
                    andUIView:(SectionFiexibleView *)sectionFiexibleView;

-(void)GetSearchKeyWord:(NSString*)string;

-(void)GetNeedEquipmentType:(NSInteger)type;

/**
 *  点击搜索按钮
 */
- (void)cancelSearch;

/**
 *  点击小x取消搜索
 */
- (void)deleteSearch;

@end
@interface BakeHouseHeaderReusableView : UICollectionReusableView
@property (weak, nonatomic)id<BakeHouseHeaderReusableViewDelegate>delegate;
@property (weak, nonatomic) UITextField* searchTextField;

@end
