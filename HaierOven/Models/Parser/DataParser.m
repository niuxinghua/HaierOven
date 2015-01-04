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

@class Food, Creator, Step;

@implementation DataParser

+ (User*)parseUserWithDict:(NSDictionary*)dict
{
    NSDictionary* userDict = dict[@"data"];
    
    User* user = [DataParser parseUserWithDict:userDict];
    
    return user;
}

+ (User*)parseUserInfoWithDict:(NSDictionary*)userDict
{
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

+ (NSMutableArray*)parseUsersWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage
{
    NSDictionary* dataDict = dict[@"data"];
    *hadNextPage = [dataDict[@"hasNextPage"] boolValue];
    
    NSMutableArray* follows = [NSMutableArray array];
    
    NSArray* followsArr = dataDict[@"items"];
    for (NSDictionary* userDict in followsArr) {
        User* user = [DataParser parseUserWithDict:userDict];
        [follows addObject:user];
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
    
    creator.ID              = [creatorDict[@"id"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", creatorDict[@"id"]];
    creator.userName        = [creatorDict[@"userName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", creatorDict[@"userName"]];
    NSString* avatarPath    = [creatorDict[@"userAvatar"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", creatorDict[@"userAvatar"]];
    creator.avatarPath      = [DataParser parseImageUrlWithString:avatarPath];
    
    return creator;
}

+ (NSMutableArray*)parseCookbooksWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage
{
    NSMutableArray* cookbooks = [NSMutableArray array];
    
    NSDictionary* dataDict = dict[@"data"];
    *hadNextPage = [dataDict[@"hasNextPage"] boolValue];
    
    NSArray* cookbooksArr = dataDict[@"items"];
    for (NSDictionary* cookbookDict in cookbooksArr) {
        Cookbook* cookbook = [[Cookbook alloc] init];
        
        cookbook.ID             = [cookbookDict[@"cookbookID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookID"]];
        cookbook.name           = [cookbookDict[@"cookbookName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookName"]];
        cookbook.desc           = [cookbookDict[@"cookbookDesc"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookDesc"]];
        NSString* coverPhoto     = [cookbookDict[@"cookbookCoverPhoto"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"cookbookCoverPhoto"]];
        cookbook.coverPhoto     = [DataParser parseImageUrlWithString:coverPhoto];
        cookbook.modifiedTime   = [cookbookDict[@"modifiedTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"modifiedTime"]];
        NSDictionary* creatDict = cookbookDict[@"creator"];
        cookbook.creator        = [DataParser parseCreatorWithDict:creatDict];
        cookbook.praises        = [cookbookDict[@"praises"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", cookbookDict[@"praises"]];
        
        [cookbooks addObject:cookbook];
    }
    
    return cookbooks;
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
    
    cookbookDetail.cookbookId       = [detailDict[@"cookbookID"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookID"]];
    cookbookDetail.name             = [detailDict[@"cookbookName"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookName"]];
    cookbookDetail.desc             = [detailDict[@"cookbookDesc"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookDesc"]];
    NSString* coverPhoto       = [detailDict[@"cookbookCoverPhoto"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookCoverPhoto"]];
    cookbookDetail.coverPhoto       = [DataParser parseImageUrlWithString:coverPhoto];
    cookbookDetail.cookbookTip      = [detailDict[@"cookbookTip"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"cookbookTip"]];
    cookbookDetail.status           = [detailDict[@"status"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"status"]];
    cookbookDetail.praised          = [detailDict[@"praised"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"praised"]];
    cookbookDetail.modifiedTime     = [detailDict[@"modifiedTime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", detailDict[@"modifiedTime"]];
    
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
    cookbookDetail.oven             = oven;
    
    cookbookDetail.creator          = [DataParser parseCreatorWithDict:detailDict[@"creator"]];
    
    return cookbookDetail;
}

@end

































