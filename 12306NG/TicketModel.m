//
//  TicketModel.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "TicketModel.h"

@implementation TicketModel
@synthesize number,trainCode,fromLocation,toLocation,fromTime,toTime,duration,hardSeat,softSeat,hardBed,softBed,noSeat,otherSeat,advancedSoftBed;
@synthesize businessSeat,specialSeat,AOneSeat,BOneSeat,isFrom,isTO;

@synthesize orderString;
- (void)dealloc 
{
    self.number = nil;
    self.trainCode = nil;
    self.fromLocation = nil;
    self.toLocation = nil;
    self.fromTime = nil;
    self.toTime = nil;
    self.duration = nil;
    self.hardSeat = nil;
    self.softSeat = nil;
    self.hardBed = nil;
    self.softBed = nil;
    self.noSeat = nil;
    self.otherSeat=nil;
    self.advancedSoftBed = nil;
    self.businessSeat = nil;
    self.specialSeat = nil;
    self.AOneSeat = nil;
    self.BOneSeat = nil;
    self.orderString=nil;
    
    [super dealloc];

}

@end
