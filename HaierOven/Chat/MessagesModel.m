//
//  MessagesModel.m
//  HaierOven
//
//  Created by 刘康 on 15/1/9.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "MessagesModel.h"

#import "MessagesModel.h"

@implementation MessagesModel

- (instancetype)init
{
    if (self = [super init]) {
        self.messages = [NSMutableArray array];
        [self loadFakeMessages];
    }
    return self;
}

- (void)loadFakeMessages
{
    /**
     *  加载假数据
     */
    User* currentUser = [[User alloc] init];
    currentUser.userId = @"5";
    currentUser.userName = @"刘康";
    User* her = [[User alloc] init];
    her.userName = @"刘诗诗";
    her.userId = @"2014";
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     [[JSQMessage alloc] initWithSenderId:currentUser.userId
                                        senderDisplayName:currentUser.userName
                                                     date:[NSDate distantPast]
                                                     text:@"你好，我想了解一下你的项目！"],
                     
                     [[JSQMessage alloc] initWithSenderId:her.userId
                                        senderDisplayName:her.userName
                                                     date:[NSDate distantPast]
                                                     text:@"欢迎您的咨询。我们正在做一个关于电影投资的项目，前景不错，正在筹资。期待您的加入喔！"],
                     
                     [[JSQMessage alloc] initWithSenderId:currentUser.userId
                                        senderDisplayName:currentUser.userName
                                                     date:[NSDate distantPast]
                                                     text:@"能详细介绍一下吗？"],
                     
                     [[JSQMessage alloc] initWithSenderId:currentUser.userId
                                        senderDisplayName:currentUser.userName
                                                     date:[NSDate date]
                                                     text:@"貌似真的不错啊！"],
                     
                     [[JSQMessage alloc] initWithSenderId:her.userId
                                        senderDisplayName:her.userName
                                                     date:[NSDate date]
                                                     text:@"好的。《绣春刀》是中国电影股份有限公司、中央新闻纪录电影制片厂（集团）、北京大楚长歌影视文化有限公司、北京合力映画影视文化传媒有限公司联合出品的浪漫武侠电影，由路阳执导，张震、刘诗诗、王千源、李东学、聂远、金士杰、叶青、朱丹、周一围等主演。该片讲述了明末崇祯年间，锦衣卫三兄弟奉命追杀魏忠贤，最后却卷入到一场宫廷阴谋当中的充满悬疑的故事。2014年8月7日于中国内地上映。"],
                     
                     [[JSQMessage alloc] initWithSenderId:currentUser.userId
                                        senderDisplayName:currentUser.userName
                                                     date:[NSDate date]
                                                     text:@"了解了~ 不错啊。"],
                     nil];
    
    [self addPhotoMediaMessage];
    
    
    
    JSQMessage *reallyLongMessage = [JSQMessage messageWithSenderId:currentUser.userId
                                                        displayName:currentUser.userName
                                                               text:@"杀锦衣卫冒名代之的李东学，后来改了名字，叫靳一川，之后他一身官服行走江湖，令人生畏，一双短刀上下翻飞如灵蛇舞动，杀敌于五步之内，这双刀，既承载了师傅的厚爱，也成为其安身立命的根本，飞鱼服绣春刀，是为朝廷效命的标志，也是隐身衙门的伪装，苦衷由来，不过只是为了——活着。"];
    
    [self.messages addObject:reallyLongMessage];
    
    /**
     *  Create avatar images once.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     *  If you are not using avatars, ignore this.
     */
    //    JSQMessagesAvatarImage *jsqImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"JSQ"
    //                                                                                  backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
    //                                                                                        textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
    //                                                                                             font:[UIFont systemFontOfSize:14.0f]
    //                                                                                         diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    JSQMessagesAvatarImage *meImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"QQQ.png"]
                                                                                 diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    JSQMessagesAvatarImage *herImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"QQQ.png"]
                                                                                  diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    
    self.avatars = @{ currentUser.userId : meImage,
                      her.userId : herImage };
    
    
    self.users = @{ currentUser.userId  : currentUser.userName,
                    her.userId : her.userName };
    
    
    /**
     *  Create message bubble images objects.
     *
     *  Be sure to create your bubble images one time and reuse them for good performance.
     *
     */
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
}

- (void)addPhotoMediaMessage
{
    /**
     * 假数据
     */
    User* currentUser = [[User alloc] init];
    currentUser.userId = @"5";
    currentUser.userName = @"刘康";
    
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"QQQ.png"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:currentUser.userId
                                                   displayName:currentUser.userName
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}

@end
