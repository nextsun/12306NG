//
//  TicketsFilterVIew.h
//  12306NG
//
//  Created by Lei Sun on 1/22/13.
//  Copyright (c) 2013 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TicketsFilterView;
@protocol TicketsFilterViewDelegate
-(void)ticketsFilterView:(TicketsFilterView*)picker didChangFilterKeys:(NSArray*)keys;
@end

@interface TicketsFilterView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray* keys;
    NSMutableArray* values;
    
    NSMutableArray* selectedKeys;
    
    id<TicketsFilterViewDelegate> filterdelegate;
    
}
@property(nonatomic,retain)NSMutableArray* selectedKeys;
@property(nonatomic,assign)id<TicketsFilterViewDelegate> filterdelegate;
@end
