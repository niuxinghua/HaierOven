//
//  CreatMneuController.m
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CreatMneuController.h"
#import "CoverCell.h"
#import "ChooseTagsCell.h"
#import "AutoSizeLabelView.h"
#import "CellOfAddFoodTable.h"
#import "AddFoodAlertView.h"
#import "UseDeviceCell.h"
#import "AddStepCell.h"
#import "ChooseCoverView.h"
#import "YIPopupTextView.h"
#import "BottomCell.h"
#import "CookbookDetailControllerViewController.h"
#import "PECropViewController.h"

@interface CreatMneuController ()<AutoSizeLabelViewDelegate,CellOfAddFoodTableDelegate,AddFoodAlertViewDelegate,AddStepCellDelegate,ChooseCoverViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YIPopupTextViewDelegate,CoverCellDelegate,PECropViewControllerDelegate,UseBakeViewDelegate>
{
    CGRect alertRectShow;
    CGRect alertRectHidden;
    BOOL useBake;
}

@property (strong, nonatomic) NSMutableArray *foods;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) AddFoodAlertView *addFoodAlertView;
@property (strong, nonatomic) NSMutableArray *steps;
@property (strong, nonatomic) ChooseCoverView  *chooseCoverView;
@property (strong, nonatomic) UIImageView *tempImageView; //记录 添加步骤 delegate 上来的图片
@property (strong, nonatomic) UILabel *tempLabel; //记录 添加步骤 delegate 上来的图片
@property (strong, nonatomic) NSString *myPs_String;
@property (strong, nonatomic) AutoSizeLabelView *tagsView;
@property float tagsCellHight;
@property float psCellHight;
@property (strong, nonatomic) NSMutableArray*  tagsForTagsView;
@property (strong, nonatomic) NSMutableArray* selectedTags;
@property (strong, nonatomic) UIImage *peTempImage;//剪切暂存图片
@property (strong, nonatomic) YIPopupTextView* popupTextView;
@property BOOL ischangeCover;

/**
 *  当前编辑的步骤
 */
@property (strong, nonatomic) Step* edittingStep;

/**
 *  当前编辑的食材
 */
@property (strong, nonatomic) Food* edittingFood;



#pragma mark - outlets


@end
#define PADDING_WIDE    15   //标签左右间距
#define PADDING_HIGHT    8   //标签上下间距
#define LABEL_H    20   //标签high

@implementation CreatMneuController
@synthesize popupTextView;
#pragma mark - 加载系列

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.tags = [NSMutableArray array];
        self.cookbookDetail.tags = self.tags;
        self.selectedTags = [NSMutableArray array];
        
        self.foods = [NSMutableArray new];
        self.cookbookDetail.foods = self.foods;
        self.steps = [NSMutableArray new];
        
        Step* step = [[Step alloc] init];
        self.cookbookDetail.steps = self.steps;
        [self.steps addObject:step];
        
        step.index = [NSString stringWithFormat:@"%d", self.steps.count];
        
        Food* food = [[Food alloc] init];
        [self.foods addObject:food];
        food.index = [NSString stringWithFormat:@"%d", self.foods.count];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    
    if (self.isDraft) {
        [self loadCookbookDetail];
    }
    
}

- (void)loadCookbookDetail
{
    NSString* userId = CurrentUserBaseId;
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] getCookbookDetailWithCookbookId:self.cookbook.ID userBaseId:userId callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            self.cookbookDetail = obj;
            
            // 需要将图片完整的路径转换为服务器保存的图片的相对路径，也就是需要去掉图片的BaseOvenUrl
            
            NSRange range = [self.cookbookDetail.coverPhoto rangeOfString:[BaseOvenUrl lastPathComponent]];
            self.cookbookDetail.coverPhoto = [self.cookbookDetail.coverPhoto substringFromIndex:range.location+range.length];
            self.steps = [self.cookbookDetail.steps mutableCopy];
            for (Step* step in self.steps) {
                range = [step.photo rangeOfString:[BaseOvenUrl lastPathComponent]];
                step.photo = [step.photo substringFromIndex:range.location+range.length];
            }
            self.selectedTags = [self.cookbookDetail.tags mutableCopy];
            self.foods = [self.cookbookDetail.foods mutableCopy];
            self.myPs_String = self.cookbookDetail.cookbookTip;
            [self.tableView reloadData];
        } else {
            [super showProgressErrorWithLabelText:@"获取菜谱信息失败" afterDelay:1];
        }
        
    }];
}


-(void)SetUpSubviews{
    
//    self.tags =  [@[@"烘焙",@"蒸菜",@"微波炉",@"巧克力",@"面包",@"饼干海鲜",@"有五个字呢",@"四个字呢",@"三个字呢",@"没规律呢",@"都能识别的呢",@"鱼",@"零食",@"早点",@"海鲜"] mutableCopy];
    self.tagsForTagsView = [NSMutableArray array];
    for (Tag* tag in self.tags) {
        [self.tagsForTagsView addObject:tag.name];
    }
    
    self.tagsCellHight = [self getHeight];
    self.psCellHight = 210;
    
//    self.tagsView = [AutoSizeLabelView new];
//    self.tagsView.tags = [self.tags copy];
//    
    
    

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellOfAddFoodTable class]) bundle:nil] forCellReuseIdentifier:@"CellOfAddFoodTable"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddStepCell class]) bundle:nil] forCellReuseIdentifier:@"AddStepCell"];
    
    
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 0, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;
    
    
    alertRectHidden = CGRectMake(PageW/2, PageH/2, 0, 0);
    alertRectShow = CGRectMake(15, (PageH-138)/2, PageW-30, 138);
    
    self.addFoodAlertView = [[AddFoodAlertView alloc]initWithFrame:alertRectHidden];
    self.addFoodAlertView.delegate = self;
    [self.myWindow addSubview:self.addFoodAlertView];
    
    self.chooseCoverView = [[ChooseCoverView alloc]initWithFrame:CGRectMake(0, PageH, PageW, PageW*0.58)];
    self.chooseCoverView.delegate = self;
    [self.myWindow addSubview:self.chooseCoverView];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 显示系列

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [popupTextView resignFirstResponder];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.row ==0) {
            CoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoverCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.coverImage = self.cookbookCoverPhoto;
            return cell;
            
        }else if(indexPath.row ==1)  {
            ChooseTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseTagsCell" forIndexPath:indexPath];
            cell.tagsView.delegate = self;
            cell.cookName.text = self.cookbookDetail.name;
            NSMutableArray* sTags = [NSMutableArray array];
            for (Tag* tag in self.selectedTags) {
                [sTags addObject:tag.name];
            }
            self.tagsView.selectedTags = sTags;
            cell.tagsView.tags = self.tagsForTagsView;
            self.tagsView = cell.tagsView;
            
            return cell;
            
        }else if(indexPath.row == 2){
            CellOfAddFoodTable *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOfAddFoodTable" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.foods = [self.foods mutableCopy];
            cell.delegate = self;

            return cell;
        }else if(indexPath.row ==3){
            UseDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UseDeviceCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }else if(indexPath.row == 4){
            AddStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddStepCell" forIndexPath:indexPath];
            cell.steps = self.steps;
            cell.delegate = self;
            return cell;
        }else {
            BottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BottomCell" forIndexPath:indexPath];
            if (self.myPs_String.length >0 )
                cell.myPS_String = self.myPs_String;
            
            return cell;
        }
    // Configure the cell...    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return PageW*0.598;
            break;
        case 1:
            return self.tagsCellHight;
            break;
        case 2:
            return 40*(self.foods.count+1)+42+2;
//            return (PageW-16)*0.12*(self.foods.count+1)+45;
            break;
        case 3:
            if ([DataCenter sharedInstance].currentUser.level != 1 || [DataCenter sharedInstance].currentUser.level != 2) {
                //普通用户隐藏我使用了烤箱
                return 0;
            } else {
                return useBake?311:71;
            }
            
            break;
        case 4:
            return (PageW - 60)*0.58*(self.steps.count)+80;
            break;
            
        default:

            return self.psCellHight;
            break;
    }
}




#pragma mark- 添加食材cell delegate
-(void)reloadMainTableView:(NSMutableArray *)arr{
    self.foods = [arr mutableCopy];
    CGPoint point = self.tableView.contentOffset;

    [UIView animateWithDuration:0.3 animations:^{self.tableView.contentOffset = CGPointMake(0, point.y+(PageW-16)*0.13);
    }completion:nil];
    [self.tableView reloadData];
}
-(void)ImportAlertView:(UILabel *)label withFoodIndex:(NSInteger)foodIndex
{
    self.edittingFood = self.foods[foodIndex];
    self.addFoodAlertView.addFoodAlertType = label.tag;
    self.addFoodAlertView.label = label;
    self.myWindow.hidden = NO;

    [UIView animateWithDuration:0.2 animations:^{
        self.addFoodAlertView.frame = alertRectShow;
    } completion:^(BOOL finished) {
        
    }];

    
}
#pragma mark - 

- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加步骤cell delegate
-(void)AddStepOfMainTableView:(NSMutableArray *)arr{
    
    self.steps = [arr mutableCopy];
    CGPoint point = self.tableView.contentOffset;
    
    [UIView animateWithDuration:0.6 animations:^{self.tableView.contentOffset = CGPointMake(0, point.y+(PageW - 60)*0.58);
    }completion:nil];
    [self.tableView reloadData];
    
}
-(void)DeleteStepOfMainTableView:(NSMutableArray *)arr
{
    self.steps = [arr mutableCopy];
    CGPoint point = self.tableView.contentOffset;
    
    [UIView animateWithDuration:0.6 animations:^{self.tableView.contentOffset = CGPointMake(0, point.y-(PageW - 60)*0.58);
    }completion:nil];
    [self.tableView reloadData];
}


-(void)ImportStepDescription:(UILabel *)label withStepIndex:(NSInteger)index{
    self.edittingStep = self.steps[index];
    //添加表述
    popupTextView =
    [[YIPopupTextView alloc] initWithPlaceHolder:nil
                                        maxCount:120
                                     buttonStyle:YIPopupTextViewButtonStyleRightCancelAndDone];
    popupTextView.delegate = self;
    popupTextView.caretShiftGestureEnabled = YES;       // default = NO. using YISwipeShiftCaret is recommended.
    popupTextView.editable = YES;                  // set editable=NO to show without keyboard
    popupTextView.outerBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [popupTextView showInViewController:self];
    popupTextView.tag = 1;
    popupTextView.text = [label.text isEqualToString:@"文字说明"]?@"":label.text;
    self.tempLabel = label;
    NSLog(@"添加步骤描述");
}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
    if (cancelled) {
        NSLog(@"取消评论了");
    } else {
        if (text.length == 0) {
            return;
        }else{
            if (textView.tag ==1) { //步骤描述
                self.tempLabel.text = text;
                self.tempLabel.textColor = [UIColor darkGrayColor];
                self.edittingStep.desc = text;
            }else if (textView.tag==2){ //菜谱小贴士
                self.myPs_String = text;
                CGSize size = CGSizeZero;
                size = [MyUtils getTextSizeWithText:self.myPs_String andTextAttribute:@{NSFontAttributeName :[UIFont fontWithName:GlobalTitleFontName size:15]} andTextWidth:self.tableView.width-100];
                size.height = size.height<18?18:size.height;
                self.psCellHight =size.height+145;
            
                [self.tableView reloadData];
                
            } else if (textView.tag == 3) { //修改菜谱名称
                self.cookbookDetail.name = text;
                [self.tableView reloadData];
            }
        }
    }
}

-(void)AddStepImage:(UIImageView *)imageView withStepIndex:(NSInteger)index{
    self.edittingStep = self.steps[index];
    NSLog(@"添加图片");
    self.myWindow.hidden = NO;
    self.addFoodAlertView.hidden = YES;
    self.addFoodAlertView.frame = alertRectHidden;
    self.tempImageView = imageView;
    [UIView animateWithDuration:0.3 animations:^{[self.chooseCoverView setFrame:CGRectMake(0, PageH-PageW*0.58, PageW, PageW*0.58)];
    }completion:nil];
}

-(void)TakeCover:(NSInteger)tag{
    [UIView animateWithDuration:0.3 animations:^{[self.chooseCoverView setFrame:CGRectMake(0, PageH, PageW, PageW*0.58)];
    }completion:^(BOOL finished) {
        self.myWindow.hidden = YES;
        self.addFoodAlertView.frame = alertRectHidden;
        self.addFoodAlertView.hidden = NO;
        if (tag == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
                //摄像头
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
                
            }else{
                //如果没有提示用户
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
                [alert show];
            }
            
        }else if (tag == 2) {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            }
            pickerImage.delegate = self;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
        
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    self.peTempImage = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self openEditor];
    
}

#pragma mark-


#pragma mark- 自动标签delegate
-(void)chooseTags:(UIButton*)btn{
    
    
    Tag* theTag = [self.tags objectAtIndex:btn.tag];
    
    if (!btn.selected) {
        if (self.selectedTags.count > 2) {
            [super showProgressErrorWithLabelText:@"不能超过三个" afterDelay:1];
            btn.selected = NO;
            return;
        }
        [self.selectedTags addObject:theTag];
        
    } else {
        for (Tag* tag in self.selectedTags) {
            if ([tag.ID isEqualToString:theTag.ID]) {
                theTag = tag;
                break;
            }
        }
        [self.selectedTags removeObject:theTag];
    }
    btn.selected = !btn.selected;
    [self.tableView reloadData];
    NSLog(@"%d",btn.tag);
}
#pragma mark-

-(float)getHeight{
    float leftpadding = 0;
    int line = 1;
    int count = 0;
    for (int i = 0; i<self.tagsForTagsView.count; i++) {
        float wide  =  [AutoSizeLabelView boolLabelLength:self.tagsForTagsView[i] andAttribute:@{NSFontAttributeName: [UIFont fontWithName:GlobalTextFontName size:12]}]+20;
        
        if (leftpadding+wide+PADDING_WIDE*count>PageW-46) {
            leftpadding=0;
            ++line;
            count = 0;
        }
        
        leftpadding +=wide;
        count++;
    }
    
    return (PADDING_HIGHT+LABEL_H)*line+76;
}


#pragma mark- AddFoodAlertView 弹出框delegate
-(void)Cancel{
    self.myWindow.hidden = YES;
    self.addFoodAlertView.frame = alertRectHidden;
}

-(void)ChickAlert:(UILabel *)label andTextFailed:(UITextField *)textfield{
    label.text = textfield.text;
    label.textColor = [UIColor blackColor];
    self.myWindow.hidden = YES;
    self.addFoodAlertView.frame = alertRectHidden;
    [textfield resignFirstResponder];
    
    if (label.tag == 2) {
        self.edittingFood.name = label.text;
    }
    if (label.tag == 1) {
        self.edittingFood.desc = label.text;
    }

    
}


#pragma mark - 我使用了烤箱

- (IBAction)UseDevice:(UIButton*)sender {
    DataCenter* dataCenter = [DataCenter sharedInstance];
    if (dataCenter.currentUser.level != 1 || dataCenter.currentUser.level != 2) {
        [super showProgressErrorWithLabelText:@"只有厨神才可选择烤箱模式哦" afterDelay:1];
        return;
    }
    
    sender.selected = !sender.selected;
    useBake = !useBake;
    [self.tableView reloadData];
    NSLog(@"我使用了烤箱");
}

#pragma mark -


- (IBAction)modifyCookbookName:(UIButton *)sender
{
    popupTextView =
    [[YIPopupTextView alloc] initWithPlaceHolder:nil
                                        maxCount:120
                                     buttonStyle:YIPopupTextViewButtonStyleRightCancelAndDone];
    popupTextView.delegate = self;
    popupTextView.caretShiftGestureEnabled = YES;       // default = NO. using YISwipeShiftCaret is recommended.
    popupTextView.editable = YES;                  // set editable=NO to show without keyboard
    popupTextView.outerBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [popupTextView showInViewController:self];
    popupTextView.tag = 3;
    popupTextView.text = self.cookbook.name;
}

#pragma mark - 小贴士

- (IBAction)tipLabelTapped:(UITapGestureRecognizer *)sender {
    [self AddPS:nil];
}

- (IBAction)AddPS:(id)sender {
    popupTextView =
    [[YIPopupTextView alloc] initWithPlaceHolder:nil
                                        maxCount:120
                                     buttonStyle:YIPopupTextViewButtonStyleRightCancelAndDone];
    popupTextView.delegate = self;
    popupTextView.caretShiftGestureEnabled = YES;       // default = NO. using YISwipeShiftCaret is recommended.
    popupTextView.editable = YES;                  // set editable=NO to show without keyboard
    popupTextView.outerBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [popupTextView showInViewController:self];
    popupTextView.tag = 2;
    popupTextView.text = self.myPs_String;
}

- (IBAction)SaveToDraft:(id)sender {
    NSLog(@"存存存");
    self.cookbookDetail.status = @"0";
    if ([self validateCookbookDetail]) {
        [self submitCookbook];
    }
}

- (IBAction)Public:(id)sender {
    NSLog(@"发发发布");
    self.cookbookDetail.status = @"1";
    if ([self validateCookbookDetail]) {
        [self submitCookbook];
    }
    
}

/**
 *  检查菜谱信息是否完善
 *
 *  @return 是否完善
 */
- (BOOL)validateCookbookDetail
{
    if (self.selectedTags.count == 0) {
        [super showProgressErrorWithLabelText:@"请选择标签" afterDelay:1];
        return NO;
    }
    for (Food* food in self.foods) {
        if(food.name.length == 0) {
            [super showProgressErrorWithLabelText:@"请填写食材名称" afterDelay:1];
            return NO;
        } else if (food.desc.length == 0) {
            [super showProgressErrorWithLabelText:@"请填写食材用量" afterDelay:1];
            return NO;
        }
    }
    
    DataCenter* dataCenter = [DataCenter sharedInstance];
    if (dataCenter.currentUser.level == 1 || dataCenter.currentUser.level == 2) {
        
        if (self.cookbookDetail.oven.roastStyle.length == 0 || self.cookbookDetail.oven.roastTemperature.length == 0 || self.cookbookDetail.oven.roastTime.length == 0) {
            [super showProgressErrorWithLabelText:@"请选择使用烤箱信息" afterDelay:1];
            return NO;
        }
        
    } else {
        self.cookbookDetail.oven = nil;
    }
    
    
    for (Step* step in self.steps) {
        if (step.photo.length == 0) {
            [super showProgressErrorWithLabelText:@"请选择步骤图片" afterDelay:1];
            return NO;
        } else if (step.desc.length == 0) {
            [super showProgressErrorWithLabelText:@"请填写步骤描述" afterDelay:1];
            return NO;
        }
    }
    if (self.myPs_String.length == 0) {
        [super showProgressErrorWithLabelText:@"请填写小贴士" afterDelay:1];
        return NO;
    }
    
    return YES;
}

- (void)submitCookbook
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    
    self.cookbookDetail.tags = self.selectedTags;
    self.cookbookDetail.steps = self.steps;

    self.cookbookDetail.foods = self.foods;
    self.cookbookDetail.cookbookTip = self.myPs_String;
//    self.cookbookDetail.oven = [[CookbookOven alloc] init];
    self.cookbookDetail.creator = [[Creator alloc] init];
    self.cookbookDetail.creator.ID = CurrentUserBaseId;
    
    if (self.isDraft) {
        if ([self.cookbookDetail.status isEqualToString:@"0"]) {
            [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
            [[InternetManager sharedManager] modifyCookbook:self.cookbookDetail callBack:^(BOOL success, id obj, NSError *error) {
                [super hiddenProgressHUD];
                if (success) {
                    NSLog(@"发布成功");
                    [super showProgressCompleteWithLabelText:@"发布成功" afterDelay:1];
                } else {
                    if (error.code == InternetErrorCodeConnectInternetFailed) {
                        [super showProgressErrorWithLabelText:@"网络连接失败..." afterDelay:1];
                    } else {
                        [super showProgressErrorWithLabelText:@"发布失败..." afterDelay:1];
                    }
                }
            }];
        } else {
            [self addCookbook];
        }
        
        
    } else {
        
        [self addCookbook];
        
    }
    
    
}

- (void)addCookbook
{
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] addCookbookWithCookbook:self.cookbookDetail callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSLog(@"发布成功");
            [super showProgressCompleteWithLabelText:@"发布成功" afterDelay:1];
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"网络连接失败..." afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"发布失败..." afterDelay:1];
            }
        }
    }];
}

#pragma mark - 预览菜谱

- (IBAction)previewCookbook:(UIButton *)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
    CookbookDetailControllerViewController* detailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
    detailController.cookbookDetail = self.cookbookDetail;
    detailController.isPreview = YES;
    [self.navigationController pushViewController:detailController animated:YES];
    
}



#pragma mark- 点击编辑图片
-(void)changeCover{
    self.ischangeCover = YES;
    self.myWindow.hidden = NO;
    self.addFoodAlertView.hidden = YES;
    self.addFoodAlertView.frame = alertRectHidden;
    [UIView animateWithDuration:0.3 animations:^{[self.chooseCoverView setFrame:CGRectMake(0, PageH-PageW*0.58, PageW, PageW*0.58)];
    }completion:nil];
    
}







- (void)openEditor
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.peTempImage;
    controller.toolbarHidden = YES;
    controller.keepingCropAspectRatio = YES;
    
    if (self.ischangeCover)
        controller.cropAspectRatio = 65.0f/52.0f;
    else
        controller.cropAspectRatio = 53.0f/32.0f;

    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:navigationController animated:NO completion:NULL];
}



#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    NSData* imageData = UIImageJPEGRepresentation(croppedImage, 0.6);
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    
    if (self.ischangeCover) {
        self.ischangeCover = NO;
        
        [[InternetManager sharedManager] uploadFile:imageData callBack:^(BOOL success, id obj, NSError *error) {
            [super hiddenProgressHUD];
            if (success) {
                NSDictionary* objDict = [obj firstObject];
                self.cookbookDetail.coverPhoto = objDict[@"name"];
                
            } else {
                if (error.code == InternetErrorCodeConnectInternetFailed) {
                    [super showProgressErrorWithLabelText:@"网络连接失败" afterDelay:1];
                } else {
                    [super showProgressErrorWithLabelText:@"上传失败，请重试" afterDelay:1];
                }
            }
        }];
        self.cookbookCoverPhoto = croppedImage;
        [self.tableView reloadData];
        
    }else {
        self.tempImageView.image = croppedImage;
        [[InternetManager sharedManager] uploadFile:imageData callBack:^(BOOL success, id obj, NSError *error) {
            [super hiddenProgressHUD];
            if (success) {
                NSDictionary* objDict = [obj firstObject];
                self.edittingStep.photo = objDict[@"name"];
                [self.tableView reloadData];
            } else {
                if (error.code == InternetErrorCodeConnectInternetFailed) {
                    [super showProgressErrorWithLabelText:@"网络连接失败" afterDelay:1];
                } else {
                    [super showProgressErrorWithLabelText:@"上传失败，请重试" afterDelay:1];
                }
            }
        }];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    self.ischangeCover = NO;
    [controller dismissViewControllerAnimated:YES completion:NULL];
}



-(void)getUseDeviceDataWithWorkModel:(NSString *)workmodel andTime:(NSString *)time andTemperature:(NSString *)temperature{
    NSLog(@"%@ ,%@ ,%@",workmodel,time,temperature);
    useBake = !useBake;
    [self.tableView reloadData];
#warning 补全烤箱型号
    self.cookbookDetail.oven = [[CookbookOven alloc] initWithRoastStyle:workmodel
                                                       roastTemperature:temperature
                                                              roastTime:time
                                                               ovenInfo:@{@"name" : @"HaierOven"}];
    
}
@end
