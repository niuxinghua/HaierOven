//
//  StudyCookView.h
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudyCookView;
@protocol StudyCookViewDelegate <NSObject>

-(void)getSelectedView:(StudyCookView*)studycook;

@end
@interface StudyCookView : UIView
@property (strong, nonatomic) NSString *title;
@property (weak, nonatomic) id<StudyCookViewDelegate>delegate;
@end
