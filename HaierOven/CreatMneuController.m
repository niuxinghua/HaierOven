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
@interface CreatMneuController ()<AutoSizeLabelViewDelegate,CellOfAddFoodTableDelegate,AddFoodAlertViewDelegate,AddStepCellDelegate,ChooseCoverViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YIPopupTextViewDelegate>
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

#pragma mark - outlets


@end
#define PADDING_WIDE    15   //标签左右间距
#define PADDING_HIGHT    8   //标签上下间距
#define LABEL_H    20   //标签high

@implementation CreatMneuController

#pragma mark - 加载系列

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
}

-(void)SetUpSubviews{
    
    self.tags =  @[@"烘焙",@"蒸菜",@"微波炉",@"巧克力",@"面包",@"饼干海鲜",@"有五个字呢",@"四个字呢",@"三个字呢",@"没规律呢",@"都能识别的呢",@"鱼",@"零食",@"早点",@"海鲜"];
    self.tagsCellHight = [self getHeight];
    self.psCellHight = 210;
    
//    self.tagsView = [AutoSizeLabelView new];
//    self.tagsView.tags = [self.tags copy];
//    
    
    self.foods = [NSMutableArray new];
    self.steps = [NSMutableArray new];
    [self.steps addObject:@"1"];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellOfAddFoodTable class]) bundle:nil] forCellReuseIdentifier:@"CellOfAddFoodTable"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddStepCell class]) bundle:nil] forCellReuseIdentifier:@"AddStepCell"];
    
    
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 0, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;
    
    self.addFoodAlertView = [[AddFoodAlertView alloc]initWithFrame:CGRectMake(0, 0, PageW-30, 138)];
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
            cell.coverImage = self.cookbookCoverPhoto;
            return cell;
            
        }else if(indexPath.row ==1)  {
            ChooseTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseTagsCell" forIndexPath:indexPath];
            cell.tagsView.delegate = self;
            if (!self.tagsView) {
                cell.tagsView.tags = self.tags;
                self.tagsView = cell.tagsView;
            }
//            cell.tagsView = self.tagsView;
            return cell;
            
        }else if(indexPath.row == 2){
            CellOfAddFoodTable *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOfAddFoodTable" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.food = [self.foods mutableCopy];
            cell.delegate = self;

            return cell;
        }else if(indexPath.row ==3){
            UseDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UseDeviceCell" forIndexPath:indexPath];
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
            return (PageW-16)*0.13*(self.foods.count+2)+51;
            break;
        case 3:
            return 80;
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
-(void)ImportAlertView:(UILabel *)label{
    self.addFoodAlertView.addFoodAlertType = label.tag;
    self.addFoodAlertView.label = label;
    self.myWindow.hidden = NO;
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
-(void)DeleteStepOfMainTableView:(NSMutableArray *)arr{
    self.steps = [arr mutableCopy];
    CGPoint point = self.tableView.contentOffset;
    
    [UIView animateWithDuration:0.6 animations:^{self.tableView.contentOffset = CGPointMake(0, point.y-(PageW - 60)*0.58);
    }completion:nil];
    [self.tableView reloadData];
}


-(void)ImportStepDescription:(UILabel *)label{
    //添加表述
    YIPopupTextView* popupTextView =
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
            if (textView.tag ==1) {
                self.tempLabel.text = text;
                self.tempLabel.textColor = [UIColor blackColor];
            }else if (textView.tag==2){
                self.myPs_String = text;
                CGSize size = CGSizeZero;
                size = [MyUtils getTextSizeWithText:self.myPs_String andTextAttribute:@{NSFontAttributeName :[UIFont fontWithName:GlobalTitleFontName size:15]} andTextWidth:self.tableView.width-100];
                size.height = size.height<18?18:size.height;
                self.psCellHight =size.height+145;
            
                [self.tableView reloadData];
                
            }
        }
    }
}

-(void)AddStepImage:(UIImageView *)imageView{
    NSLog(@"添加图片");
    self.myWindow.hidden = NO;
    self.addFoodAlertView.hidden = YES;
    self.tempImageView = imageView;
    [UIView animateWithDuration:0.3 animations:^{[self.chooseCoverView setFrame:CGRectMake(0, PageH-PageW*0.58, PageW, PageW*0.58)];
    }completion:nil];
}

-(void)TakeCover:(NSInteger)tag{
    [UIView animateWithDuration:0.3 animations:^{[self.chooseCoverView setFrame:CGRectMake(0, PageH, PageW, PageW*0.58)];
    }completion:^(BOOL finished) {
        self.myWindow.hidden = YES;
        self.addFoodAlertView.hidden = NO;
        if (tag == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;  //是否可编辑
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
            pickerImage.allowsEditing = NO;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
        
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.tempImageView.image = image;
    //    [self.avaterButton setImage:image forState:UIControlStateNormal];
    //    [self.avaterButton setImage:image forState:UIControlStateHighlighted];
}

#pragma mark-


#pragma mark- 自动标签delegate
-(void)chooseTags:(UIButton*)btn{
    btn.selected = btn.selected ==YES?NO:YES;

    NSLog(@"%d",btn.tag);
}
#pragma mark-

-(float)getHeight{
    float leftpadding = 0;
    int line = 1;
    int count = 0;
    for (int i = 0; i<self.tags.count; i++) {
        float wide  =  [AutoSizeLabelView boolLabelLength:self.tags[i] andAttribute:@{NSFontAttributeName: [UIFont fontWithName:GlobalTextFontName size:14]}]+20;
        
        if (leftpadding+wide+PADDING_WIDE*count>PageW-60) {
            leftpadding=0;
            ++line;
            count = 0;
        }
        
        leftpadding +=wide;
        count++;
    }
    
    return (PADDING_HIGHT+LABEL_H)*line+75;
}


#pragma mark- AddFoodAlertView 弹出框delegate
-(void)Cancel{
    self.myWindow.hidden = YES;
}

-(void)ChickAlert:(UILabel *)label andTextFailed:(UITextField *)textfield{
    self.myWindow.hidden = YES;
    [textfield resignFirstResponder];
}
#pragma mark -

#pragma mark - 我使用了烤箱
- (IBAction)UseDevice:(id)sender {
    NSLog(@"我使用了烤箱");
}

#pragma mark -


- (IBAction)AddPS:(id)sender {
    YIPopupTextView* popupTextView =
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
}

- (IBAction)Public:(id)sender {
    NSLog(@"发发发布");
}
@end
