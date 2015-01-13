//
//  FiexibleView.h
//  HaierOven
//
//  Created by dongl on 15/1/13.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FiexibleView;
@protocol FiexibleViewDelegate <NSObject>

-(void)tapLabel:(UILabel*)label;

@end
@interface FiexibleView : UIView
@property (strong, nonatomic) NSArray *equipments;
@property (nonatomic) CGRect imageFrame;
@property (weak, nonatomic)id<FiexibleViewDelegate>delegate;
@end
