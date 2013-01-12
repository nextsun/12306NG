//
//  TicketsListWithCodeController.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



#define TAG_START_STATION 100
#define TAG_END_STATION 101







@class StationListWithCodeController;






@interface StationInfo : NSObject{
    NSString* stationName;
    NSString* stationCode;
    NSString* stationPinYin;
    NSString* stationIndex;

}
@property(nonatomic,retain)NSString* stationName;
@property(nonatomic,retain)NSString* stationCode;
@property(nonatomic,retain)NSString* stationPinYin;
@property(nonatomic,retain)NSString* stationIndex;
@end

@protocol StationListWithCodeControllerDelegate <NSObject>
- (void)listStationView:(StationListWithCodeController *)listView didSelectWithValue:(StationInfo*)stationInfo;
@end




@interface StationListWithCodeController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
{
        
    NSString* name;
    NSInteger tag;
    id<StationListWithCodeControllerDelegate> delegate;    
    StationInfo* infoStart;
    StationInfo* infoEnd;
    
    
    
@private;
    
    NSMutableArray* stationArray;
    NSMutableArray* resultArray;
        
    UISearchBar *searchBar;    
    UISegmentedControl* segCtl;
    UIScrollView* mainView;
    UITableView *tableView1;
    UITableView *tableView2;
    
    NSInteger pageIndex;
    
}
@property(nonatomic,retain) NSString* name;
@property(nonatomic,assign) NSInteger tag;
@property(nonatomic,retain)StationInfo* infoStart;
@property(nonatomic,retain)StationInfo* infoEnd;

@property(nonatomic,retain) id<StationListWithCodeControllerDelegate> delegate;

@end

