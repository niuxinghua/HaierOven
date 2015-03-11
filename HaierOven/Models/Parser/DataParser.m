//
//  DataParser.m
//  追爱行动
//
//  Created by 刘康 on 14-10-3.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "DataParser.h"
#import "Tag.h"
#import "Comment.h"
#import "Cookbook.h"
#import "Cooker.h"
#import "CookerStar.h"
#import "Message.h"
#import "Friend.h"


@class Food, Creator, Step, CookerStar;

@implementation DataParser

+ (User*)parseUserWithDict:(NSDictionary*)dict
{
    NSDictionary* userDict = dict[@"data"];
    
    if ([userDict isKindOfClass:[NSNull class]]) {
        return [[User alloc] init];
    }
    
    User* user = [DataParser parseUserInfoWithDict:userDict];
    
    return user;
}

+ (User*)parseUserInfoWithDict:(NSDictionary*)userDict
{
    
    @try {
        User* user = [[User alloc] init];
        
        user.userBaseId     = [userDict[@"userBaseID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"userBaseID"]];
        user.userId         = [userDict[@"userID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"userID"]];
        user.userType       = [userDict[@"userType"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"userType"]];
        user.loginName      = [userDict[@"loginName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"loginName"]];
        
        NSString* password  = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
        if (password != nil) {
            user.password   = password;
        }
        user.email          = [userDict[@"email"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"email"]];
        user.phone          = [userDict[@"mobile"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"mobile"]];
        user.accType        = [userDict[@"accType"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"accType"]];
        user.status         = [userDict[@"status"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"status"]];
        user.isDeleted      = [userDict[@"IsDeleted"] isKindOfClass:[NSNull class]] ? NO : [userDict[@"IsDeleted"] boolValue];
        
        NSDictionary* profileDict = userDict[@"userProfile"];
        
        user.userProfileId      = [profileDict[@"id"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"id"]];
        user.nickName           = [profileDict[@"nickName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"nickName"]];
        user.userName           = [profileDict[@"userName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"userName"]];
        user.sex                = [profileDict[@"sex"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"sex"]];
        
        user.address            = [profileDict[@"address"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"address"]];
        
        user.level              = [profileDict[@"userLevel"] isKindOfClass:[NSNull class]] ? 0 : [profileDict[@"userLevel"] integerValue];
        
        user.birthday           = [profileDict[@"birthday"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"birthday"]];
        user.accessToken        = [profileDict[@"accessToken"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"accessToken"]];
        user.note               = [profileDict[@"note"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"note"]];
        user.maritalStatus      = [profileDict[@"maritalStatus"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"maritalStatus"]];
        user.occupation         = [profileDict[@"occupation"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"occupation"]];
        user.monthlyIncome      = [profileDict[@"monthlyIncome"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"monthlyIncome"]];
        NSString* userAvatar    = [profileDict[@"userAvatar"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"userAvatar"]];
        user.userAvatar         = [DataParser parseImageUrlWithString:userAvatar];
        user.focusCount         = [profileDict[@"focusCount"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"focusCount"]];
        user.followCount        = [profileDict[@"followCount"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"followCount"]];
        user.points             = [profileDict[@"points"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", profileDict[@"points"]];
        
        user.userAttribute      = [userDict[@"userAttribute"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"userAttribute"]];
        user.marvellouschefInfo = [userDict[@"marvellouschefInfo"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"marvellouschefInfo"]];
        
        return user;
    }
    @catch (NSException *exception) {
        NSLog(@"解析用户信息失败");
    }
    @finally {
        
    }
    
    
}

+ (Friend*)parseFriendWithDict:(NSDictionary*)dict
{
    Friend* friend = [[Friend alloc] init];
    
    friend.cookbookAmount = [dict[@"cookbookAmount"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"cookbookAmount"] integerValue];
    friend.fansAmount = [dict[@"fansAmount"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"fansAmount"] integerValue];
    friend.isFollowed = [dict[@"isFollowed"] isKindOfClass:[NSNull class]] ? NO : [dict[@"isFollowed"] integerValue];
    friend.signature = [dict[@"signature"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", dict[@"signature"]];
    NSString* userAvatar      = [dict[@"userAvatar"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", dict[@"userAvatar"]];
    friend.avatar = [DataParser parseImageUrlWithString:userAvatar];
    friend.userBaseId = [dict[@"userBaseID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", dict[@"userBaseID"]];
    friend.userName = [dict[@"userName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", dict[@"userName"]];
    friend.userLevel = [dict[@"userLevel"] isKindOfClass:[NSNull class]] ? 5 : [[NSString stringWithFormat:@"%@", dict[@"userLevel"]] integerValue];
    
    if (friend.cookbookAmount > 0) {
        NSArray* cookbookArr = dict[@"cookbooks"];
        NSMutableArray* cookbooks = [NSMutableArray array];
        for (NSDictionary* cookbookDict in cookbookArr) {
            Cookbook* cookbook = [[Cookbook alloc] init];
            
            cookbook.ID             = [cookbookDict[@"cookbookID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookID"]];
            cookbook.name           = [cookbookDict[@"cookbookName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookName"]];
            cookbook.desc           = [cookbookDict[@"cookbookDesc"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookDesc"]];
            NSString* coverPhoto     = [cookbookDict[@"cookbookCoverPhoto"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookCoverPhoto"]];
            cookbook.coverPhoto     = [DataParser parseImageUrlWithString:coverPhoto];
            cookbook.modifiedTime   = [cookbookDict[@"modifiedTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"modifiedTime"]];
            cookbook.modifiedTime   = [DataParser parseTime:cookbook.modifiedTime];
            NSDictionary* creatDict = cookbookDict[@"creator"];
            cookbook.creator        = [DataParser parseCreatorWithDict:creatDict];
            cookbook.praises        = [cookbookDict[@"praiseCount"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"praiseCount"]];
            
            [cookbooks addObject:cookbook];
        }
        
        friend.cookbooks = cookbooks;
    }
    
    
    return friend;
}

+ (NSMutableArray*)parseUsersWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage
{
    NSDictionary* dataDict = dict[@"data"];
    
    if ([dataDict isKindOfClass:[NSNull class]]) {
        return [NSMutableArray array];
    }
    
    *hadNextPage = [dataDict[@"hasNextPage"] boolValue];
    
    NSMutableArray* follows = [NSMutableArray array];
    
    NSArray* followsArr = dataDict[@"items"];
    for (NSDictionary* userDict in followsArr) {
//        User* user = [DataParser parseUserInfoWithDict:userDict];
        Friend* friend = [DataParser parseFriendWithDict:userDict];
        [follows addObject:friend];
    }
    
    return follows;
}

+ (NSMutableArray*)parseTagsWithDict:(NSDictionary*)dict
{
    NSMutableArray* tags = [NSMutableArray array];
    
    NSArray* tagArr = dict[@"data"];
    for (NSDictionary* tagDict in tagArr) {
        [tags addObject:[DataParser parseTagWithDict:tagDict]];
    }
    
    return tags;
}

+ (Tag*)parseTagWithDict:(NSDictionary*)tagDict
{
    Tag* tag = [[Tag alloc] init];
    tag.ID      = [tagDict[@"tagID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", tagDict[@"tagID"]];
    tag.name    = [tagDict[@"tagName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", tagDict[@"tagName"]];
    tag.isHot   = [tagDict[@"isHot"] isKindOfClass:[NSNull class]] ? NO : [tagDict[@"isHot"] boolValue];
    tag.isDeleted = [tagDict[@"isDeleted"] isKindOfClass:[NSNull class]] ? NO : [tagDict[@"isDeleted"] boolValue];
    return tag;
}

+ (NSMutableArray*)parseCommentsWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage
{
    NSMutableArray* comments = [NSMutableArray array];
    
    NSDictionary* dataDict = dict[@"data"];
    
    if ([dataDict isKindOfClass:[NSNull class]]) {
        return [NSMutableArray array];
    }
    
    *hadNextPage = [dataDict[@"hasNextPage"] boolValue];
    
    NSArray* commentArr = dataDict[@"items"];
    for (NSDictionary* commentDict in commentArr) {
        Comment* comment = [[Comment alloc] init];
        
        comment.ID                  = [commentDict[@"commentID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", commentDict[@"commentID"]];
        comment.content             = [commentDict[@"commentContent"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", commentDict[@"commentContent"]];
        comment.objectId            = [commentDict[@"commentObjectID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", commentDict[@"commentObjectID"]];
        
        comment.fromUser            = [DataParser parseCommentUserWithDict:commentDict[@"fromUser"]];
        comment.toUser              = [DataParser parseCommentUserWithDict:commentDict[@"toUser"]];
        
        comment.commentTime        = [commentDict[@"commentTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", commentDict[@"commentTime"]];
        comment.commentTime         = [DataParser parseTime:comment.commentTime];
        
        [comments addObject:comment];
    }
    
    
    return comments;
}

+ (CommentUser*)parseCommentUserWithDict:(NSDictionary*)userDict
{
    CommentUser* commentUser = [[CommentUser alloc] init];
    
    if ([userDict isKindOfClass:[NSNull class]]) {
        return commentUser;
    }
    
    commentUser.userBaseId      = [userDict[@"userBaseID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"userBaseID"]];
    commentUser.loginName       = [userDict[@"loginName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"loginName"]];
    commentUser.nickName        = [userDict[@"nickName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"nickName"]];
    commentUser.userName        = [userDict[@"userName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"userName"]];
    commentUser.signature       = [userDict[@"signature"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"signature"]];
    commentUser.userLevel       = [userDict[@"userLevel"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"userLevel"]];
    NSString* userAvatar      = [userDict[@"userAvatar"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", userDict[@"userAvatar"]];
    
    commentUser.userAvatar    = [DataParser parseImageUrlWithString:userAvatar];
    
    return commentUser;
}

+ (NSString*)parseImageUrlWithString:(NSString*)path
{
    NSString* imagePath;
    
//    path = [path stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    imagePath = [BaseOvenUrl stringByAppendingPathComponent:path];
    
    return imagePath;
}

+ (Creator*)parseCreatorWithDict:(NSDictionary*)creatorDict
{
    Creator* creator = [[Creator alloc] init];
    
    //creator.ID              = [creatorDict[@"id"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", creatorDict[@"id"]];
    creator.userBaseId      = [creatorDict[@"userBaseID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", creatorDict[@"userBaseID"]];
    creator.userName        = [creatorDict[@"userName"] isKindOfClass:[NSNull class]] || creatorDict[@"userName"] == nil ? @"" : [NSString stringWithFormat:@"%@", creatorDict[@"userName"]];
    NSString* avatarPath    = [creatorDict[@"userAvatar"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", creatorDict[@"userAvatar"]];
    creator.avatarPath      = [DataParser parseImageUrlWithString:avatarPath];
    
    creator.userLevel        = [creatorDict[@"userLevel"] isKindOfClass:[NSNull class]] || creatorDict[@"userLevel"] == nil ? @"5" : [NSString stringWithFormat:@"%@", creatorDict[@"userLevel"]]; 
    
    return creator;
}

+ (NSMutableArray*)parseCookbooksWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage
{
    NSMutableArray* cookbooks = [NSMutableArray array];
    
    NSDictionary* dataDict = dict[@"data"];
    
    if ([dataDict isKindOfClass:[NSNull class]]) {
        return [NSMutableArray array];
    }
    
    *hadNextPage = [dataDict[@"hasNextPage"] boolValue];
    
    NSArray* cookbooksArr = dataDict[@"items"];
    for (NSDictionary* cookbookDict in cookbooksArr) {
        Cookbook* cookbook = [[Cookbook alloc] init];
        
        cookbook.ID             = [cookbookDict[@"cookbookID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookID"]];
        cookbook.name           = [cookbookDict[@"cookbookName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookName"]];
        cookbook.desc           = [cookbookDict[@"cookbookDesc"] isKindOfClass:[NSNull class]] || cookbookDict[@"cookbookDesc"] == nil ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookDesc"]];
        NSString* coverPhoto     = [cookbookDict[@"cookbookCoverPhoto"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookCoverPhoto"]];
        cookbook.coverPhoto     = [DataParser parseImageUrlWithString:coverPhoto];
        cookbook.modifiedTime   = [cookbookDict[@"modifiedTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"modifiedTime"]];
        
        cookbook.modifiedTime = [DataParser parseTime:cookbook.modifiedTime];
        
        NSDictionary* creatDict = cookbookDict[@"creator"];
        cookbook.creator        = [DataParser parseCreatorWithDict:creatDict];
        
        if ([cookbook.creator.userLevel isEqualToString:@"1"] || [cookbook.creator.userLevel isEqualToString:@"2"]) {
            cookbook.isAuthority = YES;
        }
        
        cookbook.praises        = [cookbookDict[@"praiseCount"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"praiseCount"]];
        
        [cookbooks addObject:cookbook];
    }
    
    return cookbooks;
}

+ (NSString*)parseTime:(NSString*)timeStr
{
    long long seconds = [timeStr longLongValue]/1000;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [MyTool intervalSinceNow:date];
}


+ (Step*)parseStepWithStepDict:(NSDictionary*)stepDict
{
    Step* step = [[Step alloc] init];
    step.ID             = [stepDict[@"cookbookStepID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", stepDict[@"cookbookStepID"]];
    step.index          = [stepDict[@"stepIndex"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", stepDict[@"stepIndex"]];
    NSString* photo          = [stepDict[@"stepPhoto"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", stepDict[@"stepPhoto"]];
    step.photo          = [DataParser parseImageUrlWithString:photo];
    step.desc           = [stepDict[@"stepDesc"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", stepDict[@"stepDesc"]];
    step.cookbookID     = [stepDict[@"cookbookID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", stepDict[@"cookbookID"]];
    
    return step;
}

+ (Food*)parseFoodWithFoodDict:(NSDictionary*)foodDict
{
    Food* food      = [[Food alloc] init];
    food.ID         = [foodDict[@"cookbookFoodsID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", foodDict[@"cookbookFoodsID"]];
    food.index      = [foodDict[@"cookbookFoodIndex"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", foodDict[@"cookbookFoodIndex"]];
    food.cookbookID = [foodDict[@"cookbookID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", foodDict[@"cookbookID"]];
    food.name       = [foodDict[@"foodName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", foodDict[@"foodName"]];
    food.desc       = [foodDict[@"foodDesc"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", foodDict[@"foodDesc"]];
    return food;
}

+ (CookbookDetail*)parseCookbookDetailWithDict:(NSDictionary*)dict
{
    CookbookDetail* cookbookDetail = [[CookbookDetail alloc] init];
    
    NSDictionary* detailDict = dict[@"data"];
    
    if ([detailDict isKindOfClass:[NSNull class]]) {
        return [[CookbookDetail alloc] init];
    }
    
    cookbookDetail.cookbookId       = [detailDict[@"cookbookID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookID"]];
    cookbookDetail.name             = [detailDict[@"cookbookName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookName"]];
    cookbookDetail.desc             = [detailDict[@"cookbookDesc"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookDesc"]];
    NSString* coverPhoto       = [detailDict[@"cookbookCoverPhoto"] isKindOfClass:[NSNull class]] || detailDict[@"cookbookCoverPhoto"] == nil? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookCoverPhoto"]];
    cookbookDetail.coverPhoto       = [DataParser parseImageUrlWithString:coverPhoto];
    cookbookDetail.cookbookTip      = [detailDict[@"cookbookTip"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookTip"]];
    cookbookDetail.status           = [detailDict[@"status"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"status"]];
    cookbookDetail.praised          = [detailDict[@"praises"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"praises"]];
    cookbookDetail.modifiedTime     = [detailDict[@"modifiedTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"modifiedTime"]];
    cookbookDetail.modifiedTime     = [DataParser parseTime:cookbookDetail.modifiedTime];
    
    NSMutableArray* tags            = [NSMutableArray array];
    NSMutableArray* tagArr          = detailDict[@"tags"];
    for (NSDictionary* tagDict in tagArr) {
        [tags addObject:[DataParser parseTagWithDict:tagDict]];
    }
    cookbookDetail.tags             = [tags copy];
    
    NSMutableArray* steps           = [NSMutableArray array];
    NSMutableArray* stepArr         = detailDict[@"steps"];
    for (NSDictionary* stepDict in stepArr) {
        [steps addObject:[DataParser parseStepWithStepDict:stepDict]];
    }
    cookbookDetail.steps            = [steps copy];
    
    NSMutableArray* foods           = [NSMutableArray array];
    NSMutableArray* foodArr         = detailDict[@"foods"];
    for (NSDictionary* foodDict in foodArr) {
        [foods addObject:[DataParser parseFoodWithFoodDict:foodDict]];
    }
    cookbookDetail.foods            = [foods copy];
    
    NSDictionary* ovenDict          = detailDict[@"cookbookOven"];
    CookbookOven* oven              = [[CookbookOven alloc] init];
    oven.roastStyle                 = [ovenDict[@"roastStyle"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", ovenDict[@"roastStyle"]];
    oven.roastTemperature           = [ovenDict[@"roastTemperature"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", ovenDict[@"roastTemperature"]];
    oven.roastTime                  = [ovenDict[@"roastTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", ovenDict[@"roastTime"]];
    oven.ovenInfo                   = ovenDict[@"oveninfo"];
    oven.ovenType                   = [ovenDict[@"ovenType"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", ovenDict[@"ovenType"]];
    cookbookDetail.oven             = oven;
    
    cookbookDetail.creator          = [DataParser parseCreatorWithDict:detailDict[@"creator"]];
    
    return cookbookDetail;
}

+ (NSMutableArray*)parseShoppingListWithDict:(NSDictionary*)dict
{
    NSMutableArray* shoppingList = [NSMutableArray array];
    
    NSArray* shoppingListArr = dict[@"data"];
    
    if ([shoppingListArr isKindOfClass:[NSNull class]]) {
        return shoppingList;
    }
    
    for (NSDictionary* shoppingListDict in shoppingListArr) {
        ShoppingOrder* shoppingOrder = [[ShoppingOrder alloc] init];
        shoppingOrder.cookbookID = [shoppingListDict[@"cookbookID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", shoppingListDict[@"cookbookID"]];
        shoppingOrder.cookbookName = [shoppingListDict[@"cookbookName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", shoppingListDict[@"cookbookName"]];
//        shoppingOrder.createdTime = [shoppingListDict[@"createdTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", shoppingListDict[@"createdTime"]];
        shoppingOrder.creatorId = [shoppingListDict[@"creatorID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", shoppingListDict[@"creatorID"]];
        
        NSArray* foodArr = shoppingListDict[@"foods"];
        NSMutableArray* purchaseFoods = [NSMutableArray array];
        for (NSDictionary* foodDict in foodArr) {
            PurchaseFood* purchaseFood = [[PurchaseFood alloc] init];
            purchaseFood.desc = [foodDict[@"foodDesc"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", foodDict[@"foodDesc"]];
            purchaseFood.index = [foodDict[@"foodIndex"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", foodDict[@"foodIndex"]];
            purchaseFood.name = [foodDict[@"foodName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", foodDict[@"foodName"]];
            purchaseFood.isPurchase = [foodDict[@"isPurchase"] integerValue] == 0 ? NO : YES;
            [purchaseFoods addObject:purchaseFood];
        }
        shoppingOrder.foods = purchaseFoods;
        
        [shoppingList addObject:shoppingOrder];
    }
    
    
    return shoppingList;
}

+ (NSMutableArray*)parseCookersWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage
{
    NSMutableArray* cookers = [NSMutableArray array];
    
    NSDictionary* dataDict = dict[@"data"];
    
    if ([dataDict isKindOfClass:[NSNull class]]) {
        return cookers;
    }
    
    *hadNextPage = [dataDict[@"hasNextPage"] boolValue];
    
    NSArray* cookerArr = dataDict[@"items"];
    
    for (NSDictionary* cookerDict in cookerArr) {
        
        Cooker* recommentCooker = [[Cooker alloc] init];
        
        NSArray* cookbookArr = cookerDict[@"cookbooks"];
        NSMutableArray* cookbooks = [NSMutableArray array];
        for (NSDictionary* cookbookDict in cookbookArr) {
            Cookbook* cookbook = [[Cookbook alloc] init];
            
            cookbook.ID             = [cookbookDict[@"cookbookID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookID"]];
            cookbook.name           = [cookbookDict[@"cookbookName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookName"]];
            cookbook.desc           = [cookbookDict[@"cookbookDesc"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookDesc"]];
            NSString* coverPhoto     = [cookbookDict[@"cookbookCoverPhoto"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookCoverPhoto"]];
            cookbook.coverPhoto     = [DataParser parseImageUrlWithString:coverPhoto];
            cookbook.modifiedTime   = [cookbookDict[@"modifiedTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"modifiedTime"]];
            cookbook.modifiedTime   = [DataParser parseTime:cookbook.modifiedTime];
            NSDictionary* creatDict = cookbookDict[@"creator"];
            cookbook.creator        = [DataParser parseCreatorWithDict:creatDict];
            cookbook.praises        = [cookbookDict[@"praiseCount"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"praiseCount"]];
            
            [cookbooks addObject:cookbook];
        }
        
        recommentCooker.cookbooks = cookbooks;
        
        recommentCooker.fansAmount = [cookerDict[@"fansAmount"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"fansAmount"]];
        recommentCooker.isFollowed = [cookerDict[@"isFollowed"] integerValue] == 0 ? NO : YES;
        recommentCooker.signature = [cookerDict[@"signature"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"signature"]];
        NSString* avatar     = [cookerDict[@"userAvatar"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"userAvatar"]];
        recommentCooker.avatar     = [DataParser parseImageUrlWithString:avatar];
        recommentCooker.userBaseId = [cookerDict[@"userBaseID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"userBaseID"]];
        recommentCooker.userLevel = [cookerDict[@"userLevel"] isKindOfClass:[NSNull class]] ? 0 : [cookerDict[@"userLevel"] integerValue];
        recommentCooker.userName = [cookerDict[@"userName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"userName"]];
        
        
        [cookers addObject:recommentCooker];
        
    }
    
    
    return cookers;
}

+ (NSMutableArray*)parseCookerStarsWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage
{
    NSMutableArray* cookerStars = [NSMutableArray array];
    
    NSDictionary* dataDict = dict[@"data"];
    
    if ([dataDict isKindOfClass:[NSNull class]]) {
        return cookerStars;
    }
    
    *hadNextPage = [dataDict[@"hasNextPage"] boolValue];
    
    NSArray* cookerArr = dataDict[@"items"];
    
    for (NSDictionary* cookerDict in cookerArr) {
        CookerStar* cookerStar = [[CookerStar alloc] init];
        cookerStar.avatar = [cookerDict[@"userAvatar"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"userAvatar"]];
        cookerStar.avatar = [DataParser parseImageUrlWithString:cookerStar.avatar];
        cookerStar.userName = [cookerDict[@"userName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"userName"]];
        cookerStar.signature = [cookerDict[@"signature"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"signature"]];
        cookerStar.introduction = [cookerDict[@"introduction"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"introduction"]];
        cookerStar.videoPath = [cookerDict[@"videoPath"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"videoPath"]];
        cookerStar.videoCover = [cookerDict[@"videoCover"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"videoCover"]];
        cookerStar.videoCover = [DataParser parseImageUrlWithString:cookerStar.videoCover];
        cookerStar.chefBackgroundImageUrl = [cookerDict[@"chefBackgroundImage"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"chefBackgroundImage"]];
        cookerStar.chefBackgroundImageUrl = [DataParser parseImageUrlWithString:cookerStar.chefBackgroundImageUrl];
        
        cookerStar.cookbookAmount = [cookerDict[@"cookbookAmount"] isKindOfClass:[NSNull class]] ? 0 : [cookerDict[@"cookbookAmount"] integerValue];
        cookerStar.userLevel = [cookerDict[@"userLevel"] isKindOfClass:[NSNull class]] ? 0 : [cookerDict[@"userLevel"] integerValue];
        cookerStar.isFollowed = [cookerDict[@"isFollowed"] integerValue] == 0 ? NO : YES;
        cookerStar.userBaseId = [cookerDict[@"userBaseID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookerDict[@"userBaseID"]];
        
        [cookerStars addObject:cookerStar];
    }
    
    
    return cookerStars;
}

+ (NSMutableArray*)parseMessagesWithDict:(NSDictionary*)dict
{
    NSMutableArray* messages = [NSMutableArray array];
    
    NSDictionary* dataDict = dict[@"data"];
    
    if ([dataDict isKindOfClass:[NSNull class]]) {
        return messages;
    }
    
    NSArray* messageArr = dataDict[@"items"];
    
    for (NSDictionary* messageDict in messageArr) {
        
        Message* message = [[Message alloc] init];
        message.ID = [messageDict[@"messageID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", messageDict[@"messageID"]];
        message.createdTime = [messageDict[@"createdTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", messageDict[@"createdTime"]];
        //message.createdTime = [DataParser parseTime:message.createdTime];
        message.isRead = [messageDict[@"isRead"] integerValue] == 0 ? NO : YES;
        message.content = [messageDict[@"messageContent"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", messageDict[@"messageContent"]];
        
        message.fromUser = [DataParser parseCommentUserWithDict:messageDict[@"messageFrom"]];
        message.toUser = [DataParser parseCommentUserWithDict:messageDict[@"messageTo"]];
        
        [messages addObject:message];
    }
    
    
    return messages;
}

+ (NSMutableArray*)parseEquipmentsWithDict:(NSDictionary*)dict
{
    NSMutableArray* equipments = [NSMutableArray array];
    
    NSDictionary* jsonData = dict[@"data"];
    
    if ([jsonData isKindOfClass:[NSNull class]]) {
        return equipments;
    }
    
    NSArray* equipmentArr = jsonData[@"items"];
    
    for (NSDictionary* equipmentDict in equipmentArr) {
        
        Equipment* equipment = [[Equipment alloc] init];
        
        equipment.category = [equipmentDict[@"category"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", equipmentDict[@"category"]];
        equipment.productId = [equipmentDict[@"productID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", equipmentDict[@"productID"]];
        equipment.price = [equipmentDict[@"price"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", equipmentDict[@"price"]];
        equipment.name = [equipmentDict[@"productName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", equipmentDict[@"productName"]];
        equipment.url = [equipmentDict[@"productURL"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", equipmentDict[@"productURL"]];
        equipment.imagePath = [equipmentDict[@"productImage"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", equipmentDict[@"productImage"]];
        equipment.imagePath = [DataParser parseImageUrlWithString:equipment.imagePath];
        
        
        [equipments addObject:equipment];
        
    }
    
    
    
    return equipments;
}

+ (NSMutableArray*)parseNotificationListWithDict:(NSDictionary*)dict
{
    NSMutableArray* notificationList = [NSMutableArray array];
    
    NSDictionary* jsonData = dict[@"data"];
    
    if ([jsonData isKindOfClass:[NSNull class]]) {
        return notificationList;
    }
    
    NSArray* notificationArr = jsonData[@"items"];
    
    for (NSDictionary* notificationDict in notificationArr) {
        
        NoticeInfo* notice = [[NoticeInfo alloc] init];
        
        notice.createdTime = [notificationDict[@"createdTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", notificationDict[@"createdTime"]];
        notice.createdTime = [DataParser parseTime:notice.createdTime];
        notice.ID = [notificationDict[@"noticficationID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", notificationDict[@"noticficationID"]];
        notice.type = [notificationDict[@"noticficationType"] integerValue];
        notice.objectID = [notificationDict[@"objectID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", notificationDict[@"objectID"]];
        notice.promoter = [DataParser parseCommentUserWithDict:notificationDict[@"promoter"]];
        notice.relatedDesc = [notificationDict[@"relatedDesc"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", notificationDict[@"relatedDesc"]];
        notice.relatedId = [notificationDict[@"relatedID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", notificationDict[@"relatedID"]];
        
        [notificationList addObject:notice];
    }
    
    
    return notificationList;
}

@end

































