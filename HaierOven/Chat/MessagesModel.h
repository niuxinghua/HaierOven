//
//  MessagesModel.h
//  HaierOven
//
//  Created by 刘康 on 15/1/9.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"

@interface MessagesModel : NSObject

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) NSDictionary *users;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;


/**
 *  添加图片
 */
- (void)addPhotoMediaMessage;


@end