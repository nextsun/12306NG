//
//  StationListController.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StationListController;

@protocol StationListControllerDelegate <NSObject>
- (void)listView:(StationListController *)listView didSelectWithValue:(NSString*)stationName;
@end




@interface DataSourceProvider:NSObject{
    NSMutableArray* dataArray;
}
@property(nonatomic,retain) NSMutableArray* dataArray;
+(DataSourceProvider*)sharedDataSourceProvider;
@end


@interface StationListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString* name;
    NSInteger tag;
    NSMutableArray* stationArray;
    NSMutableArray* resultArray;
    UISearchBar *searchBar;
    UITableView *tableView;
    
    id<StationListControllerDelegate> delegate;
}
@property(nonatomic,retain) NSString* name;
@property(nonatomic,assign) NSInteger tag;
@property(nonatomic,retain) NSMutableArray* stationArray;
@property(nonatomic,retain) NSMutableArray* resultArray;
@property(nonatomic,retain) UISearchBar *searchBar;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) id<StationListControllerDelegate> delegate;

@end
