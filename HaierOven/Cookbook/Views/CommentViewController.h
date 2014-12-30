//
//  CommentViewController.h
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithData:(NSMutableArray *)comments andController:(id)controller;

@end
