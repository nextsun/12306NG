//
//  ChooseTravelCompanionViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "ChooseTravelCompanionViewController.h"
#import "PickerView.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

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


@interface ChooseTravelCompanionViewController ()

@end


@implementation ChooseTravelCompanionViewController

@synthesize tableview;
@synthesize currentTextField;
@synthesize currentIndexPath;
@synthesize selectedPassengers;
@synthesize seatTypes;

@synthesize chooseDelegate;


#pragma mark - init & destroy 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor clearColor];
        self.navigationItem.title = @"选择旅客";
        
        cardTypes = [[NSDictionary dictionaryWithObjectsAndKeys:
                     @"二代身份证",@"1", 
                     @"一代身份证",@"2", 
                     @"港澳通行证",@"C", 
                     @"台湾通行证",@"G", 
                     @"护照",@"B", nil] retain];
        
        ticketTypes = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"成人票",@"1",
                       @"儿童票",@"2", 
                       @"学生票",@"3", 
                       @"残军票",@"4",  nil] retain];
    }
    return self;
}


- (void) dealloc
{
    [passengers release];
    [cardTypes release];
    [seatTypes release];
    [ticketTypes release];
    [currentIndexPath release];
    [currentTextField release];
    [super dealloc];
}


#pragma mark - view lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_black"]];
    
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置旅客";
    [self showCustomBackButton];
    self.navigationItem.rightBarButtonItem = [self commitButtonItem];
    
    self.seatTypes = [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSArray arrayWithObjects:@"硬座",@"202.00", nil],@"1",
                 [NSArray arrayWithObjects:@"软座",@"302.00", nil],@"2",
                 [NSArray arrayWithObjects:@"硬卧",@"402.00", nil],@"3",  nil];
    
    
    passengers = [[NSMutableArray alloc] init];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}


- (void) viewDidUnload
{
    [passengers release];
    passengers = nil;
    
    [currentIndexPath release];
    currentIndexPath = nil;
    
    [currentTextField release];
    currentTextField = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIBarButtonItem*) commitButtonItem
{
    NGCustomButton* subButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [subButton addTarget:self action:@selector(onSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    subButton.titleLabel.text=@"确定";
    UIBarButtonItem* btn=[[UIBarButtonItem alloc] initWithCustomView:subButton];
    return [btn autorelease];
}


- (void) onSubmitClick
{
    if ( currentTextField ) {
        [self textFieldDidEndEditing:currentTextField];
    }

    NSMutableArray* allSelectedPassengers = [NSMutableArray array];
    for ( PassengerModel* passenger in passengers ) {
        if ( passenger.selectedFlag ) {
            NSLog(@"%@",passenger);
            [allSelectedPassengers addObject:passenger];
        }
    }

    
    if (chooseDelegate&&[chooseDelegate respondsToSelector:@selector(chooseTravelViewController:didChosenWithArray:)]) {
        
        [chooseDelegate chooseTravelViewController:self didChosenWithArray:allSelectedPassengers];
        
    }
    [self.navigationController popViewControllerAnimated:YES];

    
}


- (void) onSelectRadioButtonClick:(id)sender
{
    UIButton* button = (UIButton*)sender;
    int section = button.tag - TAG_CELL_SELECTRADIO;
    PassengerModel* passenger = [passengers objectAtIndex:section];
    if ( passenger.selectedFlag ) {
        passenger.selectedFlag = NO;
        [button setImage:[UIImage imageNamed:@"sex_radio.png"] forState:UIControlStateNormal];
    }
    else {
        passenger.selectedFlag = YES;
        [button setImage:[UIImage imageNamed:@"sex_radio_chosed.png"] forState:UIControlStateNormal];
    }
}



#pragma mark - UITableView delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [passengers count];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    PassengerModel* passenger = [passengers objectAtIndex:section];
    
    NSString* cellId = @"PassengerSelectCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    else {
        for ( UIView* v in cell.contentView.subviews ) {
            [v removeFromSuperview];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    CGRect titleRect = CGRectMake(20, 10, 70, 20);
    CGRect textFieldRect = CGRectMake(100, 5, 170, 30);
    CGRect valueLabelRect = CGRectMake(100, 10, 180, 20);
    UIFont* valueLabelFont = [UIFont boldSystemFontOfSize:16];
    
    switch (row) {
        case 0:
        {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20, 10, 20, 20);
            if ( passenger.selectedFlag ) {
                [button setImage:[UIImage imageNamed:@"sex_radio_chosed.png"] forState:UIControlStateNormal];
            }
            else {
                [button setImage:[UIImage imageNamed:@"sex_radio.png"] forState:UIControlStateNormal];
            }
            button.tag = TAG_CELL_SELECTRADIO + section;
            [button addTarget:self action:@selector(onSelectRadioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 230, 20)];
            label.font = [UIFont boldSystemFontOfSize:18];
            label.text = @"选中为本旅客预定火车票";
            [cell.contentView addSubview:label];
            [label release];
            break;
        }
        case 1:
        {
            UILabel* label = [[UILabel alloc] initWithFrame:titleRect];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"姓    名";
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            UITextField* textField = [[UITextField alloc] initWithFrame:textFieldRect];
            textField.tag = TAG_CELL_NAME + section;
            textField.borderStyle = UITextBorderStyleLine;
            textField.placeholder = @"旅客姓名...";
            textField.text = passenger.passenger_name;
            textField.font = [UIFont systemFontOfSize:16];
            textField.delegate = self;
            [cell.contentView addSubview:textField];
            [textField release];
            break;
        }
        case 2:
        {
            UILabel* label = [[UILabel alloc] initWithFrame:titleRect];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"证件类型";
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            label = [[UILabel alloc] initWithFrame:valueLabelRect];
            label.tag = TAG_CELL_CARDTYPE;
            label.font = valueLabelFont;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            label.text = [cardTypes objectForKey:passenger.passenger_id_type_code];
            [label release];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 3:
        {
            UILabel* label = [[UILabel alloc] initWithFrame:titleRect];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"证件号码";
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];

            UITextField* textField = [[UITextField alloc] initWithFrame:textFieldRect];
            textField.tag = TAG_CELL_CARDNO + section;
            textField.borderStyle = UITextBorderStyleLine;
            textField.placeholder = @"证件号码...";
            textField.text = passenger.passenger_id_no;
            textField.font = [UIFont systemFontOfSize:16];
            textField.delegate = self;
            [cell.contentView addSubview:textField];
            [textField release];
            break;
        }
        case 4:
        {
            UILabel* label = [[UILabel alloc] initWithFrame:titleRect];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"席    别";
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];

            label = [[UILabel alloc] initWithFrame:valueLabelRect];
            label.tag = TAG_CELL_SEATTYPE;
            NSArray* arr = (NSArray*) [seatTypes objectForKey:passenger.seatType];
            label.text = [arr objectAtIndex:0];
            label.font = valueLabelFont;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 5:
        {
            UILabel* label = [[UILabel alloc] initWithFrame:titleRect];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"票    种";
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];

            label = [[UILabel alloc] initWithFrame:valueLabelRect];
            label.tag = TAG_CELL_TICKETTYPE;
            label.text = [ticketTypes objectForKey:passenger.ticketType];
            label.font = valueLabelFont;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 6:
        {
            UILabel* label = [[UILabel alloc] initWithFrame:titleRect];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"手 机 号";
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            UITextField* textField = [[UITextField alloc] initWithFrame:textFieldRect];
            textField.tag = TAG_CELL_MOBILE + section;
            textField.borderStyle = UITextBorderStyleLine;
            textField.placeholder = @"手机号...";
            textField.text = passenger.mobile_no;
            textField.font = [UIFont systemFontOfSize:16];
            textField.delegate = self;
            [cell.contentView addSubview:textField];
            [textField release];
            break;
        }
            
        default:
            break;
    }
    
    
    return cell;
}


- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    if ( currentTextField ) {
        [currentTextField resignFirstResponder];
    }

    int row = indexPath.row;
    if ( row == 1 || row == 3 || row == 6 ) return nil;
    else return indexPath;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    PassengerModel* passenger = [passengers objectAtIndex:section];
    
    NSLog(@"cell.frame.origin.y = %f",cell.frame.origin.y);
    
    if ( row == 0 ) {
        UIButton* button = (UIButton*) [cell.contentView viewWithTag:(TAG_CELL_SELECTRADIO + indexPath.section)];
        [self onSelectRadioButtonClick:button];
    }
    else if ( row == 2 ) {
        PickerView *pickerView=[[PickerView alloc] initWithTitle:@"证件类型" delegate:self];
        pickerView.tag = TAG_PICKER_CARDTYPE;
        pickerView.dataArray = [ChooseTravelCompanionViewController valuesSortedByKey:cardTypes];
        pickerView.currentValue = [cardTypes objectForKey:passenger.passenger_id_type_code];
        [pickerView showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];
        [pickerView release];
    }
    else if ( row == 4 ) {
        PickerView *pickerView=[[PickerView alloc] initWithTitle:@"席别" delegate:self];
        pickerView.tag = TAG_PICKER_SEATTYPE;
        pickerView.dataArray = [ChooseTravelCompanionViewController allSeatnames:seatTypes];
        NSArray* arr = [seatTypes objectForKey:passenger.seatType];
        pickerView.currentValue = [arr objectAtIndex:0];
        [pickerView showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];
        [pickerView release];
    }
    else if ( row == 5 ) {
        PickerView *pickerView=[[PickerView alloc] initWithTitle:@"票种" delegate:self];
        pickerView.tag = TAG_PICKER_TICKETTYPE;
        pickerView.dataArray = [ChooseTravelCompanionViewController valuesSortedByKey:ticketTypes];
        pickerView.currentValue = [ticketTypes objectForKey:passenger.ticketType];
        [pickerView showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];
        [pickerView release];
    }
    
    if ( row == 2 || row == 4 || row == 5 ) {
        CGFloat y = cell.frame.origin.y + 40;
        int pickerHeight = 260;
        if ( y > 416 - pickerHeight ) {
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint offset = tableView.contentOffset;
                offset.y += 200;
                tableView.contentOffset = CGPointMake(0, y - (416 - pickerHeight) + 5 );
            }];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - pick delegate

-(void)pickerView:(PickerView*)picker didPickedWithValue:(NSObject*)value
{
    PassengerModel* passenger = [passengers objectAtIndex:currentIndexPath.section];
    
    UITableViewCell* cell = nil;
    if ( currentIndexPath ) {
        cell = [tableview cellForRowAtIndexPath:currentIndexPath];
    }
    
    if ( picker.tag == TAG_PICKER_CARDTYPE ) {
        //证件类型
        if ( cell ) {
            UILabel* label = (UILabel*) [cell.contentView viewWithTag:TAG_CELL_CARDTYPE];
            label.text = (NSString*) value;
        }
    
        passenger.passenger_id_type_code = [ChooseTravelCompanionViewController keyForDictionary:cardTypes byValue:(NSString*)value];
    }
    else if ( picker.tag == TAG_PICKER_SEATTYPE ) {
        //席别
        if ( cell ) {
            UILabel* label = (UILabel*) [cell.contentView viewWithTag:TAG_CELL_SEATTYPE];
            label.text = (NSString*) value;
        }
        
        passenger.seatType = [self seatTypeByName:(NSString*)value];
    }
    else if ( picker.tag == TAG_PICKER_TICKETTYPE ) {
        //票种
        if ( cell ) {
            UILabel* label = (UILabel*) [cell.contentView viewWithTag:TAG_CELL_TICKETTYPE];
            label.text = (NSString*) value;
        }
        
        passenger.ticketType = [ChooseTravelCompanionViewController keyForDictionary:ticketTypes byValue:(NSString*)value];
    }
}



- (void) pickerViewCancle:(PickerView *)picker
{
}


#pragma mark - UITextField Delegate


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;

    int section = textField.tag % 100;
    int tag = (textField.tag / 100) * 100;
    NSIndexPath* indexPath = nil;
    
    if ( tag == TAG_CELL_NAME ) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:section];
    }
    else if ( tag == TAG_CELL_CARDNO ) {
        indexPath = [NSIndexPath indexPathForRow:3 inSection:section];
    }
    else if ( tag == TAG_CELL_MOBILE ) {
        indexPath = [NSIndexPath indexPathForRow:6 inSection:section];
    }
    
    UITableViewCell* cell = [tableview cellForRowAtIndexPath:indexPath];
    if ( cell ) {
        CGFloat y = cell.frame.origin.y + 40;
        int keyboardHeight = 246;
        if ( y > 416 - keyboardHeight ) {
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint offset = tableview.contentOffset;
                offset.y += 200;
                tableview.contentOffset = CGPointMake(0, y - (416 - keyboardHeight) + 5 );
            }];
        }
    }
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    int section = textField.tag % 100;
    int tag = (textField.tag / 100) * 100;
    
    PassengerModel* passenger = [passengers objectAtIndex:section];

    if ( tag == TAG_CELL_NAME ) {
        passenger.passenger_name = textField.text;
    }
    else if ( tag == TAG_CELL_CARDNO ) {
        passenger.passenger_id_no = textField.text;
    }
    else if ( tag == TAG_CELL_MOBILE ) {
        passenger.mobile_no = textField.text;
    }
}

#pragma mark - load data from server

- (void) loadData
{
    MBProgressHUD* HUD=[[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"  正在查询常用联系人...    ";
    HUD.margin = 30.f;
    HUD.yOffset = -45.f;
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(doRequestData) onTarget:self withObject:nil animated:YES];
    
    [HUD release];
}


- (void) doRequestData
{
    NSURL* url = [NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=getpassengerJson"];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"POST";
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    [request setValidatesSecureCertificate:NO];
    [request setUseCookiePersistence:YES];
    [request applyCookieHeader];
    [request addRequestHeader:@"Accept" value:@"Accept	application/json, text/javascript, */*"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    [request addRequestHeader:@"Content-Length" value:@"0"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
    [request startSynchronous];

    
    //Accept	application/json, text/javascript, */*
    //Accept-Encoding	gzip, deflate
    //Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //Cache-Control	no-cache
    //Connection	keep-alive
    //Content-Length	0
    //Content-Type	application/x-www-form-urlencoded
    //Cookie	JSESSIONID=EF121A42EDAFFD5C583AF4ACCE1635E4; BIGipServerotsweb=2329149706.22560.0000
    //Host	dynamic.12306.cn
    //Pragma	no-cache
    //Referer	https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init
    //User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20100101 Firefox/17.0
    //X-Requested-With	XMLHttpRequest

    NSString* responseString = request.responseString;
    NSLog(@"%@",responseString);
    
    id json = [responseString JSONValue];
    if ( [json isKindOfClass:[NSDictionary class]] ) {
        NSDictionary* dic = (NSDictionary*) json;
        [self parseResponseData:dic];
    }
}


- (void) parseResponseData:(NSDictionary*)responseData
{
    [passengers removeAllObjects];
    
    id value = [responseData objectForKey:@"passengerJson"];
    if ( !value || value == [NSNull null] || ![value isKindOfClass:[NSArray class]] ) return;

    NSArray* arr = (NSArray*)value;
    NSDictionary* dic = nil;
    PassengerModel* passenger = nil;

    for ( value in arr ) {
        if ( !value || value == [NSNull null] || ![value isKindOfClass:[NSDictionary class]] ) continue;
        dic = (NSDictionary*)value;

        id v = [dic objectForKey:@"passenger_id_no"];
        if ( !v || ![v isKindOfClass:[NSString class]] ) continue;
        
        passenger = [ChooseTravelCompanionViewController passengerByNo:v passengers:selectedPassengers];
        if ( passenger ) {
            passenger.selectedFlag = YES;
            [passengers addObject:passenger];
            continue;
        }

        passenger = [[PassengerModel alloc] init];
        
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.passenger_id_no = v;
        }
        

        v = [dic objectForKey:@"first_letter"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.first_letter = v;
        }

        v = [dic objectForKey:@"isUserSelf"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.isUserSelf = v;
        }

        v = [dic objectForKey:@"mobile_no"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.mobile_no = v;
        }

        v = [dic objectForKey:@"old_passenger_id_no"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.old_passenger_id_no = v;
        }

        v = [dic objectForKey:@"old_passenger_id_type_code"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.old_passenger_id_type_code = v;
        }

        v = [dic objectForKey:@"old_passenger_name"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.old_passenger_name = v;
        }

        v = [dic objectForKey:@"passenger_flag"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.passenger_flag = v;
        }

        v = [dic objectForKey:@"passenger_id_type_code"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.passenger_id_type_code = v;
        }

        v = [dic objectForKey:@"passenger_id_type_name"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.passenger_id_type_name = v;
        }

        v = [dic objectForKey:@"passenger_name"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.passenger_name = v;
        }

        v = [dic objectForKey:@"passenger_type"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.passenger_type = v;
        }

        v = [dic objectForKey:@"passenger_type_name"];
        if ( v && [v isKindOfClass:[NSString class]] ) {
            passenger.passenger_type_name = v;
        }
        
        [passengers addObject:passenger];
        [passenger release];
    }

    [self.tableview reloadData];
}


#pragma mark - tools

+ (id) keyForDictionary:(NSDictionary*)dic byValue:(NSString*)value
{
    NSArray* keys = [dic allKeys];
    for ( id key in keys ) {
        NSString* v = [dic objectForKey:key];
        if ( [v compare:value] == NSOrderedSame ) {
            return key;
        }
    }
    return nil;
}


+ (NSMutableArray*) valuesSortedByKey:(NSDictionary*)dic
{
    NSArray* keys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray* values = [NSMutableArray array];
    for ( id key in keys ) {
        [values addObject:[dic objectForKey:key]];
    }
    return values;
}


+ (NSMutableArray*) allSeatnames:(NSDictionary*)seatsTypes
{
    NSArray* keys = [[seatsTypes allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray* values = [NSMutableArray array];
    for ( id key in keys ) {
        NSArray* arr = [seatsTypes objectForKey:key];
        [values addObject:[arr objectAtIndex:0]];
    }
    
    return values;
}


- (NSString*) seatTypeByName:(NSString*)seatName
{
    NSArray* keys = [seatTypes allKeys];
    for ( id key in keys ) {
        NSArray* arr = [seatTypes objectForKey:key];
        if ( [seatName compare:[arr objectAtIndex:0]] == NSOrderedSame ) {
            return key;
        }
    }
    return nil;
}


+ (PassengerModel*) passengerByNo:(NSString*)passengerNo passengers:(NSArray*)passengers
{
    for ( PassengerModel* passenger in passengers ) {
        if ( [passengerNo compare:passenger.passenger_id_no] == NSOrderedSame ) {
            return passenger;
        }
    }
    return nil;
}


@end
