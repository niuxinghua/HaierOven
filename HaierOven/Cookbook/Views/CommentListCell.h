//
//  CommentListCell.h
//  众筹
//
//  Created by 刘康 on 14/11/25.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "CommentView.h"


@class CommentListCell;
@protocol CommentListCellDelegate <NSObject>

@required
- (void)replyTappedForCommentListCell:(CommentListCell*)cell;


@end

@interface CommentListCell : UITableViewCell

@property (strong, nonatomic) Comment* comment;

@property (weak, nonatomic) id <CommentListCellDelegate> delegete;

@end
