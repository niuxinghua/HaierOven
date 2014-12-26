//
//  MyPageView.h
//  HaierOven
//
//  Created by 刘康 on 14/12/25.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MYPAGEVIEW_DID_UPDATE_NOTIFICATION @"MyPageViewDidUpdate"

@protocol MyPageViewDelegate;

@interface MyPageView : UIView

//- (void)setImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage forKey:(NSString *)key;

@property (nonatomic) NSInteger numberOfPages;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) id<MyPageViewDelegate>delegate;

@end

@protocol MyPageViewDelegate <NSObject>

@optional
- (BOOL)pageView:(MyPageView *)pageView shouldUpdateToPage:(NSInteger)newPage;
- (void)pageView:(MyPageView *)pageView didUpdateToPage:(NSInteger)newPage;



@end
