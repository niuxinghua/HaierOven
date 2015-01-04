//
//  Comment.m
//  HaierOven
//
//  Created by 刘康 on 14/12/22.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "Comment.h"
#import "AttributedLabel.h"

const CGFloat kAvatarSize = 35.0;
const CGFloat kReplyButtonWidth = 50;
const CGFloat kLineSpacing = 4;
const CGFloat kCharacterSpacing = 2;


@implementation Comment

- (instancetype)init
{
    if (self = [super init]) {
        self.fromUser = [[CommentUser alloc] init];
        self.toUser = [[CommentUser alloc] init];
    }
    return self;
}

- (CGFloat)getHeight
{
    CGFloat commentHeight = 0.0f;
    
    // 头像距离顶部距离
    commentHeight += 10;
    
    // 头像高度
    commentHeight += kAvatarSize;
    
//    CGFloat commentWidth = self.isSubComment ? Main_Screen_Width - 60 - 20 : Main_Screen_Width - 60;
    CGFloat commentWidth = Main_Screen_Width - 68;
    
    // 计算评论高度
    AttributedLabel *tempLabel = [[AttributedLabel alloc] init];
    tempLabel.linesSpacing = kLineSpacing;
    tempLabel.characterSpacing = kCharacterSpacing;
    tempLabel.font = CommentFont;
    tempLabel.text = self.content;
    commentHeight += [tempLabel getAttributedStringHeightWidthValue:commentWidth];
    
    // 评论下边距
    commentHeight += 15;
    
    //    if (self.subComments.count > 0) {
    //        for (Comment* subComment in self.subComments) {
    //            commentHeight += [subComment getHeight]; // 递归获取评论高度
    //        }
    //    }
    
    return commentHeight + 20;
}

@end
