//
//  BookingTicketViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "BookingTicketViewController.h"
#import "AddTravelCompanionViewController.h"
#import "ChooseTravelCompanionViewController.h"
#import "ASIFormDataRequest.h"
#import "GlobalClass.h"
#import "KeyValuePickerView.h"
#import "NSString+SBJSON.h"
#import "HTMLParser.h"
#import "MBProgressHUD.h"
#import "DDHelper.h"

#import "PassengerModel.h"


#define TAG_PICKER_CARDTYPE 101
#define TAG_PICKER_SEATTYPE 102
#define TAG_PICKER_TICKETTYPE 103

#define TAG_CELL_NAME 400
#define TAG_CELL_CARDNO 500
#define TAG_CELL_MOBILE 600

#define TAG_CELL_CARDTYPE 201
#define TAG_CELL_SEATTYPE 202
#define TAG_CELL_TICKETTYPE 203

#define TAG_CELL_SELECTRADIO 300


#define USER_INFO_ITEMS_COUNT 7



@interface BookingTicketViewController ()
@property(nonatomic,retain)NSMutableArray* tableArray;
@property(nonatomic,retain)NSMutableDictionary* dataDict;
//@property(nonatomic,retain)NSMutableArray* userListArray;

@property(nonatomic,retain)NSString* tokenString;
@property(nonatomic,retain)NSString* leftTicketsString;
@property(nonatomic,retain)ASIHTTPRequest* requestImg;

@property(nonatomic,retain)NSMutableArray* seatArray;

@property(nonatomic,retain)NSMutableArray* passagesArray;
@property(nonatomic,retain)NSMutableArray* passagesIsOpenArray;
@end

@implementation BookingTicketViewController
@synthesize tableArray,dataDict;
@synthesize requestImg;
@synthesize orderString;

@synthesize leftTicketsString;
@synthesize tokenString;

@synthesize seatArray;
@synthesize passagesArray;
@synthesize passagesIsOpenArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        orderString=@"";
        
        self.tableArray=[NSMutableArray arrayWithObjects:
                         [NSMutableArray arrayWithObjects:
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"车次",@"title",@"trainLine",@"id",@"",@"value",@"",@"mask",nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"日期",@"title",@"trainDate",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"时间",@"title",@"trainTime",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"验证码",@"title",@"code",@"id",@"",@"value",@"",@"mask", nil],
                          
                          nil],nil];
        
        
        self.dataDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"C209",@"trainLine",
                       @"2013-02-02",@"trainDate",
                       @"18:00-23:00",@"trainTime",
                       @"",@"code",
                       nil];
        
        
        tokenString=@"";
        leftTicketsString=@"";
        
        
        self.seatArray=[NSMutableArray  array];
        self.passagesArray=[NSMutableArray  array];
        self.passagesIsOpenArray=[NSMutableArray  array];
        
        
        //        self.passagesArray=[NSMutableArray arrayWithObjects:
        //
        //                            [NSMutableDictionary dictionaryWithObjectsAndKeys:
        //                             @"0",@"index",
        //                             @"1",@"xibie",
        //                             @"1",@"piaozhong",
        //                             @"",@"passenger_name",
        //                             @"1",@"cardType",
        //                             @"",@"cardNo",
        //                             @"",@"phone",
        //                             nil],
        //                            nil];
        
        
        //        self.passagesIsOpenArray=[NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES], nil];
        
        isInit=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor=[UIColor clearColor];
    self.title=NSLocalizedString(@"新增订单", nil);
    self.tableView.allowsSelectionDuringEditing=YES;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    //self.navigationItem.rightBarButtonItem=self.editButtonItem;
    [self showCustomBackButton];
    
    NGCustomButton* subButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [subButton addTarget:self action:@selector(onSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    subButton.titleLabel.text=@"提交订单";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:subButton] autorelease];
    [subButton release];
    
    
    //    CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-44);
    //    self.mainTableView=[[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped] autorelease]  ;
    //    [self.view addSubview:self.mainTableView];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    //    mainTableView.dataSource=(id<UITableViewDataSource>)self;
    //    mainTableView.delegate=(id<UITableViewDelegate>)self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    //isKeyBoardShow=NO;
    
    //[self registerForKeyboardNotifications];
    
    [self.tableView setEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    MBProgressHUD* HUD=[[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"  亲，正在为你准备订单...  ";
    HUD.margin = 30.f;
    HUD.yOffset = -45.f;
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(prepareOrder) onTarget:self withObject:nil animated:YES];
    
    [HUD release];
    
    
    //    UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //    tapGesture.delegate=(id<UIGestureRecognizerDelegate>)self;
    //    [self.view addGestureRecognizer:tapGesture];
    
    
}

//-(void)tap:(UIGestureRecognizer*)gesture
//{
//
//    [self.view endEditing:YES];
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isInit) {
        isInit=NO;
        
        [self performSelectorInBackground:@selector(changeImg:) withObject:nil];
    }
    
    
    
    
}
-(void)prepareOrder
{
    
    
    if (DEBUG_MODE==0) {
        
        if ([self initOrder]) {
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [self.tableView reloadData];
        }else
        {
            self.navigationItem.rightBarButtonItem.enabled=NO;
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"订单初始化失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=2008;
            [alert release];
            //[self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [[tableArray objectAtIndex:section]  count];
    }else if (section==2)
    {
        
        int c=0;
        for (NSNumber *b in self.passagesIsOpenArray)
        {
            if ([b boolValue]) {
                c+=USER_INFO_ITEMS_COUNT;
            }else
            {
                c+=1;
            }
        }
        return c;
    }
    else if (section==1)
    {
        return 1;
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //static NSString *CellIdentifier = @"Cell_ABC";
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell-%d-%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
    }
    
    
    if (indexPath.section==0) {
        
        
        NSMutableDictionary* cellDict=[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text=[cellDict valueForKey:@"title"];
        cell.textLabel.textColor=[UIColor colorWithWhite:0.2 alpha:0.9];
        
        NSString* itemID=[cellDict objectForKey:@"id"];
        
        if ([itemID isEqualToString:@"code"]) {
            
            cell.textLabel.text=@"验证码";
            UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
            
            if (!textCode) {
                
                textCode=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
                textCode.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                textCode.placeholder=@"验证码点击可刷新";
                textCode.font=[UIFont systemFontOfSize:14];
                textCode.autocapitalizationType=UITextAutocapitalizationTypeNone;
                textCode.autocorrectionType=UITextAutocorrectionTypeNo;
                //textCode.delegate=self;
                
                
                textCode.returnKeyType=UIReturnKeyDone;
            }
            
            [v addSubview:textCode];
            
            
            if (!imgBtn) {
                
                imgBtn=[[UIButton alloc] initWithFrame:CGRectMake(120, 0, 60, 40)];
                [imgBtn addTarget:self action:@selector(changeImg:) forControlEvents:UIControlEventTouchUpInside];
                
                //[self performSelectorInBackground:@selector(changeImg:) withObject:nil];
                
                
            }
            
            [v addSubview:imgBtn];
            
            cell.editingAccessoryView=v;
            [v release];
            
            
        }
        else
        {
            
            UILabel* lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            lb.backgroundColor=[UIColor clearColor];
            lb.text=[self.dataDict objectForKey:[cellDict objectForKey:@"id"]];
            lb.textColor=[UIColor blueColor];
            cell.editingAccessoryView=lb;
            [lb release];
            
        }
    }
    
    
    
    else
        
        if (indexPath.section==2) {
            
            NSIndexPath *dictIndexPath=[self arrayIndexToDataDictPath:indexPath.row];
            cell.textLabel.backgroundColor=[UIColor clearColor];
            
            //            @"0",@"index",
            //            @"1",@"xibie",
            //            @"1",@"piaozhong",
            //            @"",@"passenger_name",
            //            @"1",@"cardType",
            //            @"",@"cardNo",
            //            @"",@"phone",
            
            if (dictIndexPath.row==0) {
                
                
                BOOL isOpen=[[passagesIsOpenArray objectAtIndex:dictIndexPath.section] boolValue];
                
                if (isOpen) {
                    cell.textLabel.text=[NSString stringWithFormat:@" %d号乘客信息:",[self.passagesArray count]-dictIndexPath.section];
                }else
                {
                    cell.textLabel.text=[[passagesArray objectAtIndex:dictIndexPath.section] objectForKey:@"passenger_name"];
                }
                cell.backgroundColor=[UIColor colorWithRed:0xFE/255.0 green:0xF0/255.0 blue:0xF0/255.0 alpha:1];
                cell.editingAccessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.editingAccessoryView=nil;
            }
            
            
            else if (dictIndexPath.row==1) {
                
                cell.textLabel.text=@"席     别";
                cell.backgroundColor=[UIColor whiteColor];
                
                
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 35)];
                label.tag = TAG_CELL_CARDTYPE;
                label.font = [UIFont systemFontOfSize:14];
                label.backgroundColor = [UIColor clearColor];
                cell.editingAccessoryView=label;
                
                
                NSString* value=[[passagesArray objectAtIndex:dictIndexPath.section] objectForKey:@"xibie"];
                
                label.text = [self seatTypeTextForValue:value];
                [label release];
                cell.editingAccessoryType=UITableViewCellAccessoryNone;
                
            }
            else if (dictIndexPath.row==2) {
                
                cell.textLabel.text=@"票     种";
                cell.backgroundColor=[UIColor whiteColor];
                
                
                
                
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 35)];
                label.tag = TAG_CELL_CARDTYPE;
                label.font = [UIFont systemFontOfSize:14];
                label.backgroundColor = [UIColor clearColor];
                cell.editingAccessoryView=label;
                
                NSString* value=[[passagesArray objectAtIndex:dictIndexPath.section] objectForKey:@"piaozhong"];
                
                label.text = [DDHelper nameForCode:value withKey:@"userType"];
                
                [label release];
                cell.editingAccessoryType=UITableViewCellAccessoryNone;
                
            }
            else if (dictIndexPath.row==3)
            {
                
                cell.textLabel.text=@"姓     名";
                cell.backgroundColor=[UIColor whiteColor];
                cell.editingAccessoryType=UITableViewCellAccessoryNone;
                UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 35)];
                textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                textField.tag = indexPath.row;
                textField.borderStyle = UITextBorderStyleLine;
                textField.placeholder = @"旅客姓名...";
                textField.text = [[passagesArray objectAtIndex:dictIndexPath.section] objectForKey:@"passenger_name"];
                textField.font = [UIFont systemFontOfSize:14];
                textField.delegate = self;
                cell.editingAccessoryView=textField;
                [textField release];
                
            }
            else if (dictIndexPath.row==4) {
                
                cell.textLabel.text=@"证件类型";
                cell.backgroundColor=[UIColor whiteColor];
                
                
                
                
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 35)];
                label.tag = TAG_CELL_CARDTYPE;
                label.font = [UIFont systemFontOfSize:14];
                label.backgroundColor = [UIColor clearColor];
                cell.editingAccessoryView=label;
                
                NSString* value=[[passagesArray objectAtIndex:dictIndexPath.section] objectForKey:@"cardType"];
                
                label.text = [DDHelper nameForCode:value withKey:@"idType"];
                
                [label release];
                cell.editingAccessoryType=UITableViewCellAccessoryNone;
                
            }
            else if (dictIndexPath.row==5) {
                
                cell.textLabel.text=@"证件号码";
                cell.backgroundColor=[UIColor whiteColor];
                cell.editingAccessoryType=UITableViewCellAccessoryNone;
                UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 35)];
                textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                textField.tag = indexPath.row;
                textField.borderStyle = UITextBorderStyleLine;
                textField.placeholder = @"证件号码";
                textField.text = [[passagesArray objectAtIndex:dictIndexPath.section] objectForKey:@"cardNo"];
                textField.font = [UIFont systemFontOfSize:14];
                textField.delegate = self;
                cell.editingAccessoryView=textField;
                [textField release];
                
                
            }
            else if (dictIndexPath.row==6) {
                
                cell.textLabel.text=@"手  机  号";
                cell.backgroundColor=[UIColor whiteColor];
                cell.editingAccessoryType=UITableViewCellAccessoryNone;
                UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 35)];
                textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                textField.tag = indexPath.row;
                textField.borderStyle = UITextBorderStyleLine;
                textField.placeholder = @"手机号";
                textField.text = [[passagesArray objectAtIndex:dictIndexPath.section] objectForKey:@"phone"];
                textField.font = [UIFont systemFontOfSize:14];
                textField.delegate = self;
                cell.editingAccessoryView=textField;
                [textField release];
                
                
            }
            
        }
    
    
        else
            
            if (indexPath.section==1&&indexPath.row==0) {
                
                
                
                
                cell.accessoryType=UITableViewCellAccessoryNone;
                cell.textLabel.text=@"";
                //cell.backgroundColor=[UIColor whiteColor];
                //cell.backgroundView=nil;
                
                UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20, 44)];
                v.backgroundColor=MAIN_BG_COLOR;
                
                
                UIButton* labelValue=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                [labelValue addTarget:self action:@selector(onAddNewCustomClick) forControlEvents:UIControlEventTouchUpInside];
                labelValue.frame=CGRectMake(0, 0, (cell.frame.size.width-20)/2-10, 44);
                labelValue.backgroundColor=[UIColor clearColor];
                [labelValue setTitle:@"✚添加新乘客" forState:UIControlStateNormal];
                
                
                UIButton* labelValue2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                [labelValue2 addTarget:self action:@selector(onChoosePassageClick) forControlEvents:UIControlEventTouchUpInside];
                labelValue2.frame=CGRectMake((cell.frame.size.width-20)/2+10, 0, (cell.frame.size.width-20)/2-10, 44);
                labelValue2.backgroundColor=[UIColor clearColor];
                [labelValue2 setTitle:@"✚从联系人中选取" forState:UIControlStateNormal];
                //                     labelValue sett=@"";
                //            labelValue.backgroundColor=[UIColor clearColor];
                
                [v addSubview:labelValue];
                
                [v addSubview:labelValue2];
                
                cell.accessoryView=v;
                
                cell.editingAccessoryView=v;
                
                [v release];
                //[labelValue release];
                
            }
    
    
    return cell ;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    if (indexPath.section==2) {
        
        NSIndexPath *dictIndexPath=[self arrayIndexToDataDictPath:indexPath.row];
        
        
        BOOL isOpen= [[self.passagesIsOpenArray objectAtIndex:dictIndexPath.section] boolValue];
        
        int rowsCountToDelete=isOpen?USER_INFO_ITEMS_COUNT:1;
        NSMutableArray* indexPaths=[NSMutableArray array];
        {
            for (int i=0; i<rowsCountToDelete; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row+i inSection:2]];
            }
            
        }
        
        [self.passagesArray removeObjectAtIndex:dictIndexPath.section];
        [self.passagesIsOpenArray removeObjectAtIndex:dictIndexPath.section];
        
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        
        
        
        
    }
    
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.section==2) {
        if ([self arrayIndexToDataDictPath:indexPath.row].row==0) {
            
            return UITableViewCellEditingStyleDelete;
        }
        
    }
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section==2) {
        return YES;
    }
    return NO;
}
//-(void)removePassage:(UIButton*)btn
//{
//
//    [self.passagesArray removeObjectAtIndex:btn.tag-100];
//    //
//    //    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag-100 inSection:2]] withRowAnimation:UITableViewRowAnimationRight];
//    //
//    [self.tableView reloadData];
//
//
//}
-(void)onSubmitClick
{
    
    //
    
    
    
    if ([self.passagesArray count]<1) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"请至少选择一名乘客！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
        
    }
    
    if ([self.passagesArray count]>5) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"乘客最多只能有五位！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
        
    }
    
    [self.view endEditing:YES];
    if (![self checkForm]) {
        return;
    };
    
    
    MBProgressHUD* HUD=[[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"  订单提交中...  ";
    HUD.margin = 30.f;
    HUD.yOffset = -45.f;
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(doSubmit) onTarget:self withObject:nil animated:YES];
    
    [HUD release];
    
    
    
    
    
}


-(void)doSubmit
{
    
    
    if (![self checkOrderInfo]) {
        [self reloadCheckCode];
        return;
    }
    sleep(1);
    [self confirmPassengerAction];
    sleep(1);
    [self confirmSingleForQueueOrderInfo];
    
}

-(void)onAddNewCustomClick
{
    
    if ([self.passagesArray count]>=5) {
        return;
    }
    
    
    [self.passagesArray insertObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"0",@"index",
                                      @"1",@"xibie",
                                      @"1",@"piaozhong",
                                      @"",@"passenger_name",
                                      @"1",@"cardType",
                                      @"",@"cardNo",
                                      @"",@"phone",
                                      nil] atIndex:0];
    
    [self.passagesIsOpenArray insertObject:[NSNumber numberWithBool:YES] atIndex:0];
    
    
    
    int rowIndex=0;
    
    //    int sectionIndex=[self.passagesArray count]-2;
    //    if (sectionIndex>=0) {
    //        rowIndex=[self rowIndexForArrDict:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    //    }
    NSMutableArray* indexPaths=[NSMutableArray array];
    {
        for (int i=0; i<USER_INFO_ITEMS_COUNT; i++) {
            
            [indexPaths addObject:[NSIndexPath indexPathForRow:rowIndex+i inSection:2]];
        }
        
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:2] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    
    //    [self.passagesArray insertObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                      @"C209",@"index",
    //                                      @"1",@"xibie",
    //                                      @"1",@"piaozhong",
    //                                      @"张三",@"passenger_name",
    //                                      @"1",@"cardType",
    //                                      @"",@"cardNo",
    //                                      @"",@"phone",
    //                                      nil] atIndex:0];
    //    [self.passagesIsOpenArray insertObject:[NSNumber numberWithBool:YES] atIndex:0];
    //
    //    [self.tableView reloadData];
    
    
    //
    //    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:@"在同行旅客中选择" otherButtonTitles:@"新建旅客", nil];
    //    [actionSheet showInView:self.view];
    //    [actionSheet release];
    
}
-(void)onChoosePassageClick
{
    ChooseTravelCompanionViewController* choose=[[ChooseTravelCompanionViewController alloc] init];
    
    choose.chooseDelegate=self;
    
    NSMutableDictionary* dict=[NSMutableDictionary dictionary];
    
    for (NSMutableDictionary* d  in self.seatArray) {
        [dict setObject:[NSArray arrayWithObjects: [d objectForKey:@"text"],@"￥0.00", nil] forKey: [d objectForKey:@"value"]];
    }
    choose.seatTypes=dict;
    [self.navigationController pushViewController:choose  animated:YES];
    [choose release];
    
}
-(void)chooseTravelViewController:(ChooseTravelCompanionViewController*)picker didChosenWithArray:(NSArray*)arr;
{
    
    for (PassengerModel* pm in arr) {
        
        
        NSMutableDictionary* d=   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"0",@"index",
                                   pm.seatType,@"xibie",
                                   pm.ticketType,@"piaozhong",
                                   pm.passenger_name,@"passenger_name",
                                   pm.passenger_id_type_code,@"cardType",
                                   pm.passenger_id_no,@"cardNo",
                                   pm.mobile_no,@"phone",
                                   nil];
        
        LogInfo(@"%@",d);
        
        [self.passagesArray addObject:d];
        [self.passagesIsOpenArray addObject:[NSNumber numberWithBool:YES]];
        
    }
    
    [self.tableView reloadData];
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==1) {
        
        
        AddTravelCompanionViewController* controller = [[AddTravelCompanionViewController alloc] init];
        controller.isModelView = YES;
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.navigationController presentModalViewController:nav animated:YES];
        [controller release];
        [nav release];
        
        
        //        AddPassengerViewController* add=[[AddPassengerViewController alloc] init];
        //        UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:add];
        //        [add release];
        //        [self.navigationController presentModalViewController:nav animated:YES];
        //        [nav release];
        
        
    }else if (buttonIndex==0)
    {
        
        ChooseTravelCompanionViewController* choose=[[ChooseTravelCompanionViewController alloc] init];
        UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:choose];
        [choose release];
        [self.navigationController presentModalViewController:nav animated:YES];
        [nav release];
    }
    
}


-(void)setOrderString:(NSString *)orderString_
{
    //D321#11:42#21:22#240000D32120#VNP#SHH#09:04#北京南#上海#01#04#O*****00004*****0149O*****3012#EE13F2035B56773B6EFAF3D07F612E1E0065CD96F40078B0A4D3BAFB#P2
    
    
    
    NSArray* arr=[orderString_ componentsSeparatedByString:@"#"];
    
    if ([arr count]>5) {
        
        
        // [arrOrder objectAtIndex:2]
        
        
        self.dataDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [NSString stringWithFormat:@"%@ (%@--%@)",[arr objectAtIndex:0],[arr objectAtIndex:7],[arr objectAtIndex:8]],@"trainLine",
                       [GlobalClass sharedClass].dateString,@"trainDate",
                       [NSString stringWithFormat:@"%@--%@ 历时(%@)",[arr objectAtIndex:2],[arr objectAtIndex:6],[arr objectAtIndex:1]],@"trainTime",
                       @"",@"code",
                       nil];
        
        
        [orderString release];
        orderString=[orderString_ retain];
    }
    
    
    
    
}


-(BOOL)checkForm
{
    
    if (!textCode.text||[textCode.text isEqualToString:@""]) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    
    for (NSMutableDictionary* pInfo in self.passagesArray) {
        
        
        BOOL b=  [[pInfo objectForKey:@"xibie"] isEqualToString:@""];
        b=b||[[pInfo objectForKey:@"piaozhong"] isEqualToString:@""];
        b=b||[[pInfo objectForKey:@"passenger_name"] isEqualToString:@""];
        b=b||[[pInfo objectForKey:@"cardType"] isEqualToString:@""];
        b=b||[[pInfo objectForKey:@"cardNo"] isEqualToString:@""];
        //b=b&&[[pInfo objectForKey:@"phone"] isEqualToString:@""];
        
        
        
        if (b) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"请将乘客信息填写完整！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return NO;
        }
        
        //            @"0",@"index",
        //                             @"1",@"xibie",
        //                             @"1",@"piaozhong",
        //                             @"",@"passenger_name",
        //                             @"1",@"cardType",
        //                             @"",@"cardNo",
        //                             @"",@"phone",
        
        if ([[pInfo objectForKey:@"cardType"] isEqualToString:@"1"]) {
            
            
            NSString *regex = @"(^\\d{15}$)|(^\\d{17}([0-9]|X|x)$)";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([predicate evaluateWithObject:[pInfo objectForKey:@"cardNo"]] ==FALSE) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的身份证号！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return NO;
            }
        }
        if (![[pInfo objectForKey:@"phone"] isEqualToString:@""]) {
            
            
            //NSString *regex = @"(^\\d{15}$)|(^\\d{17}([0-9]|X|x)$)";
            NSString *regex = @"^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([predicate evaluateWithObject:[pInfo objectForKey:@"phone"]] == FALSE) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的手机！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return NO;
            }
        }
        
        
        
    }
    
    return YES;
    
}



-(BOOL)checkOrderInfo
{
    
    
    
    
    NSArray* arrOrder=[orderString componentsSeparatedByString:@"#"];
    
    
    // checkOrderInfo
    
    
    // ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=confirmSingleForQueueOrder"]];
    
    ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=checkOrderInfo&rand=" stringByAppendingString:textCode.text ]]];
    
    //[request setCachePolicy:ASIUseDefaultCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setValidatesSecureCertificate:NO];
    [request setUseCookiePersistence:YES];
    [request applyCookieHeader];
    
    
    [request addRequestHeader:@"x-requested-with" value:@"XMLHttpRequest"];
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    [request addRequestHeader:@"Cache-Control" value:@" no-cache"];
    
    
    
    
    
    //   NSString* strF=@"org.apache.struts.taglib.html.TOKEN=%@&name=%@&old_name=%@&gender=%@&sex_code=%@&born_date=%@&country_code=CN&card_type=%@&old_card_type=%@&card_no=%@&old_card_no=%@&psgTypeCode=%@&passenger_type=%@&mobile_no=%@&phone_no=&email=%@&address=&postalcode=&studentInfo.province_code=11&studentInfo.school_code=&studentInfo.school_name=%E7%AE%80%E7%A0%81%2F%E6%B1%89%E5%AD%97&studentInfo.department=&studentInfo.school_class=&studentInfo.student_no=&studentInfo.school_system=4&studentInfo.enter_year=2002&studentInfo.preference_card_no=&studentInfo.preference_from_station_name=%E7%AE%80%E7%A0%81%2F%E6%B1%89%E5%AD%97&studentInfo.preference_from_station_code=&studentInfo.preference_to_station_name=%E7%AE%80%E7%A0%81%2F%E6%B1%89%E5%AD%97&studentInfo.preference_to_station_code=";
    
    
    
    
    //D321#11:42#21:22#240000D32120#VNP#SHH#09:04#北京南#上海#01#04#O*****00004*****0149O*****3012#EE13F2035B56773B6EFAF3D07F612E1E0065CD96F40078B0A4D3BAFB#P2
    
    
    
    //  NSArray* arrOrder=[orderString componentsSeparatedByString:@"#"];
    
    
    [request setPostValue:tokenString forKey:@"org.apache.struts.taglib.html.TOKEN"];
    [request setPostValue:leftTicketsString forKey:@"leftTicketStr"];
    [request setPostValue:@"中文或拼音首字母"forKey:@"textfield"];
    
    [request setPostValue:@"0" forKey:@"checkbox0"];
    
    
    [request setPostValue:[GlobalClass sharedClass].dateString forKey:@"orderRequest.train_date"];
    [request setPostValue:[arrOrder objectAtIndex:3] forKey:@"orderRequest.train_no"];
    [request setPostValue:[arrOrder objectAtIndex:0] forKey:@"orderRequest.station_train_code"];
    [request setPostValue:[arrOrder objectAtIndex:4] forKey:@"orderRequest.from_station_telecode"];
    [request setPostValue:[arrOrder objectAtIndex:5] forKey:@"orderRequest.to_station_telecode"];
    [request setPostValue:@"" forKey:@"orderRequest.seat_type_code"];
    [request setPostValue:@"" forKey:@"orderRequest.ticket_type_order_num"];
    [request setPostValue:@"000000000000000000000000000000" forKey:@"orderRequest.bed_level_order_num"];
    [request setPostValue:[arrOrder objectAtIndex:2] forKey:@"orderRequest.start_time"];
    [request setPostValue:[arrOrder objectAtIndex:6] forKey:@"orderRequest.end_time"];
    [request setPostValue:[arrOrder objectAtIndex:7] forKey:@"orderRequest.from_station_name"];
    [request setPostValue:[arrOrder objectAtIndex:8] forKey:@"orderRequest.to_station_name"];
    [request addPostValue:@"1" forKey:@"orderRequest.cancel_flag"];
    [request addPostValue:@"Y" forKey:@"orderRequest.id_mode"];
    
    
    
    
    int i=0;
    for (NSMutableDictionary* dict  in self.passagesArray) {
        i++;
        if (i>5)break;
        
        
        //        @"0",@"index",
        //        @"1",@"xibie",
        //        @"1",@"piaozhong",
        //        @"",@"passenger_name",
        //        @"1",@"cardType",
        //        @"",@"cardNo",
        //        @"",@"phone",
        
        NSString* seatTypeCode=[dict objectForKey:@"xibie"];
        NSString* ticketTypeCode=[dict objectForKey:@"piaozhong"];
        NSString* cardTypeCode=[dict objectForKey:@"cardType"];
        
        NSString* name=[dict objectForKey:@"passenger_name"];
        
        NSString* cardNo=[dict objectForKey:@"cardNo"];
        NSString* phone=[dict objectForKey:@"phone"];
        
        
        NSString* passengerTickets=[NSString stringWithFormat:
                                    @"%@,0,%@,%@,%@,%@,%@,Y",seatTypeCode,ticketTypeCode,name,cardTypeCode,cardNo,phone,nil];
        
        
        [request addPostValue:passengerTickets forKey:@"passengerTickets"];
        [request addPostValue:[NSString stringWithFormat:@"%@,%@,%@",name,cardTypeCode,cardNo,nil] forKey:@"oldPassengers"];
        [request addPostValue:seatTypeCode forKey:[NSString stringWithFormat:@"passenger_%d_seat",i]];
        [request addPostValue:ticketTypeCode forKey:[NSString stringWithFormat:@"passenger_%d_ticket",i]];
        [request addPostValue:name forKey:[NSString stringWithFormat:@"passenger_%d_name",i]];
        [request addPostValue:cardTypeCode forKey:[NSString stringWithFormat:@"passenger_%d_cardtype",i]];
        [request addPostValue:cardNo forKey:[NSString stringWithFormat:@"passenger_%d_cardno",i]];
        [request addPostValue:phone forKey:[NSString stringWithFormat:@"passenger_%d_mobileno",i]];
        
        
        [request addPostValue:@"Y" forKey:@"checkbox9"];
        
        
        
    }
    while (i<5) {
        
        i++;
        [request addPostValue:@"" forKey:@"oldPassengers"];
        [request addPostValue:@"Y" forKey:@"checkbox9"];
    }
    
    
    
    [request setPostValue:textCode.text forKey:@"randCode"];
    [request setPostValue:@"A" forKey:@"orderRequest.reserve_flag"];
    
    [request setPostValue:@"dc" forKey:@"tFlag"];
    
    
    
    //ee2420fcec0f6ace047903845030578
    //28842afa780721d07a3a0847e86b5342
    
    //1001053128400935001310010500793006150064
    
    //org.apache.struts.taglib.html.TOKEN=ee2420fcec0f6ace047903845030578\   token  \
    &leftTicketStr=1001053128400935001310010500793006150064\   和token 一起的\
    &textfield=%E4%B8%AD%E6%96%87%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D\  中文或拼音首字母\
    &checkbox1=1\
    &orderRequest.train_date=2013-02-04\   \
    &orderRequest.train_no=270000260441\
    &orderRequest.station_train_code=2601\
    &orderRequest.from_station_telecode=BJP\
    &orderRequest.to_station_telecode=LFP\
    &orderRequest.seat_type_code=\
    &orderRequest.ticket_type_order_num=\
    &orderRequest.bed_level_order_num=000000000000000000000000000000\
    &orderRequest.start_time=04%3A22\
    &orderRequest.end_time=05%3A15\
    &orderRequest.from_station_name=%E5%8C%97%E4%BA%AC\
    &orderRequest.to_station_name=%E5%BB%8A%E5%9D%8A%E5%8C%97\
    &orderRequest.cancel_flag=1\
    &orderRequest.id_mode=Y\
    &passengerTickets=3%2Cundefined%2C1%2C%E9%93%81%E8%B7%AF%2C1%2C110101198011111114%2C18912345678%2CY\
    &oldPassengers=%E9%93%81%E8%B7%AF%2C1%2C110101198011111114\
    &passenger_1_seat=3\
    &passenger_1_ticket=1\
    &passenger_1_name=%E9%93%81%E8%B7%AF\
    &passenger_1_cardtype=1\
    &passenger_1_cardno=110101198011111114\
    &passenger_1_mobileno=18912345678\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &randCode=86jk\
    &orderRequest.reserve_flag=A
    
    
    
    //    org.apache.struts.taglib.html.TOKEN:a9a86b2f98f4591cd17833d113666c93
    //leftTicketStr:1000803218400840002110008007213005900147
    //textfield:中文或拼音首字母
    //checkbox0:0
    //checkbox1:1
    //    orderRequest.train_date:2013-02-05
    //    orderRequest.train_no:580000K52408
    //    orderRequest.station_train_code:K524
    //    orderRequest.from_station_telecode:WCN
    //    orderRequest.to_station_telecode:HKN
    //    orderRequest.seat_type_code:
    //    orderRequest.ticket_type_order_num:
    //    orderRequest.bed_level_order_num:000000000000000000000000000000
    //    orderRequest.start_time:05:34
    //    orderRequest.end_time:05:53
    //    orderRequest.from_station_name:武昌
    //    orderRequest.to_station_name:汉口
    //    orderRequest.cancel_flag:1
    //    orderRequest.id_mode:Y
    //passengerTickets:1,undefined,1,张三,1,110101198011111114,11111111111,Y
    //oldPassengers:张三,1,110101198011111114
    //passenger_1_seat:1
    //passenger_1_ticket:1
    //passenger_1_name:张三
    //passenger_1_cardtype:1
    //passenger_1_cardno:110101198011111114
    //passenger_1_mobileno:11111111111
    //checkbox9:Y
    //passengerTickets:1,undefined,1,李四哈哈,1,110101199011111119,18912345678,Y
    //oldPassengers:李四哈哈,1,110101199011111119
    //passenger_2_seat:1
    //passenger_2_ticket:1
    //passenger_2_name:李四哈哈
    //passenger_2_cardtype:1
    //passenger_2_cardno:110101199011111119
    //passenger_2_mobileno:18912345678
    //checkbox9:Y
    //oldPassengers:
    //checkbox9:Y
    //oldPassengers:
    //checkbox9:Y
    //randCode:7m27
    //    orderRequest.reserve_flag:A
    //tFlag:dc
    
    [request startSynchronous];
    
    NSString* responeString=request.responseString;
    LogInfo(@"%@",responeString);
    
    
    NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"系统出错啦！" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:responeString options:0 range:(NSRange){0,responeString.length}];
    [regexAlert release];
    
    if (rAlert.range.length>0) {
        
        
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"系统出错啦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    
    //系统出错啦
    
    NSMutableDictionary* retDict=[responeString JSONValue];
    
    NSString* retString=[retDict objectForKey:@"errMsg"];
    NSString* retString2=[retDict objectForKey:@"checkHuimd"];
    NSString* retString3=[retDict objectForKey:@"check608"];
    NSString* retString4=[retDict objectForKey:@"msg"];
    if ([retString isEqualToString:@"Y"]&&[retString2 isEqualToString:@"Y"]&&[retString3 isEqualToString:@"Y"]) {
        
        //        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"预定成功，请进行支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
        //
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        return YES;
        
    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:retString4 delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return NO;
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    
    return NO;
    
}

-(BOOL)confirmPassengerAction
{
    
    //    (Request-Line)	GET /otsweb/order/confirmPassengerAction.do?method=getQueueCount&train_date=2013-02-08&train_no=580000K52408&station=K524&seat=1&from=WCN&to=HKN&ticket=1000803055400840000410008000963005900043 HTTP/1.1
    //        Host	dynamic.12306.cn
    //        User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //        Accept	application/json, text/javascript, */*
    //     Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //     Accept-Encoding	gzip, deflate
    //     Connection	keep-alive
    //     Content-Type	application/x-www-form-urlencoded
    //     X-Requested-With	XMLHttpRequest
    //     Referer	https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init
    //     Cookie	JSESSIONID=ECB492BFFC6D6F0F1F802B508303A323; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=2647916810.36895.0000
    
    NSArray* arrOrder=[orderString componentsSeparatedByString:@"#"];
    
    NSString* strF=@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=getQueueCount&train_date=%@&train_no=%@&station=%@&seat=%@&from=%@&to=%@&ticket=%@";
	
    
    NSString* seatString=[[self.passagesArray objectAtIndex:0] objectForKey:@"xibie"];
    
	//NSString* strF=@"date=%@&fromstation=%@&tostation=%@&starttime=%@";
	NSString* urlStr=[NSString stringWithFormat:strF,
                      [GlobalClass sharedClass].dateString,
                      [arrOrder objectAtIndex:3],
                      [arrOrder objectAtIndex:0],
                      seatString,
                      [arrOrder objectAtIndex:4],
                      [arrOrder objectAtIndex:5],
                      leftTicketsString,nil
                      ];
    
    
    
	ASIHTTPRequest* req=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=getQueueCount"]];
    
    [req setPostBody:[NSMutableData dataWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]]];
    
    
	req.delegate=(id<ASIHTTPRequestDelegate>)self;
	[req setValidatesSecureCertificate:NO];
    [req setUseCookiePersistence:YES];
    [req applyCookieHeader];
    
	[req addRequestHeader:@"Accept" value:@"text/plain, */*"];
	[req addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init"];
	[req addRequestHeader:@"Accept-Language" value:@"zh-CN"];
	[req addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
	[req addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
	[req addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
	[req addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
	[req addRequestHeader:@"Host" value:@" dynamic.12306.cn"];
	[req addRequestHeader:@"Content-Length" value:@"72"];
	[req addRequestHeader:@"Connection" value:@" Keep-Alive"];
	[req addRequestHeader:@"Pragma" value:@" Keep-Alive"];
	[req addRequestHeader:@"Cache-Control" value:@" no-cache"];
    
    
	
	[req startSynchronous];
    
    NSString* responeString=req.responseString;
    LogInfo(@"%@",responeString);
    
    
    NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"系统出错啦！" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:responeString options:0 range:(NSRange){0,responeString.length}];
    [regexAlert release];
    
    if (rAlert.range.length>0) {
        
        
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"系统出错啦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    
    //系统出错啦
    
    //   NSMutableDictionary* retDict=[responeString JSONValue];
    //
    //    NSString* retString=[retDict objectForKey:@"errMsg"];
    //    if ([retString isEqualToString:@"Y"]) {
    //
    //        //        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"预定成功，请进行支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        //        [alert show];
    //        //        [alert release];
    //        //
    //        //        [self.navigationController popToRootViewControllerAnimated:YES];
    //        return YES;
    //
    //    }
    //    else
    //    {
    //        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:retString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alert show];
    //        [alert release];
    //
    //
    //        //[self.navigationController popToRootViewControllerAnimated:YES];
    //
    //    }
    //
    
    return YES;
	
	
	
    
    
    
    
    
    
}
-(void)confirmSingleForQueueOrderInfo
{
    
    NSArray* arrOrder=[orderString componentsSeparatedByString:@"#"];
    
    
    // checkOrderInfo
    
    
    //    (Request-Line)	POST /otsweb/order/confirmPassengerAction.do?method=confirmSingleForQueue HTTP/1.1
    //        Host	dynamic.12306.cn
    //        User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //        Accept	application/json, text/javascript, */*
    //     Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //     Accept-Encoding	gzip, deflate
    //     Connection	keep-alive
    //     Content-Type	application/x-www-form-urlencoded; charset=UTF-8
    //     X-Requested-With	XMLHttpRequest
    //     Referer	https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init
    //     Content-Length	1176
    //     Cookie	JSESSIONID=CA7DD88F0C7DEE233FB44EBCE6E59747; BIGipServerotsweb=1742274826.22560.0000
    //     Pragma	no-cache
    //     Cache-Control	no-cache
    //
    
    ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=confirmSingleForQueue"]];
    
    // ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=checkOrderInfo&rand=" stringByAppendingString:textCode.text ]]];
    
    [request setValidatesSecureCertificate:NO];
    [request setUseCookiePersistence:YES];
    [request applyCookieHeader];
    
    [request addRequestHeader:@"x-requested-with" value:@"XMLHttpRequest"];
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    [request addRequestHeader:@"Cache-Control" value:@" no-cache"];
    
    
    
    
    
    //   NSString* strF=@"org.apache.struts.taglib.html.TOKEN=%@&name=%@&old_name=%@&gender=%@&sex_code=%@&born_date=%@&country_code=CN&card_type=%@&old_card_type=%@&card_no=%@&old_card_no=%@&psgTypeCode=%@&passenger_type=%@&mobile_no=%@&phone_no=&email=%@&address=&postalcode=&studentInfo.province_code=11&studentInfo.school_code=&studentInfo.school_name=%E7%AE%80%E7%A0%81%2F%E6%B1%89%E5%AD%97&studentInfo.department=&studentInfo.school_class=&studentInfo.student_no=&studentInfo.school_system=4&studentInfo.enter_year=2002&studentInfo.preference_card_no=&studentInfo.preference_from_station_name=%E7%AE%80%E7%A0%81%2F%E6%B1%89%E5%AD%97&studentInfo.preference_from_station_code=&studentInfo.preference_to_station_name=%E7%AE%80%E7%A0%81%2F%E6%B1%89%E5%AD%97&studentInfo.preference_to_station_code=";
    
    
    
    
    //D321#11:42#21:22#240000D32120#VNP#SHH#09:04#北京南#上海#01#04#O*****00004*****0149O*****3012#EE13F2035B56773B6EFAF3D07F612E1E0065CD96F40078B0A4D3BAFB#P2
    
    
    
    //  NSArray* arrOrder=[orderString componentsSeparatedByString:@"#"];
    
    
    [request setPostValue:tokenString forKey:@"org.apache.struts.taglib.html.TOKEN"];
    [request setPostValue:leftTicketsString forKey:@"leftTicketStr"];
    [request setPostValue:@"中文或拼音首字母"forKey:@"textfield"];
    
    [request setPostValue:@"0" forKey:@"checkbox0"];
    
    [request setPostValue:[GlobalClass sharedClass].dateString forKey:@"orderRequest.train_date"];
    [request setPostValue:[arrOrder objectAtIndex:3] forKey:@"orderRequest.train_no"];
    [request setPostValue:[arrOrder objectAtIndex:0] forKey:@"orderRequest.station_train_code"];
    [request setPostValue:[arrOrder objectAtIndex:4] forKey:@"orderRequest.from_station_telecode"];
    [request setPostValue:[arrOrder objectAtIndex:5] forKey:@"orderRequest.to_station_telecode"];
    [request setPostValue:@"" forKey:@"orderRequest.seat_type_code"];
    [request setPostValue:@"" forKey:@"orderRequest.ticket_type_order_num"];
    [request setPostValue:@"000000000000000000000000000000" forKey:@"orderRequest.bed_level_order_num"];
    [request setPostValue:[arrOrder objectAtIndex:2] forKey:@"orderRequest.start_time"];
    [request setPostValue:[arrOrder objectAtIndex:6] forKey:@"orderRequest.end_time"];
    [request setPostValue:[arrOrder objectAtIndex:7] forKey:@"orderRequest.from_station_name"];
    [request setPostValue:[arrOrder objectAtIndex:8] forKey:@"orderRequest.to_station_name"];
    [request addPostValue:@"1" forKey:@"orderRequest.cancel_flag"];
    [request addPostValue:@"Y" forKey:@"orderRequest.id_mode"];
    
    
    
    
    int i=0;
    for (NSMutableDictionary* dict  in self.passagesArray) {
        i++;
        if (i>5)break;
        
        
        //        @"0",@"index",
        //        @"1",@"xibie",
        //        @"1",@"piaozhong",
        //        @"",@"passenger_name",
        //        @"1",@"cardType",
        //        @"",@"cardNo",
        //        @"",@"phone",
        
        NSString* seatTypeCode=[dict objectForKey:@"xibie"];
        NSString* ticketTypeCode=[dict objectForKey:@"piaozhong"];
        NSString* cardTypeCode=[dict objectForKey:@"cardType"];
        
        NSString* name=[dict objectForKey:@"passenger_name"];
        
        NSString* cardNo=[dict objectForKey:@"cardNo"];
        NSString* phone=[dict objectForKey:@"phone"];
        
        
        NSString* passengerTickets=[NSString stringWithFormat:
                                    @"%@,0,%@,%@,%@,%@,%@,Y",seatTypeCode,ticketTypeCode,name,cardTypeCode,cardNo,phone,nil];
        
        
        [request addPostValue:passengerTickets forKey:@"passengerTickets"];
        //[request addPostValue:@"" forKey:@"oldPassengers"];
        [request addPostValue:[NSString stringWithFormat:@"%@,%@,%@",name,cardTypeCode,cardNo,nil] forKey:@"oldPassengers"];
        [request addPostValue:seatTypeCode forKey:[NSString stringWithFormat:@"passenger_%d_seat",i]];
        [request addPostValue:ticketTypeCode forKey:[NSString stringWithFormat:@"passenger_%d_ticket",i]];
        [request addPostValue:name forKey:[NSString stringWithFormat:@"passenger_%d_name",i]];
        [request addPostValue:cardTypeCode forKey:[NSString stringWithFormat:@"passenger_%d_cardtype",i]];
        [request addPostValue:cardNo forKey:[NSString stringWithFormat:@"passenger_%d_cardno",i]];
        [request addPostValue:phone forKey:[NSString stringWithFormat:@"passenger_%d_mobileno",i]];
        [request addPostValue:@"Y" forKey:@"checkbox9"];
        
        
        
        
    }
    
    //
    while (i<5) {
        
        i++;
        [request addPostValue:@"" forKey:@"oldPassengers"];
        [request addPostValue:@"Y" forKey:@"checkbox9"];
    }
    
    //
    //    [request addPostValue:@"" forKey:@"oldPassengers"];
    //     [request addPostValue:@"Y" forKey:@"checkbox9"];
    //
    //
    //    [request addPostValue:@"" forKey:@"oldPassengers"];
    //    [request addPostValue:@"Y" forKey:@"checkbox9"];
    //
    //
    //    [request addPostValue:@"" forKey:@"oldPassengers"];
    //    [request addPostValue:@"Y" forKey:@"checkbox9"];
    //
    
    
    [request setPostValue:textCode.text forKey:@"randCode"];
    [request setPostValue:@"A" forKey:@"orderRequest.reserve_flag"];
    
    //[request setPostValue:@"dc" forKey:@"tFlag"];
    
    
    
    //ee2420fcec0f6ace047903845030578
    //28842afa780721d07a3a0847e86b5342
    
    //1001053128400935001310010500793006150064
    
    //org.apache.struts.taglib.html.TOKEN=ee2420fcec0f6ace047903845030578\   token  \
    &leftTicketStr=1001053128400935001310010500793006150064\   和token 一起的\
    &textfield=%E4%B8%AD%E6%96%87%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D\  中文或拼音首字母\
    &checkbox1=1\
    &orderRequest.train_date=2013-02-04\   \
    &orderRequest.train_no=270000260441\
    &orderRequest.station_train_code=2601\
    &orderRequest.from_station_telecode=BJP\
    &orderRequest.to_station_telecode=LFP\
    &orderRequest.seat_type_code=\
    &orderRequest.ticket_type_order_num=\
    &orderRequest.bed_level_order_num=000000000000000000000000000000\
    &orderRequest.start_time=04%3A22\
    &orderRequest.end_time=05%3A15\
    &orderRequest.from_station_name=%E5%8C%97%E4%BA%AC\
    &orderRequest.to_station_name=%E5%BB%8A%E5%9D%8A%E5%8C%97\
    &orderRequest.cancel_flag=1\
    &orderRequest.id_mode=Y\
    &passengerTickets=3%2Cundefined%2C1%2C%E9%93%81%E8%B7%AF%2C1%2C110101198011111114%2C18912345678%2CY\
    &oldPassengers=%E9%93%81%E8%B7%AF%2C1%2C110101198011111114\
    &passenger_1_seat=3\
    &passenger_1_ticket=1\
    &passenger_1_name=%E9%93%81%E8%B7%AF\
    &passenger_1_cardtype=1\
    &passenger_1_cardno=110101198011111114\
    &passenger_1_mobileno=18912345678\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &randCode=86jk\
    &orderRequest.reserve_flag=A
    
    
    
    //    org.apache.struts.taglib.html.TOKEN:a9a86b2f98f4591cd17833d113666c93
    //leftTicketStr:1000803218400840002110008007213005900147
    //textfield:中文或拼音首字母
    //checkbox0:0
    //checkbox1:1
    //    orderRequest.train_date:2013-02-05
    //    orderRequest.train_no:580000K52408
    //    orderRequest.station_train_code:K524
    //    orderRequest.from_station_telecode:WCN
    //    orderRequest.to_station_telecode:HKN
    //    orderRequest.seat_type_code:
    //    orderRequest.ticket_type_order_num:
    //    orderRequest.bed_level_order_num:000000000000000000000000000000
    //    orderRequest.start_time:05:34
    //    orderRequest.end_time:05:53
    //    orderRequest.from_station_name:武昌
    //    orderRequest.to_station_name:汉口
    //    orderRequest.cancel_flag:1
    //    orderRequest.id_mode:Y
    //passengerTickets:1,undefined,1,张三,1,110101198011111114,11111111111,Y
    //oldPassengers:张三,1,110101198011111114
    //passenger_1_seat:1
    //passenger_1_ticket:1
    //passenger_1_name:张三
    //passenger_1_cardtype:1
    //passenger_1_cardno:110101198011111114
    //passenger_1_mobileno:11111111111
    //checkbox9:Y
    //passengerTickets:1,undefined,1,李四哈哈,1,110101199011111119,18912345678,Y
    //oldPassengers:李四哈哈,1,110101199011111119
    //passenger_2_seat:1
    //passenger_2_ticket:1
    //passenger_2_name:李四哈哈
    //passenger_2_cardtype:1
    //passenger_2_cardno:110101199011111119
    //passenger_2_mobileno:18912345678
    //checkbox9:Y
    //oldPassengers:
    //checkbox9:Y
    //oldPassengers:
    //checkbox9:Y
    //randCode:7m27
    //    orderRequest.reserve_flag:A
    //tFlag:dc
    
    [request startSynchronous];
    
    NSString* responeString=request.responseString;
    LogInfo(@"%@",responeString);
    
    
    NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"系统出错啦！" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:responeString options:0 range:(NSRange){0,responeString.length}];
    [regexAlert release];
    
    if (rAlert.range.length>0) {
        
        
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"系统出错啦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        
        
        
    }
    
    //系统出错啦
    
    NSMutableDictionary* retDict=[responeString JSONValue];
    
    NSString* retString=[retDict objectForKey:@"errMsg"];
    if ([retString isEqualToString:@"Y"]) {
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"预订成功，请尽快在PC上登录12306完成支付!\n（手机支付即将推出）" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:retString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [self reloadCheckCode];
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    
    
    
}



-(BOOL)getSubOrderTokenAndleftTicketStr
{
    
    BOOL ret1=NO;
    BOOL ret2=NO;
    //    (Request-Line)	GET /otsweb/order/confirmPassengerAction.do?method=init HTTP/1.1
    //        Host	dynamic.12306.cn
    //        User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //        Accept	text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    //        Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //        Accept-Encoding	gzip, deflate
    //        Connection	keep-alive
    //        Referer	https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init
    //        Cookie	JSESSIONID=F7F4283DF13E9B7725144A0AB2AE1EB4; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=2413035786.62495.0000
    //        Cache-Control	max-age=0
    
    
    
    ASIHTTPRequest* request= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init"]];
    [request setValidatesSecureCertificate:NO];
    [request setUseCookiePersistence:YES];
    [request applyCookieHeader];
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,application/xml"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@"Keep-Alive"];
    [request addRequestHeader:@"Cache-Control" value:@"max-age=0"];
    
    [request startSynchronous];
    
    
    LogInfo(@"%@",request.responseString);
    
    //<input type="hidden" name="org.apache.struts.taglib.html.TOKEN" value="7464e55fe3305bfd4805669e14bff9ce">
    
    NSString* retString=request.responseString;
    
    
    NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"<input type=[\"]hidden[\"] name=[\"]org.apache.struts.taglib.html.TOKEN[\"] value=[\"](.*)[\"]>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:retString options:0 range:(NSRange){0,retString.length}];
    [regexAlert release];
    
    if (rAlert.range.length>0) {
        
        int pos=70+1;
        NSString* msg=[retString substringWithRange:(NSRange){rAlert.range.location+pos,rAlert.range.length-pos-2}];
        if (![msg isEqualToString:@""]) {
            
            
            //            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            //            [alert release];
            self.tokenString=msg;
            
            ret1=YES;
        }
        
    }
    
    //4617c7a1f85641ba3b8a6ec184fe5b79
    //7464e55fe3305bfd4805669e14bff9ce
    
    //4617c7a1f85641ba3b8a6ec184fe5b79
    
    //1000603128400820002410006004963005700081
    //1000803044400840000010008001973005900024
    
    //<input type="hidden" name="org.apache.struts.taglib.html.TOKEN" value="7464e55fe3305bfd4805669e14bff9ce">
    //<input type="hidden" name="leftTicketStr" id="left_ticket" value="1000803027400840002610008000003005900031" />
    //<input type="hidden" name="leftTicketStr" id="left_ticket" value="1000803044400840000010008001973005900024" />
    
    LogInfo(@"%@",retString);
    
    
    NSRegularExpression* regexAlert2=[[NSRegularExpression alloc] initWithPattern:@"<input type=[\"]hidden[\"] name=[\"]leftTicketStr[\"] id=[\"]left_ticket[\"]*.*[\r\n]*.*value=[\"](.*)[\"] />" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult* rAlert2=  [regexAlert2 firstMatchInString:retString options:0 range:(NSRange){0,retString.length}];
    [regexAlert2 release];
    
    if (rAlert2.range.length>0) {
        
        int pos=70-3+1;
        NSString* msg=[retString substringWithRange:(NSRange){rAlert2.range.location+pos,rAlert2.range.length-pos-4}];
        if (![msg isEqualToString:@""]) {
            
            
            //            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            //            [alert release];
            self.leftTicketsString=msg;
            
            ret2=YES;
            
        }
        
    }
    
    if (ret1&&ret2) {
        
        NSString* leftString=@"<table width=\"100%\" border=\"0\" cellspacing=\"1\"";
        NSString* rightString=@"以上余票信息随时发生变化，仅作参考";
        
        retString=[[retString componentsSeparatedByString:rightString] objectAtIndex:0];
        NSArray* tmpArray=[retString componentsSeparatedByString:leftString];
        if (!([tmpArray count]>1)) {
            return NO;
        }
        retString=[tmpArray objectAtIndex:1];
        NSString* html=[NSString stringWithFormat:@"<html><body><table %@ </td></tr></table></body></html>",retString];
        HTMLParser* parse=[[HTMLParser alloc] initWithString:html  error:nil];
        HTMLNode* body=parse.body;
        
        
        NSArray* trArrays=[[body findChildTag:@"table"] findChildTags:@"tr"];
        
        if (![trArrays count]>=2) {
            
            [parse release];
            return NO;
        }
        //        NSArray* trainLineInfoTDArray=[[trArrays objectAtIndex:0] findChildTags:@"td"];
        
        NSArray* ticketInfoTDArray=[[trArrays objectAtIndex:1] findChildTags:@"td"];
        
        
        //        if ([trainLineInfoTDArray count]>4) {
        //
        //            NSString* trainLine=[[trainLineInfoTDArray objectAtIndex:1] contents];
        //            NSString* trainDate=[[trainLineInfoTDArray objectAtIndex:0] contents];
        //            NSString* trainTimeBegin=[[trainLineInfoTDArray objectAtIndex:2] contents];
        //
        //            trainTimeBegin=[[trainTimeBegin componentsSeparatedByString:@"("] objectAtIndex:1];
        //            trainDate=[[trainTimeBegin componentsSeparatedByString:@"("] objectAtIndex:1];
        //
        //
        //
        //            NSString* trainTimeEnd=[[trainLineInfoTDArray objectAtIndex:3] contents];
        //            NSString* trainTimeLong=[[trainLineInfoTDArray objectAtIndex:4] contents];
        //            [self.dataDict setObject:trainLine  forKey:@"trainLine"];
        //            [self.dataDict setObject:trainDate  forKey:@"trainDate"];
        //            //[self.dataDict setObject:[NSString stringWithFormat:@"(%@ (%@ %@",trainTimeBegin,trainTimeEnd,trainTimeLong]  forKey:@"trainTime"];
        //
        //        }
        
        
        //NSMutableDictionary* dict=[NSMutableDictionary dictionary];
        [self.seatArray removeAllObjects];
        for (HTMLNode* nodeTD in ticketInfoTDArray) {
            
            
            NSString* name=[nodeTD contents];
            if ([name hasPrefix:@"无座"]) {
                continue;
            }
            NSString* value=[DDHelper codeForSeatTypePrefixName:name];
            [self.seatArray addObject:
             [NSMutableDictionary dictionaryWithObjectsAndKeys:
              name,@"text",
              value,@"value",
              nil]
             ];
        }
        
        [parse release];
        
        return YES;
        
        
    }
    else
    {
        return NO;
    }
    
    
    
    
    
    
    //    <input type="hidden" name="orderRequest.train_date" value="2013-02-05" id="start_date">
    //    <input type="hidden" name="orderRequest.train_no" value="580000K52408" id="train_no">
    //    <input type="hidden" name="orderRequest.station_train_code" value="K524" id="station_train_code">
    //    <input type="hidden" name="orderRequest.from_station_telecode" value="WCN" id="from_station_telecode">
    //    <input type="hidden" name="orderRequest.to_station_telecode" value="HKN" id="to_station_telecode">
    //    <input type="hidden" name="orderRequest.seat_type_code" value="" id="seat_type_code">
    //
    //    <input type="hidden" name="orderRequest.ticket_type_order_num" value="" id="ticket_type_order_num">
    //    <input type="hidden" name="orderRequest.bed_level_order_num" value="000000000000000000000000000000" id="bed_level_order_num">
    //
    //    <input type="hidden" name="orderRequest.start_time" value="05:34" id="orderRequest_start_time">
    //
    //    <input type="hidden" name="orderRequest.end_time" value="05:53" id="orderRequest_end_time">
    //    <input type="hidden" name="orderRequest.from_station_name" value="武昌" id="orderRequest_from_station_name">
    //    <input type="hidden" name="orderRequest.to_station_name" value="汉口" id="orderRequest_to_station_name">
    //    <input type="hidden" name="orderRequest.cancel_flag" value="1" id="cancel_flag">
    //    <input type="hidden" name="orderRequest.id_mode" value="Y" id="orderRequest_id_mode">
    
    
    
    //    <input type="hidden" value="" id="_type" />
    //    <input type="hidden" value="2013-02-05" id="_train_date_str" />
    //    <input type="hidden" value="K524"
    //	id="_station_train_code" />
    
}

-(NSString*)getQueueCount
{
    
    
    //(Request-Line)	GET /otsweb/order/confirmPassengerAction.do?method=getQueueCount&train_date=2013-02-04&train_no=270000260441&station=2601&seat=3&from=BJP&to=LFP&ticket=1001053128400935001310010500793006150064 HTTP/1.1
    //    Host	dynamic.12306.cn
    //    User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //    Accept	application/json, text/javascript, */*
    //     Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //     Accept-Encoding	gzip, deflate
    //     Connection	keep-alive
    //     Content-Type	application/x-www-form-urlencoded
    //     X-Requested-With	XMLHttpRequest
    //     Referer	https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init
    //     Cookie	JSESSIONID=5533CC1E687540F36EE7E2CA0C7D7FD2; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=2127823114.48160.0000
    //
    
    //     {"countT":0,"count":11,"ticket":"1001053128400935001310010500793006150064","op_1":true,"op_2":false}
    
    
    ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/passengerAction.do?method=initModifyPassenger"]];
    [request setValidatesSecureCertificate:NO];
    [request setUseCookiePersistence:YES];
    [request applyCookieHeader];
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/passengerAction.do?method=initModifyPassenger"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    
    [request startSynchronous];
    
    return @"";
    
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL;
{
    
}

-(BOOL)initOrder
{
    
    NSArray* arrOrder=[orderString componentsSeparatedByString:@"#"];
    
    
    //    (Request-Line)	POST /otsweb/order/querySingleAction.do?method=submutOrderRequest HTTP/1.1
    //        Host	dynamic.12306.cn
    //        User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //        Accept	text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    //        Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //        Accept-Encoding	gzip, deflate
    //        Connection	keep-alive
    //        Referer	https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init
    //        Cookie	JSESSIONID=F7F4283DF13E9B7725144A0AB2AE1EB4; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=2413035786.62495.0000
    //        Content-Type	application/x-www-form-urlencoded
    //        Content-Length	721
    
    //D321#11:42#21:22#240000D32120#VNP#SHH#09:04#北京南#上海#01#04#O*****00004*****0149O*****3012#EE13F2035B56773B6EFAF3D07F612E1E0065CD96F40078B0A4D3BAFB#P2
    
    
    // station_train_code=K2076&train_date=2013-01-18&seattype_num=&from_station_telecode=WCN&to_station_telecode=HKN&include_student=00&from_station_telecode_name=%E6%AD%A6%E6%98%8C&to_station_telecode_name=%E6%B1%89%E5%8F%A3&round_train_date=2013-01-18&round_start_time_str=00%3A00--24%3A00&single_round_type=1&train_pass_type=QB&train_class_arr=QB%23D%23Z%23T%23K%23QT%23&start_time_str=00%3A00--24%3A00&lishi=00%3A19&train_start_time=16%3A13&trainno4=62000K207601&arrive_time=16%3A32&from_station_name=%E6%AD%A6%E6%98%8C&to_station_name=%E6%B1%89%E5%8F%A3&from_station_no=06&to_station_no=07&ypInfoDetail=1*****30274*****00261*****00013*****0023&mmStr=7CFFD7A5F3C6FA6651178D7D8E700669C27131C3318F0090217565BB&locationCode=Q7
    
    LogInfo(@"ssssssss%@",[GlobalClass sharedClass].dateString);
    LogInfo(@"%@",[GlobalClass sharedClass].startStation.stationName);
    LogInfo(@"%@",[GlobalClass sharedClass].endStation.stationName);
    LogInfo(@"%@",orderString);
    
    
    ASIFormDataRequest* request1= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=submutOrderRequest"]];
    
    //request1.delegate=(id<ASIHTTPRequestDelegate>)self;
    
    [request1 setValidatesSecureCertificate:NO];
    [request1 setUseCookiePersistence:YES];
    [request1 applyCookieHeader];
    [request1 addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request1 addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request1 addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init"];
    [request1 addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request1 addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request1 addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request1 addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    //[req addRequestHeader:@"Content-Length" value:@" 166"];
    [request1 addRequestHeader:@"Connection" value:@" Keep-Alive"];
    
    
    [request1 setPostValue:[arrOrder objectAtIndex:0] forKey:@"station_train_code"];
    [request1 setPostValue:[GlobalClass sharedClass].dateString forKey:@"train_date"];//???
    [request1 setPostValue:@"" forKey:@"seattype_num"];
    [request1 setPostValue:[arrOrder objectAtIndex:4] forKey:@"from_station_telecode"];
    [request1 setPostValue:[arrOrder objectAtIndex:5] forKey:@"to_station_telecode"];
    [request1 setPostValue:@"00" forKey:@"include_student"];
    [request1 setPostValue:[GlobalClass sharedClass].startStation.stationName forKey:@"from_station_telecode_name"];//???
    [request1 setPostValue:[GlobalClass sharedClass].endStation.stationName  forKey:@"to_station_telecode_name"];//???
    [request1 setPostValue:[GlobalClass sharedClass].dateString forKey:@"round_train_date"];//???
    [request1 setPostValue:@"00:00--24:00" forKey:@"round_start_time_str"];
    [request1 setPostValue:@"1" forKey:@"single_round_type"];
    [request1 setPostValue:@"QB" forKey:@"train_pass_type"];
    [request1 setPostValue:@"QB#D#Z#T#K#QT#" forKey:@"train_class_arr"];
    [request1 setPostValue:[arrOrder objectAtIndex:1] forKey:@"lishi"];
    [request1 setPostValue:[arrOrder objectAtIndex:2] forKey:@"train_start_time"];
    [request1 setPostValue:[arrOrder objectAtIndex:3] forKey:@"trainno4"];
    [request1 setPostValue:[arrOrder objectAtIndex:6] forKey:@"arrive_time"];
    [request1 setPostValue:[arrOrder objectAtIndex:7] forKey:@"from_station_name"];
    [request1 setPostValue:[arrOrder objectAtIndex:8] forKey:@"to_station_name"];
    
    [request1 setPostValue:[arrOrder objectAtIndex:9] forKey:@"from_station_no"];
    [request1 setPostValue:[arrOrder objectAtIndex:10] forKey:@"to_station_no"];
    [request1 setPostValue:[arrOrder objectAtIndex:11] forKey:@"ypInfoDetail"];
    [request1 setPostValue:[arrOrder objectAtIndex:12] forKey:@"mmStr"];
    [request1 setPostValue:[arrOrder objectAtIndex:13] forKey:@"locationCode"];
    
    
    
    [request1 startSynchronous];
    
    
    NSString* responeString=request1.responseString;
    
    LogInfo(@"%@",responeString);
    
    if (!responeString) {
        return NO;
    }
    
    NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"var message = [\"](.*)[\"]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:responeString options:0 range:(NSRange){0,responeString.length}];
    [regexAlert release];
    
    if (rAlert.range.length>0) {
        
        NSString* msg=[responeString substringWithRange:(NSRange){rAlert.range.location+15,rAlert.range.length-15-1}];
        if (![msg isEqualToString:@""]) {
            
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            
            return NO;
            
        }
    }
    
    //D321#11:42#21:22#240000D32120#VNP#SHH#09:04#北京南#上海#01#04#O*****00004*****0149O*****3012#EE13F2035B56773B6EFAF3D07F612E1E0065CD96F40078B0A4D3BAFB#P2
    
    
    //station_train_code=K2076\
    &train_date=2013-01-18\
    &seattype_num=\
    &from_station_telecode=WCN\
    &to_station_telecode=HKN\
    &include_student=00\
    &from_station_telecode_name=%E6%AD%A6%E6%98%8C\
    &to_station_telecode_name=%E6%B1%89%E5%8F%A3\
    &round_train_date=2013-01-18\
    &round_start_time_str=00%3A00--24%3A00\
    &single_round_type=1\
    &train_pass_type=QB\
    &train_class_arr=QB%23D%23Z%23T%23K%23QT%23\
    &start_time_str=00%3A00--24%3A00\
    &lishi=00%3A19\
    &train_start_time=16%3A13\
    &trainno4=62000K207601\
    &arrive_time=16%3A32\
    &from_station_name=%E6%AD%A6%E6%98%8C\
    &to_station_name=%E6%B1%89%E5%8F%A3\
    &from_station_no=06\
    &to_station_no=07\
    &ypInfoDetail=1*****30274*****00261*****00013*****0023\
    &mmStr=7CFFD7A5F3C6FA6651178D7D8E700669C27131C3318F0090217565BB\
    &locationCode=Q7
    
    
    
    
    
    //
    //    (Request-Line)	POST /otsweb/order/confirmPassengerAction.do?method=confirmSingleForQueueOrder HTTP/1.1
    //        Host	dynamic.12306.cn
    //        User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //        Accept	application/json, text/javascript, */*
    //     Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //     Accept-Encoding	gzip, deflate
    //     Connection	keep-alive
    //     Content-Type	application/x-www-form-urlencoded; charset=UTF-8
    //     X-Requested-With	XMLHttpRequest
    //     Referer	https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init
    //     Content-Length	1211
    //     Cookie	JSESSIONID=5533CC1E687540F36EE7E2CA0C7D7FD2; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=2127823114.48160.0000
    //     Pragma	no-cache
    //     Cache-Control	no-cache
    
    
    //                                                    org.apache.struts.taglib.html.TOKEN=ee2420fcec0f6ace0479038450305782&leftTicketStr=1001053128400935001310010500793006150064&textfield=%E4%B8%AD%E6%96%87%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D&checkbox1=1&orderRequest.train_date=2013-02-04&orderRequest.train_no=270000260441&orderRequest.station_train_code=2601&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=LFP&orderRequest.seat_type_code=&orderRequest.ticket_type_order_num=&orderRequest.bed_level_order_num=000000000000000000000000000000&orderRequest.start_time=04%3A22&orderRequest.end_time=05%3A15&orderRequest.from_station_name=%E5%8C%97%E4%BA%AC&orderRequest.to_station_name=%E5%BB%8A%E5%9D%8A%E5%8C%97&orderRequest.cancel_flag=1&orderRequest.id_mode=Y&passengerTickets=3%2Cundefined%2C1%2C%E9%93%81%E8%B7%AF%2C1%2C110101198011111114%2C18912345678%2CY&oldPassengers=%E9%93%81%E8%B7%AF%2C1%2C110101198011111114&passenger_1_seat=3&passenger_1_ticket=1&passenger_1_name=%E9%93%81%E8%B7%AF&passenger_1_cardtype=1&passenger_1_cardno=110101198011111114&passenger_1_mobileno=18912345678&checkbox9=Y&oldPassengers=&checkbox9=Y&oldPassengers=&checkbox9=Y&oldPassengers=&checkbox9=Y&randCode=86jk&orderRequest.reserve_flag=A
    
    //{"errMsg":"Y"}
    //
    //org.apache.struts.taglib.html.TOKEN=ee2420fcec0f6ace047903845030578\   token  \
    &leftTicketStr=1001053128400935001310010500793006150064\
    &textfield=%E4%B8%AD%E6%96%87%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D\  中文或拼音首字母\
    &checkbox1=1\
    &orderRequest.train_date=2013-02-04\
    &orderRequest.train_no=270000260441\
    &orderRequest.station_train_code=2601\
    &orderRequest.from_station_telecode=BJP\
    &orderRequest.to_station_telecode=LFP\
    &orderRequest.seat_type_code=\
    &orderRequest.ticket_type_order_num=\
    &orderRequest.bed_level_order_num=000000000000000000000000000000\
    &orderRequest.start_time=04%3A22\
    &orderRequest.end_time=05%3A15\
    &orderRequest.from_station_name=%E5%8C%97%E4%BA%AC\
    &orderRequest.to_station_name=%E5%BB%8A%E5%9D%8A%E5%8C%97&orderRequest.cancel_flag=1\
    &orderRequest.id_mode=Y\
    &passengerTickets=3%2Cundefined%2C1%2C%E9%93%81%E8%B7%AF%2C1%2C110101198011111114%2C18912345678%2CY\
    &oldPassengers=%E9%93%81%E8%B7%AF%2C1%2C110101198011111114\
    &passenger_1_seat=3&passenger_1_ticket=1\
    &passenger_1_name=%E9%93%81%E8%B7%AF\
    &passenger_1_cardtype=1\
    &passenger_1_cardno=110101198011111114\
    &passenger_1_mobileno=18912345678\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &randCode=86jk\
    &orderRequest.reserve_flag=A
    
    return [self getSubOrderTokenAndleftTicketStr];
    
}
-(void)changeImg:(UIButton*)btn
{
    
    
    
    
    NSString* urlString=@"https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=randp";
    //  LogInfo(@"%@",urlString);
    
    self.requestImg=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString ]] ;
    requestImg.accessibilityLabel=@"imgCode";
    
    [requestImg setValidatesSecureCertificate:NO];
    [requestImg setUseCookiePersistence:YES];
    [requestImg applyCookieHeader];
    //
    //    [requestImg addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init"];
    
    requestImg.delegate=(id<ASIHTTPRequestDelegate>)self;
    [requestImg startAsynchronous];
    
    [imgBtn setImage:nil forState:UIControlStateNormal];
    
    UIActivityIndicatorView* activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.tag=1231;
    activity.center=CGPointMake(30, 20);
    [activity startAnimating];
    [imgBtn addSubview:activity];
    [activity release];
    
    
    
    
}
- (void)requestFinished:(ASIHTTPRequest *)request_
{
    if (request_==requestImg) {
        
        [request_ applyCookieHeader];
        UIImage* img=[UIImage imageWithData:request_.responseData];
        
        [[imgBtn viewWithTag:1231] removeFromSuperview];
        [imgBtn setImage:img forState:UIControlStateNormal];
        
        // isCodeLoaded=YES;
    }
    //    if ([request_.accessibilityLabel isEqualToString:@"imgCode"]) {
    //
    //        [request_ applyCookieHeader];
    //        UIImage* img=[UIImage imageWithData:request_.responseData];
    //        [imgBtn setImage:img forState:UIControlStateNormal];
    //
    //        isCodeLoaded=YES;
    //    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[imgBtn viewWithTag:1231] removeFromSuperview];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:request.error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
	if ([tableView cellForRowAtIndexPath:indexPath].accessoryType!=UITableViewCellAccessoryNone) {
		//[tableView.delegate performSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)];
		
		[tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==2) {
        
        
        NSIndexPath* arrDictPath=[self arrayIndexToDataDictPath:indexPath.row];
        
        if (arrDictPath.row==0 ) {
            
            //BOOL b=[[self.passagesIsOpenArray objectAtIndex:arrDictPath.section] boolValue];
            
            BOOL isOpen= [[self.passagesIsOpenArray objectAtIndex:arrDictPath.section] boolValue];
            
            [self.passagesIsOpenArray replaceObjectAtIndex:arrDictPath.section  withObject:[NSNumber numberWithBool:!isOpen]];
            
            int rowsCountToChange=USER_INFO_ITEMS_COUNT;
            NSMutableArray* indexPaths=[NSMutableArray array];
            {
                for (int i=1; i<rowsCountToChange; i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row+i inSection:2]];
                }
                
            }
            
            //            [self.passagesArray removeObjectAtIndex:arrDictPath.section];
            //            [self.passagesIsOpenArray removeObjectAtIndex:arrDictPath.section];
            
            
            [self.tableView beginUpdates];
            if (!isOpen) {
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            }
            else{
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            }
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView endUpdates];
            
        }
        
        else if (arrDictPath.row==1 )
        {
            
            [self.view endEditing:YES];
            KeyValuePickerView *pickerView=[[KeyValuePickerView alloc] initWithTitle:@"席  别" delegate:self];
            pickerView.tag=indexPath.row;
            pickerView.dataArray=seatArray;
            pickerView.textField=@"text";
            pickerView.delegate=(id<PickerViewDelegate>)self;
            [pickerView showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];
            [pickerView release];
            
        }
        else if (arrDictPath.row==2 )
        {
            [self.view endEditing:YES];
            PickerView *pickerView=[[PickerView alloc] initWithTitle:@"票  种" delegate:self];
            
            pickerView.tag=indexPath.row;
            pickerView.dataArray=[NSMutableArray arrayWithObjects:@"成人",@"儿童",@"学生",@"伤残军人",nil];
            //pickerView.currentValue=[DDHelper nameForCode:[self.dataDict objectForKey:itemID] withKey:itemID];
            [pickerView showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];
            [pickerView release];
            
        }
        else if (arrDictPath.row==3 )
        {
            
        }
        else if (arrDictPath.row==4 )
        {
            
            [self.view endEditing:YES];
            //            KeyValuePickerView *pickerView=[[KeyValuePickerView alloc] initWithTitle:@"证件类型" delegate:self];
            //            pickerView.tag=indexPath.row;
            //            pickerView.dataArray=seatArray;
            //            pickerView.textField=@"text";
            //            pickerView.delegate=(id<PickerViewDelegate>)self;
            //            [pickerView showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];
            //            [pickerView release];
            
            PickerView *pickerView=[[PickerView alloc] initWithTitle:@"证件类型" delegate:self];
            pickerView.tag=indexPath.row;
            
            pickerView.dataArray=[NSMutableArray arrayWithObjects:@"二代身份证",@"一代身份证 ",@"港澳通行证",@"台湾通行证",@"护照",nil];
            //pickerView.currentValue=[DDHelper nameForCode:[self.dataDict objectForKey:itemID] withKey:itemID];
            [pickerView showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];
            [pickerView release];
            
        }
        
        else if (arrDictPath.row==5 )
            
        {
            
        }
        else if (arrDictPath.row==6 )
            
        {
            
        }
    }
}
-(void)pickerView:(PickerView*)picker didPickedWithValue:(NSObject*)value;

{
	NSIndexPath* indexPath=[NSIndexPath indexPathForRow:picker.tag inSection:2];
	UITableViewCell* cell= [self.tableView cellForRowAtIndexPath:indexPath];
    NSString* showText=@"";
    
    NSString* showTextValue=@"";
	
	if (cell) {
		
        UILabel* l=(UILabel*)cell.editingAccessoryView;
		if (l) {
            
            if ([picker isKindOfClass:[KeyValuePickerView class]]) {
                showText=[(NSMutableDictionary*)value objectForKey:((KeyValuePickerView*)picker).textField];
                showTextValue=[(NSMutableDictionary*)value objectForKey:@"value"];
                
            }else
            {
                showText=(NSString*)value;
                
                
                //showTextValue=[DDHelper ];
            }
            
			[l setText:showText];
		}
	}
    
    
    NSIndexPath* arrIndex=[self arrayIndexToDataDictPath:picker.tag];
    
    
    int sec=arrIndex.section;
    int row=arrIndex.row;
    
    //    @"0",@"index",
    //    @"1",@"xibie",
    //    @"1",@"piaozhong",
    //    @"",@"passenger_name",
    //    @"1",@"cardType",
    //    @"",@"cardNo",
    //    @"",@"phone",
    
    NSMutableDictionary* dict=  [self.passagesArray objectAtIndex:sec];
    
    if (row==0) {
        
    }else  if (row==1)
    {
        [dict setObject:showTextValue forKey:@"xibie"];
    }else  if (row==2)
    {
        [dict setObject:[DDHelper codeForName:showText withKey:@"userType"] forKey:@"piaozhong"];
        
    }else  if (row==3)
    {
        //[dict setObject:showText forKey:@"passenger_name"];
        
    }else  if (row==4)
    {
        [dict setObject:[DDHelper codeForName:showText withKey:@"idType"] forKey:@"cardType"];
        
    }else  if (row==5)
    {
        //[dict setObject:showText forKey:@"cardNo"];
    }else  if (row==5)
    {
        //[dict setObject:showText forKey:@"phone"];
    }
    
    
    
    
    
}
-(void)pickerViewCancle:(PickerView*)picker
{
    
    
}

-(NSIndexPath*)arrayIndexToDataDictPath:(NSInteger)index
{
    int c=0; int s=0;
    for (int i =0; i<=index;i++) {
        BOOL isOpen= [[passagesIsOpenArray objectAtIndex:s] boolValue];
        int willAddValue=isOpen?USER_INFO_ITEMS_COUNT:1;
        if (c+willAddValue>index) {
            break;
        }
        else
        {
            s++;
            c+=willAddValue;
        }
    }
    return [NSIndexPath indexPathForRow:index-c inSection:s];
}
-(NSInteger)rowIndexForArrDict:(NSIndexPath*)index
{
    
    int c=0;
    
    
    for (int i =0; i<=index.section;i++) {
        {
            BOOL isOpen= [[passagesIsOpenArray objectAtIndex:i] boolValue];
            if (isOpen)
            {
                c+=USER_INFO_ITEMS_COUNT;
            }else
            {
                c+=1;
            }
            if (i==index.section) {
                c+=index.row;
            }
        }
        
        
    }
    return c;
}


-(NSString*)seatTypeTextForValue:(NSString*)key
{
    
    for (NSMutableDictionary* dict in seatArray) {
        if ([[dict objectForKey:@"value"] isEqualToString:key]) {
            return [dict objectForKey:@"text"];
        }
    }
    return @"";
}

-(NSString*)seatTypeValueForText:(NSString*)text
{
    
    if ([text hasPrefix:@"硬座"]) {
        return @"2";
    }
    return  @"1";
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    NSIndexPath* arrIndex=[self arrayIndexToDataDictPath:textField.tag];
    int sec=arrIndex.section;
    int row=arrIndex.row;
    
    //    @"0",@"index",
    //    @"1",@"xibie",
    //    @"1",@"piaozhong",
    //    @"",@"passenger_name",
    //    @"1",@"cardType",
    //    @"",@"cardNo",
    //    @"",@"phone",
    
    NSMutableDictionary* dict=  [self.passagesArray objectAtIndex:sec];
    
    if (row==0) {
        
    }else  if (row==1)
    {
        //[dict setObject:showTextValue forKey:@"xibie"];
    }else  if (row==2)
    {
        //[dict setObject:[DDHelper codeForName:showText withKey:@"userType"] forKey:@"piaozhong"];
        
    }else  if (row==3)
    {
        [dict setObject:textField.text forKey:@"passenger_name"];
        
    }else  if (row==4)
    {
        //[dict setObject:[DDHelper codeForName:showText withKey:@"idType"] forKey:@"cardType"];
        
    }else  if (row==5)
    {
        [dict setObject:textField.text forKey:@"cardNo"];
    }else  if (row==5)
    {
        [dict setObject:textField.text forKey:@"phone"];
    }
}

-(void)reloadCheckCode
{
    [self changeImg:nil]; 
}
@end
