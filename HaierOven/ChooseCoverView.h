//
//  ChooseCoverView.h
//  HaierOven
//
//  Created by dongl on 14/12/28.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseCoverView;
@protocol ChooseCoverViewDelegate <NSObject>

-(void)TakeCover:(NSInteger)tag;

@end
@interface ChooseCoverView : UIView
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
- (IBAction)action:(UIButton *)sender;
@property (weak, nonatomic) id<ChooseCoverViewDelegate> delegate;
@end

