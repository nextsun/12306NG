//
//  TicketsFilterVIew.m
//  12306NG
//
//  Created by Lei Sun on 1/22/13.
//  Copyright (c) 2013 12306NG. All rights reserved.
//

#import "TicketsFilterView.h"

@implementation TicketsFilterView
@synthesize filterdelegate;
@synthesize selectedKeys;
- (void)dealloc
{
    
    [keys release];
    [values release];
    [selectedKeys release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //QB%23D%23Z%23T%23K%23QT%23
        
        keys=[[NSMutableArray alloc] initWithObjects:@"QB",@"G",@"D",@"Z",@"T",@"K",@"QT", nil];
        values=[[NSMutableArray alloc] initWithObjects:@"全部",@"高铁",@"动车",@"直达",@"特快",@"快车",@"其他",nil];
        
        self.selectedKeys=[[[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil] autorelease];
        
        self.allowsMultipleSelection=YES;
        self.delegate=self;
        self.dataSource=self;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [keys count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    if (indexPath.row==0) {
        
        
        
        if ([[selectedKeys objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            
            for (int i=0 ; i<[selectedKeys count]; i++) {
                
                [selectedKeys replaceObjectAtIndex:i withObject:@"1"];
                UITableViewCell* c=  [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (c) {
                    c.accessoryType=UITableViewCellAccessoryCheckmark;
                }
                
            }
            
            
        }else
        {
            for (int i=0 ; i<[selectedKeys count]; i++) {
                
                [selectedKeys replaceObjectAtIndex:i withObject:@"0"];
                
                UITableViewCell* c=  [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (c) {
                    c.accessoryType=UITableViewCellAccessoryNone;
                }
                
                
            }
        }
        
        
    }else
    {
        UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
        if ([[selectedKeys objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            [selectedKeys replaceObjectAtIndex:indexPath.row withObject:@"1"];
            
            
            
            
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else
        {
            [selectedKeys replaceObjectAtIndex:indexPath.row withObject:@"0"];
             [selectedKeys replaceObjectAtIndex:0 withObject:@"0"];
            UITableViewCell* c=  [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if (c) {
                c.accessoryType=UITableViewCellAccessoryNone;
            }
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }

//    
//    NSMutableArray* reArray=[NSMutableArray array];
//    
//    for (int i=0 ; i<[selectedKeys count]; i++) {
//        
//        if([[selectedKeys objectAtIndex:i] isEqualToString:@"1"])
//            
//        {
//            [reArray addObject:[values objectAtIndex:i]];
//        }
//    }
//    
    if(filterdelegate &&[filterdelegate respondsToSelector:@selector(ticketsFilterView:didChangFilterKeys:) ])
    {
        
          [filterdelegate ticketsFilterView:self didChangFilterKeys:selectedKeys];
    }




}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"identifier";
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
        
 	}
    cell.textLabel.text=[values objectAtIndex:indexPath.row];
    if ([[selectedKeys objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }else
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}
-(void)setSelectedKeys:(NSMutableArray *)selectedKeys_
{
    
    if (!selectedKeys_) {
        return;
    }
    [selectedKeys release];
    selectedKeys=[selectedKeys_ retain];
    
}
@end
