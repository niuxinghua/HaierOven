//
//  CookStarDetailController.m
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookStarDetailController.h"
#import "CookStarDetailTopView.h"
#import "CookerStarTopWithoutVideoView.h"
#import "MainViewNormalCell.h"
#import "AutoSizeLabelView.h"
#import "ChatViewController.h"
#import "MJRefresh.h"
#import "CookbookDetailControllerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "StudyCookViewController.h"

#import "MainSearchViewController.h"
#import "UpLoadingMneuController.h"

@interface CookStarDetailController () <CookStarDetailTopViewDelegate, CookerStarTopWithoutVideoViewDelegate>
{
    CGSize movesize;
    CGFloat topViewHight;
    BOOL isfiex;
}

@property (strong, nonatomic) IBOutlet UITableView *mainTable;

/**
 *  有视频
 */
@property (strong, nonatomic) CookStarDetailTopView* cookStarDetailTopView;

/**
 *  无视频
 */
@property (strong, nonatomic) CookerStarTopWithoutVideoView* cookStarTopView;

/**
 *  是否有视频
 */
@property (nonatomic) BOOL hadVideo;


@property (strong, nonatomic) NSString *decString;

@property (strong, nonatomic) NSMutableArray *tags;

@property (strong, nonatomic) UIButton *tempBtn;

@property (strong, nonatomic) NSMutableArray* cookbooks;

@property (nonatomic) NSInteger pageIndex;

/**
 *  选中的tagID
 */
@property (strong, nonatomic) NSMutableArray* tagArr;

/**
 *  是否选择了标签
 */
@property (nonatomic) BOOL selectedTagsFlag;

@property (strong, nonatomic) MPMoviePlayerController* player;

@property (strong, nonatomic) NSMutableArray* messages;

@property (strong, nonatomic) UIImage* myAvatar;

@end

@implementation CookStarDetailController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.tags = [NSMutableArray array];
        self.cookbooks = [NSMutableArray array];
        self.pageIndex = 1;
    }
    return self;
}

#pragma mark - 网络请求

- (void)loadCookerStarTags
{
    [[InternetManager sharedManager] getUserTagsWithUserBaseId:self.cookerStar.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            self.tags = obj;
            
            NSMutableArray* tagNames = [NSMutableArray array];
            for (Tag* tag in obj) {
                [tagNames addObject:tag.name];
            }
            self.cookStarDetailTopView.tags = tagNames;
            self.cookStarTopView.tags = tagNames;
            
            CGRect frameOfHeader = self.cookStarDetailTopView.frame;
            frameOfHeader.size.height =[self getHeight];
            self.cookStarDetailTopView.frame = frameOfHeader;
            
            frameOfHeader = self.cookStarTopView.frame;
            frameOfHeader.size.height = [self getHeight];
            self.cookStarTopView.frame = frameOfHeader;
            
            self.mainTable.tableHeaderView = self.hadVideo ? self.cookStarDetailTopView : self.cookStarTopView;
            //self.cookStarDetailTopView.tags = tagNames;
        }else {
            [super showProgressErrorWithLabelText:@"获取标签失败" afterDelay:1];
        }
    }];
}

- (void)loadUserCookbooksWithTags
{
    if (_pageIndex == 1) {
        [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    }
    
    [[InternetManager sharedManager] getCookbooksWithTagIds:self.tagArr userBaseId:self.cookerStar.userBaseId pageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _pageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
                //[self.mainTable.legendFooter noticeNoMoreData];
            }
            if (arr.count == 0 && _pageIndex == 1) {
                [super showProgressErrorWithLabelText:@"对不起，没有所选信息！" afterDelay:1];
            }
            if (_pageIndex == 1) {
                self.cookbooks = obj;
            } else {
                [self.cookbooks addObjectsFromArray:arr];
            }
            
            [self.mainTable reloadData];
            
        } else {
            [super showProgressErrorWithLabelText:@"获取菜谱失败" afterDelay:1];
        }
    }];
}

- (void)loadUserCookbooks
{
    //统计页面加载耗时
    UInt64 startTime=[[NSDate date]timeIntervalSince1970]*1000;
    if (_pageIndex == 1) {
        [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    }
    
    [[InternetManager sharedManager] getCookbooksWithUserBaseId:self.cookerStar.userBaseId cookbookStatus:1 pageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _pageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
                //[self.mainTable.legendFooter noticeNoMoreData];
            }
            if (_pageIndex == 1) {
                self.cookbooks = obj;
            } else {
                [self.cookbooks addObjectsFromArray:arr];
            }
            
            [self.mainTable reloadData];
            
            UInt64 endTime=[[NSDate date]timeIntervalSince1970]*1000;
            [uAnalysisManager onActivityResumeEvent:((long)(endTime-startTime)) withModuleId:@"厨神详情页面"];
            
        } else {
            [super showProgressErrorWithLabelText:@"获取菜谱失败" afterDelay:1];
        }
        
    }];
    
//    [[InternetManager sharedManager] getFriendCookbooksWithUserBaseId:self.cookerStar.userBaseId pageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
//        
//        if (success) {
//            NSArray* arr = obj;
//            if (arr.count < PageLimit && _pageIndex != 1) {
//                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
//            }
//            if (_pageIndex == 1) {
//                self.cookbooks = obj;
//            } else {
//                [self.cookbooks addObjectsFromArray:arr];
//            }
//            
//            [self.mainTable reloadData];
//        } else {
//            [super showProgressErrorWithLabelText:@"获取菜谱失败" afterDelay:1];
//        }
//        
//        
//    }];
    
}

- (void)loadMyImage
{
    if (_myAvatar == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            _myAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DataCenter sharedInstance].currentUser.userAvatar]]];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetUpSubviews];
    self.mainTable.delegate = self;
    self.mainTable.dataSource  = self;
    [self addFooter];
    [self updateUI];
    [self loadMyImage];
    
    [MobClick event:@"cookerStar_detail" attributes:@{@"厨神姓名" : self.cookerStar.userName}];
    
    // Do any additional setup after loading the view.
}

- (void)updateUI
{
    self.cookStarDetailTopView.cookerStar = self.cookerStar;
    self.cookStarTopView.cookerStar = self.cookerStar;
    [self loadCookerStarTags];
    [self loadUserCookbooks];
}

-(void)SetUpSubviews{
    self.decString = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    movesize = [MyUtils getTextSizeWithText:self.decString andTextAttribute:@{NSFontAttributeName:[UIFont fontWithName:GlobalTitleFontName size:11.5]} andTextWidth:PageW-32];
    
    self.hadVideo = [self.cookerStar.videoPath hasPrefix:@"http"];
    
    topViewHight = [self getHeight];
    
    self.cookStarDetailTopView = [[CookStarDetailTopView alloc] initWithFrame:CGRectMake(0, 0, PageW, topViewHight-36)];
    
    self.cookStarDetailTopView.delegate = self;
    
    self.cookStarTopView = [[CookerStarTopWithoutVideoView alloc] initWithFrame:CGRectMake(0, 0, PageW, topViewHight - 36)];
    self.cookStarTopView.delegate = self;
    
    self.mainTable.tableHeaderView = self.hadVideo ? self.cookStarDetailTopView : self.cookStarTopView;
    
    [self.mainTable registerNib:[UINib nibWithNibName:NSStringFromClass([MainViewNormalCell class]) bundle:nil] forCellReuseIdentifier:@"MainViewNormalCell"];
    self.cookStarDetailTopView.tags = self.tags;
    self.cookStarTopView.tags = self.tags;
    
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.mainTable addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        vc.pageIndex = 1;
        if (vc.selectedTagsFlag) {
            [vc loadUserCookbooksWithTags];
        } else {
            [vc loadUserCookbooks];
        }
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.mainTable headerEndRefreshing];
            
        });
        
    }];
    
}


- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.mainTable addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        vc.pageIndex++;
        //[vc loadUserCookbooks];
        
        if (vc.selectedTagsFlag) {
            [vc loadUserCookbooksWithTags];
        } else {
            [vc loadUserCookbooks];
        }
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.mainTable footerEndRefreshing];
            
        });
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.cookbooks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier =@"MainViewNormalCell";
    MainViewNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = GlobalGrayColor;
    cell.AuthorityLabel.hidden = YES;
    cell.cookbook = self.cookbooks[indexPath.row];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PageW*0.8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Cookbook* selectedCookbook = self.cookbooks[indexPath.row];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
    CookbookDetailControllerViewController* detailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
    detailController.cookbookId = selectedCookbook.ID;
    detailController.isAuthority = selectedCookbook.isAuthority;
    [self.navigationController pushViewController:detailController animated:YES];
}


#pragma mark-  TopViewDelegate

-(void)ponnedHeadView:(NSInteger)height top:(NSInteger)top AndBottom:(NSInteger)Bottom{
    
    if (height>topViewHight) {
        height=topViewHight;
    }else if (height<445+movesize.height){
        height=445+movesize.height;
    }
    self.cookStarDetailTopView.height = height;
//    self.mainTable.tableHeaderView = self.cookStarDetailTopView;
}


-(void)follow:(UIButton *)sender{
  
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    if ([self.cookerStar.userBaseId isEqualToString:CurrentUserBaseId]) {
        [super showProgressErrorWithLabelText:@"不能关注自己" afterDelay:1];
        return;
    }
    NSString* userBaseId = CurrentUserBaseId;
    if (sender.selected) {
        // 已关注，取消关注
        [[InternetManager sharedManager] deleteFollowWithUserBaseId:userBaseId andFollowedUserBaseId:self.cookerStar.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                NSLog(@"取消关注成功");
                [super showProgressCompleteWithLabelText:@"取消关注" afterDelay:1];
                sender.selected = NO;
                if ([self.delegate respondsToSelector:@selector(cookerStarDidFollowd)]) {
                    [self.delegate cookerStarDidFollowd];
                }
            } else {
                [super showProgressErrorWithLabelText:@"取消失败" afterDelay:1];
            }
        }];
    } else {
        // 未关注，添加关注
        [[InternetManager sharedManager] addFollowWithUserBaseId:userBaseId andFollowedUserBaseId:self.cookerStar.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                NSLog(@"关注成功");
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"Masterchef %@ Detail", self.cookerStar.userName]     // Event category (required)
                                                                      action:@"follow"    // Event action (required)
                                                                       label:nil          // Event label
                                                                       value:nil] build]];    // Event value
                
                [super showProgressCompleteWithLabelText:@"已关注" afterDelay:1];
                sender.selected = YES;
                if ([self.delegate respondsToSelector:@selector(cookerStarDidFollowd)]) {
                    [self.delegate cookerStarDidFollowd];
                }
            } else {
                [super showProgressErrorWithLabelText:@"关注失败" afterDelay:1];
            }
        }];
    }
    
    //sender.selected = !sender.selected;
    
    
}
-(void)leaveMessage{
    
    NSLog(@"留言");
    
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    
    if ([self.cookerStar.userBaseId isEqualToString:CurrentUserBaseId]) {
        [super showProgressErrorWithLabelText:@"不能给自己留言" afterDelay:1];
        return;
    }
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"Masterchef %@ Detail", self.cookerStar.userName]     // Event category (required)
                                                          action:@"leave a message"    // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
    ChatViewController* chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"Chat view controller"];
    chatViewController.toUserId = self.cookerStar.userBaseId;
//    chatViewController.messages = self.messages;
    chatViewController.toUserName = self.cookerStar.userName;
    chatViewController.toUserAvatar = self.cookStarDetailTopView.avaterImage.image;
    chatViewController.myAvatar = self.myAvatar;
    [self.navigationController pushViewController:chatViewController animated:YES];
    
    
}
-(void)playVideo{
   
    NSURL* url = [NSURL URLWithString:self.cookerStar.videoPath];
    NSLog(@"%@",self.cookerStar.videoPath);
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.player.view.frame = self.cookStarDetailTopView.vedioImage.frame;
    [self.cookStarDetailTopView addSubview:self.player.view];
    [self.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allowLandscape:) name:MPMoviePlayerWillEnterFullscreenNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notAllowLandscape:) name:MPMoviePlayerWillExitFullscreenNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame:) name:MPMoviePlayerDidExitFullscreenNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"Masterchef %@ Detail", self.cookerStar.userName]     // Event category (required)
                                                          action:@"video"    // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    
}

- (void)allowLandscape:(NSNotification*)notification
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.orientationState = InterfaceOrientationStateNormal;
    
}

- (void)notAllowLandscape:(NSNotification*)notification
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.orientationState = InterfaceOrientationStatePortraitOnly;
    
}

- (void)changeFrame:(NSNotification*)notification
{
    self.player.view.frame = self.cookStarDetailTopView.vedioImage.frame;
}

- (void)close:(NSNotification*)sender
{
    [self.player stop];
    [self.player.view removeFromSuperview];
//    self.player.view.frame = self.cookStarDetailTopView.vedioImage.frame;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:self.player];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)studyCook{
    NSLog(@"新手学烘焙");
    StudyCookViewController* studyController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyCookViewController"];
    [self.navigationController pushViewController:studyController animated:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"Masterchef %@ Detail", self.cookerStar.userName]     // Event category (required)
                                                          action:@"study baking"    // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
}

/**
 *  选择了标签
 *
 *  @param btn 标签按钮
 */
-(void)chickTags:(UIButton*)btn
{
    self.selectedTagsFlag = YES;
    
    btn.selected = !btn.selected;
    self.tempBtn = btn;
    
    // 拿到选中的tag的ID
    NSMutableArray* tagArr = [NSMutableArray array];
    self.tagArr = tagArr;
    if (self.hadVideo) {
        for (UIButton* tagButton in self.cookStarDetailTopView.tagsView.subviews) {
            if (tagButton.selected) {
                Tag* tag = self.tags[tagButton.tag];
                [tagArr addObject:tag.ID];
            }
        }
    } else {
        for (UIButton* tagButton in self.cookStarTopView.tagsView.subviews) {
            if (tagButton.selected) {
                Tag* tag = self.tags[tagButton.tag];
                [tagArr addObject:tag.ID];
            }
        }
    }
    
    _pageIndex = 1;
    
    if (tagArr.count == 0) {
//        [super showProgressErrorWithLabelText:@"请至少选择一个标签" afterDelay:1];
//        self.tempBtn.selected = YES;
//        Tag* tag = self.tags[self.tempBtn.tag];
//        [tagArr addObject:tag.ID];
//        return;
        self.selectedTagsFlag = NO;
        [self loadUserCookbooks];
    } else {
        [self loadUserCookbooksWithTags];
    }
    
}

#define PADDING_WIDE    15   //标签左右间距
#define PADDING_HIGHT    8   //标签上下间距
#define LABEL_H    20   //标签high


-(float)getHeight{
    
    float height = 0.0;
    
    if (self.hadVideo) {
        
        if (self.cookStarDetailTopView.descriptionLabel.text.length==0) {
            height -= 16;
        }
        
        height += [MyUtils getTextSizeWithText:self.cookerStar.introduction andTextAttribute:@{NSFontAttributeName: [UIFont fontWithName:GlobalTextFontName size:11.5]} andTextWidth:Main_Screen_Width - 32].height;
        
        self.cookStarDetailTopView.tagsView.frame = CGRectMake(15, 20+8+8, Main_Screen_Width - 30, (LABEL_H + PADDING_HIGHT));
        
        height += 188 + 8; // 厨神简介顶部距离 + 下边距
        
        height += (Main_Screen_Width - 70) / 5 * 3; //视频高度
        height += 8;  //视频下边距
        
        
        height += 31 + 8; //新手学烘焙下边距
        
        //height += 35;   //额外添加
        
        height += 8 + 20 + 8;   //厨神姓名高度
        
        height += LABEL_H + PADDING_HIGHT;
        
        height += 30;   //下拉label
        
        if (self.cookStarDetailTopView.tagsView.lineCount==1) {
            height -= 30;
        }
        
    } else {
        
        if (self.cookStarTopView.descriptionLabel.text.length == 0) {
            height -= 16;
        }
        
        height += [MyUtils getTextSizeWithText:self.cookerStar.introduction andTextAttribute:@{NSFontAttributeName: [UIFont fontWithName:GlobalTextFontName size:11.5]} andTextWidth:Main_Screen_Width - 32].height;
        
        self.cookStarTopView.tagsView.frame = CGRectMake(15, 20+8+8, Main_Screen_Width - 30, (LABEL_H + PADDING_HIGHT));
        
        height += 188 + 8; // 厨神简介顶部距离 + 下边距
        
        height += 31 + 8; //新手学烘焙下边距
        
        //height += 35;   //额外添加
        
        height += 8 + 20 + 8;   //厨神姓名高度
        
        height += LABEL_H + PADDING_HIGHT;
        
        height += 30;   //下拉label
        
        if (self.cookStarTopView.tagsView.lineCount == 1) {
            height -= 30;
        }
        
    }
    
    return height;
}

/**
 *  无视频播放View
 *
 *  @return <#return value description#>
 */
- (void)updateHeadViewHeight:(CGFloat)height
{
    
    if (!isfiex) {
        float updateHeight = [self getHeight];
        
        //    updateHeight += self.cookStarDetailTopView.tagsView.lineCount * (PADDING_HIGHT + LABEL_H);
        updateHeight += (self.cookStarTopView.tagsView.lineCount - 1) * (PADDING_HIGHT + LABEL_H);
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect frameOfHeader = self.cookStarTopView.frame;
            frameOfHeader.size.height = updateHeight;
            self.cookStarTopView.frame = frameOfHeader;
            
            CGFloat heightOfContainer = self.cookStarTopView.tagsView.lineCount * (PADDING_HIGHT + LABEL_H) + 30 + 30;
            self.cookStarTopView.backDownView.frame = CGRectMake(0, self.cookStarTopView.studyCook.bottom + 8, Main_Screen_Width,heightOfContainer);
            
            self.cookStarTopView.tagsView.frame = CGRectMake(15, 38, Main_Screen_Width - 30, self.cookStarTopView.tagsView.lineCount * (PADDING_HIGHT + LABEL_H));
            self.cookStarTopView.bottomView.frame = CGRectMake(0, self.cookStarTopView.tagsView.bottom, Main_Screen_Width, 56);
            
            self.cookStarTopView.frame = CGRectMake(0, 0, Main_Screen_Width, updateHeight);
            
            self.mainTable.tableHeaderView = self.cookStarTopView;
        }];
        
        
    } else {
        float updateHeight = [self getHeight];
        
        //        updateHeight +=  (PADDING_HIGHT + LABEL_H);
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect frameOfHeader = self.cookStarTopView.frame;
            frameOfHeader.size.height = updateHeight;
            self.cookStarTopView.frame = frameOfHeader;
            
            CGFloat heightOfContainer = (PADDING_HIGHT + LABEL_H) + 30 + 30;
            self.cookStarTopView.backDownView.frame = CGRectMake(0, self.cookStarTopView.studyCook.bottom + 8, Main_Screen_Width,heightOfContainer);
            
            self.cookStarTopView.tagsView.frame = CGRectMake(15, 38, Main_Screen_Width - 30,  (PADDING_HIGHT + LABEL_H));
            self.cookStarTopView.bottomView.frame = CGRectMake(0, self.cookStarTopView.tagsView.bottom, Main_Screen_Width, 56);
            
            self.cookStarTopView.frame = CGRectMake(0, 0, Main_Screen_Width, updateHeight);
            
            self.mainTable.tableHeaderView = self.cookStarTopView;
        }];
        
        
    }
    
    
    isfiex = !isfiex;
    
}

/**
 *  有视频播放View
 *
 *  @param height <#height description#>
 */
-(void)UpLoadHeadViewHeight:(CGFloat)height{


    if (!isfiex) {
        float updateHeight = [self getHeight];

        //    updateHeight += self.cookStarDetailTopView.tagsView.lineCount * (PADDING_HIGHT + LABEL_H);
        updateHeight += (self.cookStarDetailTopView.tagsView.lineCount - 1) * (PADDING_HIGHT + LABEL_H);
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect frameOfHeader = self.cookStarDetailTopView.frame;
            frameOfHeader.size.height = updateHeight;
            self.cookStarDetailTopView.frame = frameOfHeader;
            
            CGFloat heightOfContainer = self.cookStarDetailTopView.tagsView.lineCount * (PADDING_HIGHT + LABEL_H) + 30 + 30;
            self.cookStarDetailTopView.backDownView.frame = CGRectMake(0, self.cookStarDetailTopView.studyCook.bottom + 8, Main_Screen_Width,heightOfContainer);
            
            self.cookStarDetailTopView.tagsView.frame = CGRectMake(15, 38, Main_Screen_Width - 30, self.cookStarDetailTopView.tagsView.lineCount * (PADDING_HIGHT + LABEL_H));
            self.cookStarDetailTopView.bottomView.frame = CGRectMake(0, self.cookStarDetailTopView.tagsView.bottom, Main_Screen_Width, 56);
            
            self.cookStarDetailTopView.frame = CGRectMake(0, 0, Main_Screen_Width, updateHeight);
            
            self.mainTable.tableHeaderView = self.cookStarDetailTopView;
        }];
        

    } else {
        float updateHeight = [self getHeight];

//        updateHeight +=  (PADDING_HIGHT + LABEL_H);
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect frameOfHeader = self.cookStarDetailTopView.frame;
            frameOfHeader.size.height = updateHeight;
            self.cookStarDetailTopView.frame = frameOfHeader;
            
            CGFloat heightOfContainer = (PADDING_HIGHT + LABEL_H) + 30 + 30;
            self.cookStarDetailTopView.backDownView.frame = CGRectMake(0, self.cookStarDetailTopView.studyCook.bottom + 8, Main_Screen_Width,heightOfContainer);
            
            self.cookStarDetailTopView.tagsView.frame = CGRectMake(15, 38, Main_Screen_Width - 30,  (PADDING_HIGHT + LABEL_H));
            self.cookStarDetailTopView.bottomView.frame = CGRectMake(0, self.cookStarDetailTopView.tagsView.bottom, Main_Screen_Width, 56);
            
            self.cookStarDetailTopView.frame = CGRectMake(0, 0, Main_Screen_Width, updateHeight);
            
            self.mainTable.tableHeaderView = self.cookStarDetailTopView;
        }];

        
    }
    
    
    isfiex = !isfiex;
//    [self.cookStarDetailTopView setNeedsLayout];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
