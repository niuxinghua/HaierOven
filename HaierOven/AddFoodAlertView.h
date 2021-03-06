//
//  AddFoodAlertView.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, AddFoodAlertType) {
    AddFoodAlertTypeAddFood     = 2,
    AddFoodAlertTypeAddWeight   = 1,
};

@class AddFoodAlertView;
@protocol AddFoodAlertViewDelegate <NSObject>

@required
-(void)ChickAlert:(UILabel*)label andTextFailed:(UITextField*)textfield;
-(void)Cancel;
- (void)beginEditFood:(UITextField*)sender;
- (void)endEditFood:(UITextField*)sender;


@end

@interface AddFoodAlertView : UIView    <UITextFieldDelegate>
@property (nonatomic)  AddFoodAlertType addFoodAlertType;
@property (strong, nonatomic) IBOutlet UILabel *alertTitle;
@property (strong, nonatomic) IBOutlet UITextField *alertTextFailed;
@property (weak, nonatomic)id<AddFoodAlertViewDelegate>delegate;

@property (strong, nonatomic) NSString *alertTitleSting;
@property (strong, nonatomic) UILabel *label;


- (IBAction)ChickAlert:(id)sender;

@end
