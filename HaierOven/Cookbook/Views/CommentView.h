//
//  CommentView.h
//  众筹
//
//  Created by 刘康 on 14/11/27.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "AttributedLabel.h"
#import "DrawedButton.h"



@class CommentView;
@protocol CommentViewDelegate <NSObject>

@required
- (void)replyButtonTappedForCommentView:(CommentView*)commentView;

@end

@interface CommentView : UIView

@property (strong, nonatomic) Comment* comment;

@property (strong, nonatomic) NSMutableArray* subCommentViews;

@property (strong, nonatomic) DrawedButton* replyButton;

@property (weak, nonatomic) id <CommentViewDelegate> delegate;

@end
