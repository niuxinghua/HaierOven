//
//  CookListFoodView.h
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CookListFoodViewDelegate <NSObject>

@required

- (void)purchaseFood:(PurchaseFood*)food purchased:(BOOL)isPurchase;

@end

@interface CookListFoodView : UIView
/**
 *  食材对象
 */
@property (strong, nonatomic) PurchaseFood* food;

@property (weak, nonatomic) id<CookListFoodViewDelegate> delegate;

@end
