//
//  SectionFiexibleView.h
//  HaierOven
//
//  Created by dongl on 15/1/12.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SectionFiexibleView;
@protocol SectionFiexibleViewDelegate <NSObject>

-(void)GetfiexibleBtnSelected:(UIButton *)sender
                    andUIView:(SectionFiexibleView *)sectionFiexibleView;


@end

@interface SectionFiexibleView : UIView
@property (weak, nonatomic)id<SectionFiexibleViewDelegate>delegate;
@end
