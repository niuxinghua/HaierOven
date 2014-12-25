//
//  RecommendTagView.h
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommendTagView;
@protocol RecommendTagViewDelegate <NSObject>

-(void)TouchUpTag:(id)tag;

@end
@interface RecommendTagView : UIView
@property (strong, nonatomic) IBOutlet UIButton *tagbtn;
@property (weak, nonatomic)id<RecommendTagViewDelegate>delegate;
@end
