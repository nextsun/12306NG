//
//  UserCenterViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGTileMenuController.h"

@interface UserCenterViewController : UIViewController<MGTileMenuDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray* tableArray;
    UITableView* mainTableView;
}

@property (strong, nonatomic) MGTileMenuController *tileController;

@end
