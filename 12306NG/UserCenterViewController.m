//
//  UserCenterViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "AppDelegate.h"
#import "NGCustomButton.h"
#import "iVersion.h"

#import "CMBPayViewController.h"


#import "UserCenterViewController.h"


//Section0
#import "UserInfomationViewController.h"

//Section1
#import "QueryTicketViewController.h"
#import "OrderListViewController.h"


//Section2
#import "ResidualTicketInformViewController.h"

//Section3
#import "FeedbackViewController.h"
#import "AboutUsViewController.h"

#import "BookingTicketViewController.h"

@interface UserCenterViewController ()
@property(nonatomic,retain)NSMutableArray* tableArray;
@property(nonatomic,retain)UITableView* mainTableView;

@end

@implementation UserCenterViewController
@synthesize tableArray,mainTableView;

@synthesize tileController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableArray=[NSMutableArray arrayWithObjects:
                         [NSMutableArray arrayWithObjects:
                          NSLocalizedString(@"我的资料",nil),
                          NSLocalizedString(@"同行旅客管理",nil),nil],
                         [NSMutableArray arrayWithObjects:
                          NSLocalizedString(@"车票查询",nil),
                          NSLocalizedString(@"我的订单",nil),nil],
                         
                         [NSMutableArray arrayWithObjects:
                          NSLocalizedString(@"余票通知",nil),
                          NSLocalizedString(@"订单通知",nil),nil],
                         
                         [NSMutableArray arrayWithObjects:
                          NSLocalizedString(@"意见反馈",nil),
                          //NSLocalizedString(@"购票攻略",nil),
                          NSLocalizedString(@"软件评分",nil),
//                          NSLocalizedString(@"检测新版本",nil),
                          NSLocalizedString(@"分享给好友",nil),
                          NSLocalizedString(@"关于我们",nil),nil],
                         nil];
        
    }
    return self;
}
-(void)Exit
{
    AppDelegate* app=[UIApplication sharedApplication].delegate;
    [app didLoginOut];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor clearColor];
    self.title=@"我的抢票助手";
    NGCustomButton* subButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [subButton addTarget:self action:@selector(Exit) forControlEvents:UIControlEventTouchUpInside];
    subButton.titleLabel.text=@"注销";
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:subButton] autorelease];
    [subButton release];
    
    UILabel* lbl=[[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] autorelease];
    [lbl setText:[NSString stringWithFormat:@"[%@]",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]]];
    lbl.textColor=[UIColor whiteColor];
    lbl.textAlignment=UITextAlignmentRight;
    lbl.backgroundColor=[UIColor clearColor];
//    [[UIBarButtonItem alloc] initWithCustomView:lbl]
    
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:lbl] autorelease];
    
    //CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-44);
    self.mainTableView=[[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease]  ;
    [self.view addSubview:self.mainTableView];
    mainTableView.backgroundColor=[UIColor clearColor];
    mainTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    mainTableView.backgroundView=nil;
    mainTableView.dataSource=(id<UITableViewDataSource>)self;
    mainTableView.delegate=(id<UITableViewDelegate>)self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	tapRecognizer.delegate = self;
	[self.view addGestureRecognizer:tapRecognizer];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [[tableArray objectAtIndex:section]  count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell_ABC";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
        if (indexPath.section==2) {
            UISwitch* inputMethod=[[UISwitch alloc] initWithFrame:CGRectMake(210, 9, 100, 50)];
            //[inputMethod setOn:[GlobalClass sharedClass].isEnableBaiduInput animated:YES];
            [inputMethod addTarget:self action:@selector(swithChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView=inputMethod;
            [inputMethod release];
        }
        
    } 
    cell.textLabel.text=[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    

    
    return cell ;
}

#pragma mark -
#pragma mark  tableViewAction

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
/***********************************************************************/     
    if (indexPath.section==0&&indexPath.row==0) 
    {
        UserInfomationViewController* controller=[[UserInfomationViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if (indexPath.section==0&&indexPath.row==1)
    {
        UserInfomationViewController* controller=[[UserInfomationViewController alloc] init];
        controller.userInfoKey=UserInfoOther;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
 
    }
/***********************************************************************/   
    if (indexPath.section==1&&indexPath.row==0) 
    {
        QueryTicketViewController* controller=[[QueryTicketViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if (indexPath.section==1&&indexPath.row==1)
    {
        OrderListViewController* controller=[[OrderListViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
/***********************************************************************/ 
    if (indexPath.section==2&&indexPath.row==0) 
    {
//        ResidualTicketInformViewController* controller=[[ResidualTicketInformViewController alloc] init];
//        [self.navigationController pushViewController:controller animated:YES];
//        [controller release];
    }
    else if (indexPath.section==2&&indexPath.row==1)
    {
//        UserInfomationViewController* controller=[[UserInfomationViewController alloc] init];
//        [self.navigationController pushViewController:controller animated:YES];
//        [controller release];
    }
/***********************************************************************/ 
    if (indexPath.section==3&&indexPath.row==0) 
    {
        
        if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mail=[[MFMailComposeViewController alloc] init];
           // mail.navigationItem.leftBarButtonItem=[]
        
        
        [mail setToRecipients:@[@"12306helper@gmail.com"]];
        mail.mailComposeDelegate=(id<MFMailComposeViewControllerDelegate>)self;
         mail.navigationBar.tintColor=[UIColor blackColor];
        
        //[mail.topViewController showCustomBackButton];
        
        [self presentModalViewController:mail animated:YES];
        
        }
//        FeedbackViewController* controller=[[FeedbackViewController alloc] init];
//        [self.navigationController pushViewController:controller animated:YES];
//        [controller release];
    }
//    else if (indexPath.section==3&&indexPath.row==1)
//    {
//        CMBPayViewController* cmbpay=[[CMBPayViewController alloc] init];
//        [self.navigationController pushViewController:cmbpay animated:YES];
//        [cmbpay release];
//        
//      
//
//        
//    }
    else if (indexPath.section==3&&indexPath.row==1)
    {
        NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Utilities+Travel&id=%@",
                         @"594813046" ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
//    else if (indexPath.section==3&&indexPath.row==3)
//    {        
//        [[iVersion sharedInstance] checkForNewVersion];
//
//    }
    else if (indexPath.section==3&&indexPath.row==2)
    {
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"正在完善，请等待下个版本！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];

    
//
//        if (!tileController || tileController.isVisible == NO) {
//			if (!tileController) {
//				// Create a tileController.
//				tileController = [[MGTileMenuController alloc] initWithDelegate:self];
//				tileController.dismissAfterTileActivated = NO; // to make it easier to play with in the demo app.
//			}
//			// Display the TileMenu.
//			[tileController displayMenuCenteredOnPoint:MGCenterPoint(self.view.bounds) inView:self.view];
//		}
        
    }
    else if (indexPath.section==3&&indexPath.row==3)
    {
        
//        BookingTicketViewController* book=[[BookingTicketViewController alloc] initWithStyle:UITableViewStyleGrouped];
//        //book.orderString=ticketModel.orderString;
//        [self.navigationController pushViewController:book animated:YES];
//        [book release];
//

        AboutUsViewController* controller=[[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType!=UITableViewCellAccessoryNone) {        
        [tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swithChanged:(UISwitch*)sender
{
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result==MFMailComposeResultFailed) {
        
    }
    [controller dismissModalViewControllerAnimated:YES];
}


#pragma mark - TileMenu delegate


- (NSInteger)numberOfTilesInMenu:(MGTileMenuController *)tileMenu
{
	return 6;
}


- (UIImage *)imageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *images = [NSArray arrayWithObjects:
					   @"",//新浪微博
					   @"",//微信
					   @"",//微信
					   @"",//短信
					   @"",//邮件
					   @"",//微博
					   @"Text",
					   @"heart",
					   @"gear",
					   nil];
	if (tileNumber >= 0 && tileNumber < images.count) {
		return [UIImage imageNamed:[images objectAtIndex:tileNumber]];
	}
	
	return [UIImage imageNamed:@"Text"];
}


- (NSString *)labelForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *labels = [NSArray arrayWithObjects:
					   @"Twitter",
					   @"Key",
					   @"Speech balloon",
					   @"Magnifying glass",
					   @"Scissors",
					   @"Actions",
					   @"Text",
					   @"Heart",
					   @"Settings",
					   nil];
	if (tileNumber >= 0 && tileNumber < labels.count) {
		return [labels objectAtIndex:tileNumber];
	}
	
	return @"Tile";
}


- (NSString *)descriptionForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *hints = [NSArray arrayWithObjects:
                      @"Sends a tweet",
                      @"Unlock something",
                      @"Sends a message",
                      @"Zooms in",
                      @"Cuts something",
                      @"Shows export options",
                      @"Adds some text",
                      @"Marks something as a favourite",
                      @"Shows some settings",
                      nil];
	if (tileNumber >= 0 && tileNumber < hints.count) {
		return [hints objectAtIndex:tileNumber];
	}
	
	return @"It's a tile button!";
}


- (UIImage *)backgroundImageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	if (tileNumber == 0) {
		return [UIImage imageNamed:@"sinawb"];
	} else if (tileNumber == 1) {
		return [UIImage imageNamed:@"weixin"];
	} else if (tileNumber == 2) {
		return [UIImage imageNamed:@"weixin"];
	} else if (tileNumber == 3) {
		return [UIImage imageNamed:@"mail"];
	} else if (tileNumber == 4) {
		return [UIImage imageNamed:@"msg"];
	}
    else if (tileNumber == 5) {
		return [UIImage imageNamed:@"qqwb"];
	}else if (tileNumber == -1) {
		return [UIImage imageNamed:@"grey_gradient"];
	}
	
//    if (tileNumber == 1) {
//		return [UIImage imageNamed:@"purple_gradient"];
//	} else if (tileNumber == 4) {
//		return [UIImage imageNamed:@"orange_gradient"];
//	} else if (tileNumber == 7) {
//		return [UIImage imageNamed:@"red_gradient"];
//	} else if (tileNumber == 5) {
//		return [UIImage imageNamed:@"yellow_gradient"];
//	} else if (tileNumber == 8) {
//		return [UIImage imageNamed:@"green_gradient"];
//	} else if (tileNumber == -1) {
//		return [UIImage imageNamed:@"grey_gradient"];
//	}
    
	return [UIImage imageNamed:@"blue_gradient"];
}


- (BOOL)isTileEnabled:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
//	if (tileNumber == 2 || tileNumber == 6) {
//		return NO;
//	}
	
	return YES;
}


- (void)tileMenu:(MGTileMenuController *)tileMenu didActivateTile:(NSInteger)tileNumber
{
	//NSLog(@"Tile %d activated (%@)", tileNumber, [self labelForTile:tileNumber inMenu:tileController]);
    
    
    switch (tileNumber) {
        case 0://新浪微博
        {
            
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"稍后推出！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            
             break;
        }
        case 1://微信
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"稍后推出！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            

            break;
        }
        case 2://微信朋友圈
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"稍后推出！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            

            break;
        }
        case 3://邮件
        {
            
            
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController* mail=[[MFMailComposeViewController alloc] init];
                mail.mailComposeDelegate=(id<MFMailComposeViewControllerDelegate>)self;
                //[mail setMessageBody:@"" isHTML:NO];
                mail.navigationBar.tintColor=[UIColor blackColor];
                [self presentModalViewController:mail animated:YES];
                
            }

            
            
            break;
        }
        case 4://短信
        {
            
            
            if ( [MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController* msg=[[MFMessageComposeViewController alloc] init];
                
                
                  msg.navigationBar.tintColor=[UIColor blackColor];
                [self presentModalViewController:msg animated:YES];
            }
            
            break;
        }
        case 5://qq微博
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"稍后推出！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            

            break;
        }
           
            
        default:
            break;
    }
    
    [tileMenu dismissMenu];

    
}


- (void)tileMenuDidDismiss:(MGTileMenuController *)tileMenu
{
	tileController = nil;
}


#pragma mark - Gesture handling


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	// Ensure that only touches on our own view are sent to the gesture recognisers.
    
    if (!tileController || tileController.isVisible == NO){
        return NO;
    }
    
	if (touch.view == tileController.view|| [touch.view isKindOfClass:[UIButton class]]) {
		return NO;
	}
	return YES;
	
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
	// Find out where the gesture took place.
	CGPoint loc = [gestureRecognizer locationInView:self.view];
	if ([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]] && ((UITapGestureRecognizer *)gestureRecognizer).numberOfTapsRequired == 2) {
		// This was a double-tap.
		// If there isn't already a visible TileMenu, we should create one if necessary, and show it.
		if (!tileController || tileController.isVisible == NO) {
			if (!tileController) {
				// Create a tileController.
				tileController = [[MGTileMenuController alloc] initWithDelegate:self];
				tileController.dismissAfterTileActivated = YES; // to make it easier to play with in the demo app.
			}
			// Display the TileMenu.
			[tileController displayMenuCenteredOnPoint:loc inView:self.view];
		}
		
	} else {
		// This wasn't a double-tap, so we should hide the TileMenu if it exists and is visible.
		if (tileController && tileController.isVisible == YES) {
			// Only dismiss if the tap wasn't inside the tile menu itself.
			if (!CGRectContainsPoint(tileController.view.frame, loc)) {
				[tileController dismissMenu];
			}
		}
	}
}

@end
