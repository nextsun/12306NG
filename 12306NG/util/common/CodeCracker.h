//
//  CodeCracker.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeCracker : NSObject
{
    NSMutableArray* words;
}
-(NSString*)crackerCodeImage:(UIImage*)image;
-(UIImage*)generalByDataBaseImage;
@end
