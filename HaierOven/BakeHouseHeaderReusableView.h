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
@end
@interface BakeHouseHeaderReusableView : UICollectionReusableView
@property (weak, nonatomic)id<BakeHouseHeaderReusableViewDelegate>delegate;

@end
