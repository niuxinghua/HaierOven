//
//  SearchView.h
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchView;
@protocol searchViewDelegate <NSObject>

-(void)TouchUpInsideCancelBtn;
-(void)StartReach:(UITextField*)searchTextFailed;
-(void)Cancel;
@end
@interface SearchView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *cancelbtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextFailed;
@property (weak, nonatomic)id<searchViewDelegate>delegate;
@end
