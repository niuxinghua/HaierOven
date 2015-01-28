//
//  CompleteCookController.m
//  HaierOven
//
//  Created by dongl on 14/12/26.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CompleteCookController.h"

@interface CompleteCookController ()
@property (strong, nonatomic) IBOutlet UILabel *completeTitleLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *on_offBtn;
@property (strong, nonatomic) IBOutlet UIImageView *completeImage;
@property (strong, nonatomic) IBOutlet UILabel *completeDescription;
@property (strong, nonatomic) IBOutlet UILabel *completeSentence;

@end

@implementation CompleteCookController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.completeImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.completeImage addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    switch (_completeTye) {
        case CompleteTyeCook:
            self.completeTitleLabel.text = @"烹饪已完成";
            self.completeDescription.text = @"烹饪已完成";
            self.completeSentence.text = @"烹饪已完成，可以进行下一步操作了";
            self.completeImage.image = [UIImage imageNamed:@"prwc"];
            break;
        case CompleteTyeWarmUp:
            self.completeTitleLabel.text = @"预热已完成";
            self.completeDescription.text = @"预热已完成";
            self.completeSentence.text = @"烤箱预热已完成，请将食物放入烤箱";
            self.completeImage.image = [UIImage imageNamed:@"yrwc"];
            
            break;
        default:
            break;
    }
    
    OvenManager* ovenManager = [OvenManager sharedManager];
   
    for (UIButton* button in self.on_offBtn) {
        button.selected = ovenManager.currentStatus.opened;
    }
    
}


- (IBAction)onOffBtnsTapped:(UIButton *)sender
{
    
    if (sender.selected) {
        [self bootup];
        for (UIButton* button in self.on_offBtn) {
            button.selected = NO;
        }
        [self.delegate cookCompleteToShutdown:NO];
    } else {
        [self shutdown];
        for (UIButton* button in self.on_offBtn) {
            button.selected = YES;
        }
        [self.delegate cookCompleteToShutdown:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)close
{
    [self.delegate cookCompleteToShutdown:YES];
    [self shutdown];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 设备指令

- (void)bootup //开机
{
    uSDKDeviceAttribute* cmd = [[OvenManager sharedManager] structureWithCommandName:kBootUp commandAttrValue:kBootUp];
    [[OvenManager sharedManager] executeCommands:[@[cmd] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
                                            
                                        }];
}

- (void)shutdown
{
    uSDKDeviceAttribute* cmd = [[OvenManager sharedManager] structureWithCommandName:kShutDown commandAttrValue:kShutDown];
    [[OvenManager sharedManager] executeCommands:[@[cmd] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
                                            
                                        }];
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
