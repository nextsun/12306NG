//
//  CodeCracker.m
//  TicketsHunter
//
//  Created by Lei Sun on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CodeCracker.h"
#import "ASIDataDecompressor.h"


typedef struct
{
    int width;
    int height;
}imgSize;


@interface MatchedChar : NSObject{
    int X;
    int Y;
    char Char;
    double Rate;
}
@property(nonatomic,assign)int X;
@property(nonatomic,assign)int Y;
@property(nonatomic,assign)char Char;
@property(nonatomic,assign)double Rate;
@end
@implementation MatchedChar
@synthesize X;
@synthesize Y;
@synthesize Char;
@synthesize Rate;


@end

@interface CharInfo : NSObject{
    bool** P;
    char Char;
    int width;
    int height;
}
@property(nonatomic,assign)bool** P;
@property(nonatomic,assign)char Char;
@property(nonatomic,assign)int width;
@property(nonatomic,assign)int height;
@end
@implementation CharInfo
@synthesize P;
@synthesize Char;
@synthesize width;
@synthesize height;
@end


@implementation CodeCracker
- (void)dealloc
{
    [words release];
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        
        words=[[NSMutableArray alloc] init];
        
        
        uint8_t bytes[] =  { 
            0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0xc5, 0x58, 0xd9, 0x92, 0x13, 0x31, 
            0x0c, 0x94, 0x9e, 0x93, 0x0c, 0x61, 0x97, 0x2f, 0xe1, 0x58, 0xe0, 0x91, 0x9b, 0x82, 0x62, 0x0b, 
            0x58, 0xee, 0xff, 0xff, 0x10, 0xd8, 0xcc, 0xc8, 0xea, 0x96, 0x6c, 0x8f, 0x13, 0x48, 0xe1, 0xaa, 
            0x4d, 0x46, 0x96, 0x6d, 0xb5, 0x8e, 0x96, 0x67, 0x73, 0x7f, 0x3b, 0x09, 0x0e, 0x25, 0x41, 0x49, 
            0xa3, 0xae, 0xd7, 0x5b, 0xa9, 0xa8, 0xd5, 0xb4, 0x76, 0x02, 0x6a, 0x5c, 0x52, 0x94, 0x54, 0xed, 
            0x18, 0x5a, 0x7f, 0x18, 0x00, 0x00, 0x84, 0x07, 0x1b, 0x80, 0x4a, 0x9a, 0x08, 0x35, 0xb8, 0x81, 
            0x50, 0xe7, 0xad, 0xbe, 0xc4, 0x8e, 0xb1, 0x4f, 0x2d, 0x5f, 0xba, 0x80, 0xbb, 0xfd, 0x9a, 0xad, 
            0x19, 0x36, 0xe5, 0xad, 0x87, 0xf1, 0x10, 0xc0, 0x8d, 0xc6, 0x50, 0x40, 0x52, 0xf8, 0xb3, 0x98, 
            0x2c, 0xd6, 0xec, 0x59, 0xe7, 0x0d, 0x3e, 0x0f, 0x93, 0x3e, 0x1d, 0x02, 0x7a, 0x18, 0x8f, 0xb6, 
            0xc7, 0x46, 0x4e, 0x01, 0xa3, 0x96, 0xdc, 0x3a, 0x20, 0x77, 0xbf, 0x2c, 0x24, 0xe4, 0x80, 0xa9, 
            0x20, 0x14, 0xe5, 0x2d, 0xb5, 0x68, 0xc9, 0x55, 0x89, 0x23, 0x96, 0x82, 0xaa, 0xba, 0x58, 0xa6, 
            0x03, 0x38, 0x71, 0x4b, 0x29, 0xd2, 0x47, 0x80, 0xe3, 0x84, 0x91, 0xf4, 0x78, 0x43, 0x64, 0x41, 
            0x7b, 0x73, 0x99, 0x80, 0x42, 0x48, 0x00, 0xde, 0x00, 0x12, 0x88, 0x80, 0xdb, 0x51, 0x4a, 0x49, 
            0x84, 0x43, 0xf6, 0x51, 0x90, 0x27, 0x21, 0xc9, 0xf8, 0xac, 0x00, 0x4d, 0xcd, 0x46, 0x09, 0x9d, 
            0x15, 0x78, 0xe0, 0x00, 0x1e, 0x44, 0x2a, 0x51, 0x8c, 0xbc, 0xd3, 0xa3, 0x68, 0x8a, 0xd5, 0x3a, 
            0x20, 0x79, 0xba, 0x4d, 0x71, 0x4c, 0x0b, 0x91, 0x98, 0x90, 0x7b, 0x2a, 0x42, 0xc5, 0x78, 0x7a, 
            0xfc, 0xd5, 0x1b, 0x4b, 0x09, 0xa7, 0x27, 0x99, 0x38, 0x05, 0x01, 0xc2, 0x80, 0x39, 0x9c, 0x67, 
            0xbb, 0x4e, 0x7f, 0x6c, 0x33, 0xdd, 0xed, 0x87, 0x55, 0xda, 0x5d, 0xb5, 0x56, 0x33, 0xc6, 0xf9, 
            0xea, 0x60, 0x64, 0xcf, 0xa7, 0x41, 0xe0, 0x5c, 0x1c, 0xc4, 0xb2, 0x25, 0xa3, 0x89, 0x88, 0x8d, 
            0x16, 0x00, 0xb5, 0xed, 0xa5, 0x22, 0x9d, 0x52, 0x41, 0x53, 0x8d, 0x92, 0x7f, 0x31, 0x51, 0x3f, 
            0xa8, 0x00, 0x85, 0x8a, 0x71, 0x10, 0x92, 0x78, 0xc4, 0x59, 0x08, 0x39, 0x69, 0xa9, 0x38, 0x41, 
            0x48, 0xf7, 0x40, 0x5a, 0x03, 0xd5, 0x3a, 0xf5, 0xe5, 0x9d, 0x33, 0x66, 0xc3, 0xd7, 0x1f, 0xef, 
            0x94, 0xa0, 0x53, 0xea, 0xf4, 0x15, 0xb2, 0x1c, 0x40, 0x2d, 0xcf, 0xaf, 0xce, 0xe9, 0xd4, 0x7a, 
            0x89, 0x09, 0xe6, 0xdd, 0xdb, 0x0e, 0xb8, 0x58, 0xa7, 0x60, 0x37, 0xfd, 0xf2, 0xfa, 0x2c, 0x4e, 
            0x51, 0x87, 0x0d, 0xfc, 0x16, 0x72, 0x2a, 0x5f, 0xc0, 0x80, 0xf0, 0x54, 0xa7, 0xde, 0xfc, 0x15, 
            0x8b, 0x9a, 0x36, 0x3a, 0x2c, 0x62, 0xfc, 0xd4, 0x8c, 0x31, 0xb7, 0xea, 0xd7, 0x26, 0xc4, 0xaf, 
            0x75, 0xea, 0xdb, 0x8b, 0xff, 0x9b, 0x9b, 0x50, 0x7e, 0xfe, 0x15, 0xab, 0x17, 0x2f, 0x96, 0x96, 
            0xbd, 0xaa, 0x87, 0xdd, 0x77, 0xa3, 0x77, 0xd3, 0x85, 0xf0, 0xe0, 0x58, 0xd5, 0xf6, 0x8c, 0xcd, 
            0xc4, 0x63, 0x52, 0x12, 0x48, 0x46, 0x0f, 0x93, 0x5a, 0xe3, 0xea, 0x24, 0x67, 0x73, 0x63, 0xa0, 
            0xdf, 0xdf, 0x3d, 0x67, 0xf6, 0xa9, 0xfc, 0xed, 0x08, 0xe3, 0x82, 0x57, 0x08, 0x35, 0x47, 0x68, 
            0x9c, 0x01, 0x40, 0x87, 0x8b, 0xbd, 0x0c, 0xb3, 0xf4, 0xe1, 0x72, 0xd7, 0x54, 0x62, 0xfd, 0x40, 
            0xed, 0x99, 0xa6, 0x7e, 0x2b, 0xe4, 0xb4, 0xc4, 0x62, 0x0d, 0x79, 0xae, 0x1b, 0xd7, 0xf4, 0x09, 
            0xb7, 0xe1, 0x7c, 0x44, 0x09, 0x9a, 0xda, 0xff, 0x52, 0x6a, 0x3c, 0xe1, 0xc8, 0xd7, 0xbd, 0xbb, 
            0xbe, 0x37, 0xfc, 0xd6, 0xd5, 0x4e, 0x3c, 0x40, 0x2a, 0x4b, 0x39, 0x1a, 0xbd, 0x2a, 0xcd, 0xc1, 
            0x18, 0x59, 0x40, 0x62, 0x78, 0xec, 0x63, 0x19, 0x72, 0xf0, 0xcf, 0xf8, 0x38, 0xfa, 0x42, 0x3a, 
            0xc8, 0x02, 0xec, 0x5b, 0xeb, 0x8d, 0xae, 0xf1, 0x45, 0xdd, 0x32, 0x98, 0x35, 0x3c, 0x9f, 0xa6, 
            0x3d, 0xce, 0x13, 0xce, 0x94, 0x38, 0x87, 0x00, 0x8d, 0x85, 0xc4, 0x70, 0x17, 0x26, 0x0e, 0xa6, 
            0x1e, 0x16, 0xcb, 0xbf, 0x52, 0xdf, 0x29, 0x63, 0xc4, 0xf6, 0x8c, 0x35, 0xba, 0xf2, 0xf9, 0x1f, 
            0xbf, 0x73, 0x1f, 0x91, 0x1b, 0x9e, 0x24, 0x5e, 0x63, 0x22, 0x82, 0x23, 0x05, 0x19, 0xb9, 0x71, 
            0x73, 0xdc, 0xcf, 0x05, 0x88, 0x94, 0x71, 0xdb, 0xdd, 0x48, 0x10, 0xd5, 0x55, 0xb3, 0x52, 0xc3, 
            0x1b, 0x01, 0x94, 0x13, 0x74, 0x94, 0x3a, 0x80, 0x2f, 0x39, 0xe2, 0x75, 0x0e, 0xf2, 0xc6, 0x18, 
            0xdc, 0x46, 0xfc, 0xf3, 0xea, 0x14, 0x80, 0xc1, 0xce, 0x24, 0xee, 0x72, 0xed, 0x94, 0xaf, 0xfb, 
            0xa9, 0xaa, 0x4a, 0xe0, 0xd4, 0x22, 0xc6, 0xf0, 0x57, 0x1d, 0x8e, 0xd2, 0x90, 0xc6, 0x0c, 0xd3, 
            0x9a, 0x53, 0xfb, 0xd6, 0xb7, 0xdd, 0x14, 0xd4, 0xbd, 0x41, 0xa7, 0x80, 0x7b, 0x23, 0xfe, 0x34, 
            0x56, 0x0d, 0x96, 0x46, 0x02, 0xfe, 0xfd, 0xb2, 0x00, 0x5f, 0x01, 0x9c, 0xa0, 0x32, 0x39, 0xd7, 
            0x90, 0xc2, 0x6c, 0xc7, 0x4e, 0x68, 0x88, 0x7d, 0x9f, 0x9b, 0xcf, 0xa7, 0xbe, 0xa0, 0xfc, 0x18, 
            0x7d, 0x07, 0x5b, 0xa9, 0xbe, 0x56, 0x1f, 0x67, 0x1a, 0x4a, 0x91, 0x9c, 0x04, 0x38, 0x53, 0x6b, 
            0x70, 0x68, 0x8f, 0xea, 0xf4, 0x34, 0x87, 0x7f, 0x6e, 0x82, 0xc3, 0xc1, 0xab, 0x40, 0xc4, 0x50, 
            0x13, 0x0e, 0x33, 0x5d, 0x67, 0x7d, 0x01, 0x1f, 0xdb, 0xc0, 0x7f, 0xed, 0x87, 0x7f, 0xbc, 0x0f, 
            0x75, 0xe0, 0xa5, 0xba, 0xc0, 0x84, 0x3d, 0x24, 0x04, 0xe0, 0xf1, 0x16, 0x41, 0x3b, 0x74, 0xd2, 
            0x52, 0xc5, 0xf8, 0x7c, 0x12, 0xfb, 0xe4, 0x37, 0x5b, 0xfb, 0x57, 0x11, 0xa1, 0x18, 0x00, 0x00, 
        };
        NSError* error;
        
        
        
        NSData* data1=[NSData dataWithBytes:bytes length:sizeof(bytes)];
        
        //NSString* path=[NSHomeDirectory() stringByAppendingFormat:@"/text.zip"];
        
       // LogInfo(@"%@",path);
        
       // [data writeToFile:path atomically:YES];
        
       NSData* data=  [ASIDataDecompressor uncompressData:data1 error:&error];
        
        LogInfo(@"%@",data);
        
        //NSLog(@"%@",error.userInfo);
        
        NSInputStream* input=[[NSInputStream alloc] initWithData:data];
        [input open];
        
        while (true) {
            if (![input hasBytesAvailable]) {
                break;
            }
            int s=sizeof(uint8_t);
            uint8_t ch;
  
            //int chR=[input read:&ch maxLength:s];
            [input read:&ch maxLength:s];
            if ((char)ch == '\0')
                break;            
            uint8_t width;
            uint8_t height;
            
           [input read:&width maxLength:sizeof(uint8_t)];
           [input read:&height maxLength:sizeof(uint8_t)];
            
//            int widthR=[input read:&width maxLength:sizeof(uint8_t)];
//            int heightR=[input read:&height maxLength:sizeof(uint8_t)];
            
            
            NSLog(@"ch:%c",ch);
            NSLog(@"width:%i",width);
            NSLog(@"height:%i",height);
            bool **map = (bool **)malloc(sizeof(bool *) * width);
            
            for (int i = 0; i < width; i++) 
            { 
                *(map + i) = (bool *)malloc(sizeof(bool) * height); 
                
            }
            for (int i = 0; i < width; i++)
                for (int j = 0; j < height; j++)
                {   
                    uint8_t bo;
                    [input read:&bo maxLength:sizeof(uint8_t)];
                    NSLog(@"height:%i",bo);
                    map[i][j] = bo;
                }
            
            CharInfo* charInfo=[[CharInfo alloc] init];
            charInfo.Char=ch;
            charInfo.P=map;
            charInfo.width=width;
            charInfo.height=height;
            
            [words addObject:charInfo];
            [charInfo release];
        }
    
        
        [input close];
        
        [input release];
                              
        
//        using (var stream = new MemoryStream(bytes))
//        using (var gzip = new GZipStream(stream, CompressionMode.Decompress))
//        using (var reader = new BinaryReader(gzip))
//        {
//            while (true)
//            {
//                char ch = reader.ReadChar();
//                if (ch == '\0')
//                    break;
//                int width = reader.ReadByte();
//                int height = reader.ReadByte();
//                
//                bool[,] map = new bool[width, height];
//                for (int i = 0; i < width; i++)
//                    for (int j = 0; j < height; j++)
//                        map[i, j] = reader.ReadBoolean();
//                words_.Add(new CharInfo(ch, map));
//            }
//        }
//        
        
    }
    return self;
}

-(NSString*)crackerCodeImage:(UIImage*)image
{
    
    //CGContextRef *content=
    
    
    
    
    
    CGImageRef inImage = image.CGImage;          
   // CGContextRef ctx;  
    CFDataRef m_DataRef;  
    m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage)); 
    int width = CGImageGetWidth( inImage );
    int height = CGImageGetHeight( inImage );
//    int bpc = CGImageGetBitsPerComponent(inImage);
//    int bpp = CGImageGetBitsPerPixel(inImage);
//    int bpl = CGImageGetBytesPerRow(inImage);
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
//    int length = CFDataGetLength(m_DataRef);  
//    NSLog(@"len %d", length);  
//    NSLog(@"width=%d, height=%d", width, height);          
//    NSLog(@"1=%d, 2=%d, 3=%d", bpc, bpp,  bpl);  
//    for (int index = 0; index < length; index += 4)  
//    {                  
//        m_PixelBuf[index + 0] = 255 - m_PixelBuf[index + 0];  // b
//        m_PixelBuf[index + 1] = 255 - m_PixelBuf[index + 1];  // g
//        m_PixelBuf[index + 2] = 255 - m_PixelBuf[index + 2];  // r  
//    }  
     
    
    
//    int width= image.size.width;  //line
//    int height=image.size.height; //row
//    
    
    bool** p=NULL;
    
    //table
    p = (bool **)malloc(sizeof(bool *) * width);     
    
    if (NULL == p) 
    { 
         CFRelease(m_DataRef);
        return @""; 
    } 
    for (int i = 0; i < width; i++) 
    { 
        *(p + i) = (bool *)malloc(sizeof(bool) * height); 
        if (NULL == *(p + i)) 
        { 
             CFRelease(m_DataRef);
            return @""; 
        } 
    
    }
    for (int i = 0; i < width; i++) 
    { 
        for( int j = 0; j < height; j++) 
        { 
            
            int r=m_PixelBuf[i*width*4+j];
            int g=m_PixelBuf[i*width*4+j+1];
            int b=m_PixelBuf[i*width*4+j+2];            
            p[i][j] = r+g+b<500; 
            
            
 //               NSLog(@"%i",r+g+b);
            //}
        } 
    } 
    
     CFRelease(m_DataRef);
    
    
    
    int start=-1;
    
    int next=start;
    
//    private int SearchNext(bool[,] table, int start)
//    {
//        var width = table.GetLength(0);
//        var height = table.GetLength(1);
      bool end=false;
        for (start++; start < width; start++)
        {    for (int j = 0; j < height; j++)
                if (p[start][j])
                {
                    next=start;
                    end=true;
                    break;
                }
            if (end) {
                break;
            }
        }
        
//    }
    
    
   char* result =NULL;
    
            while (next < width - 7)
            {
                MatchedChar* matched = [self Match:p AndSize:(imgSize){width,height} withStart:start];
                printf("Match.rate%f",matched.Rate);
                if (matched.Rate > 0.6)
                {
                  
                    
                    //printf("%c",matched.Char);
                    result+=matched.Char;
                    next = matched.X + 10;
                }
                else
                {
                    next += 1;
                }
            }
    printf("%s",result);
    
    if (result==NULL) {
        return @"7SWF";
    }else {
        return [NSString stringWithCString:result encoding:NSASCIIStringEncoding];
    }
    
    
    
}
//    
//    
//    public string Read(Bitmap bmp)
//    {
//        var result = string.Empty;
//        var width = bmp.Width;
//        var height = bmp.Height;
//        var table = ToTable(bmp);
//        var next = SearchNext(table, -1);
//        
//        while (next < width - 7)
//        {
//            var matched = Match(table, next);
//            if (matched.Rate > 0.6)
//            {
//                result += matched.Char;
//                next = matched.X + 10;
//            }
//            else
//            {
//                next += 1;
//            }
//        }
//        
//        return result;
//    }
//}


//private bool[,] ToTable(Bitmap bmp)
//{
//   
//}
//-(bool**)ToTable:(UIImage*)image
//{
//    
//    var table = new bool[bmp.Width, bmp.Height];
//    for (int i = 0; i < bmp.Width; i++)
//        for (int j = 0; j < bmp.Height; j++)
//        {
//            var color = bmp.GetPixel(i, j);
//            table[i, j] = (color.R + color.G + color.B < 500);
//        }
//    return table;
//}

-(MatchedChar*)Match:(bool**)source AndSize:(imgSize)sSize withStart:(int)start
{
    
    MatchedChar* best = nil;
    
    
   
    
    for ( CharInfo* info in words) 
    { 
        
        
        imgSize tSize=(imgSize){info.width ,info.height};
            
        MatchedChar* matched=[self ScopeMatch:source AndSize:sSize withTarget:info.P AndSize:tSize andStart:start ];             matched.Char=info.Char;
        if (best==nil||best.Rate<matched.Rate) {
            best=matched;
        }
            
     
    
    }
    return best;
}

-(MatchedChar*) ScopeMatch:(bool**)source AndSize:(imgSize)sSize withTarget:(bool**)target AndSize:(imgSize)tSize andStart:(int) start
{
//    int targetWidth = 1;
    int targetHeight =tSize.height;
//    int sourceWidth = 1;
    int sourceHeight =sSize.height;
    double rate = 0;
    double max = 0;
    MatchedChar* matched =  [[MatchedChar alloc] init];
    for (int i = -2; i < 6; i++)
        for (int j = -3; j < sourceHeight - targetHeight + 5; j++)
        {
//             rate = [self FixedMatch:source AndSize:sSize withTarget:target AndSize:tSize AndX:i+start AndY:j];            
            if (rate > max)
            {
                max = rate;
                matched.X = i + start;
                matched.Y = j;
                matched.Rate = rate;
            }
        }
    return matched;
    
}

-(double)FixedMatch:(bool**)source AndSize:(imgSize)sSize withTarget:(bool**)target AndSize:(imgSize)tSize AndX:(int)x0  AndY:(int) y0 
{
    double total = 0;
    double count = 0;
    
    int targetWidth = tSize.width;
    int targetHeight =tSize.height;
    int sourceWidth = sSize.width   ;
    int sourceHeight =sSize.height;
    int x, y;
    
    
    
    for (int i = 0; i < targetWidth; i++)
    {
        x = i + x0;
        if (x < 0 || x >= sourceWidth)
            continue;
        for (int j = 0; j < targetHeight; j++)
        {
            y = j + y0;
            if (y < 0 || y >= sourceHeight)
                continue;
            
            if (target[i][j])
            {
                total++;
                if (source[x][y])
                    count++;
                else
                    count--;
            }
            else if (source[x][y])
                count -= 0.55;
        }
    }
    
    return count / total;
}
-(UIImage*)generalByDataBaseImage
{
    
     CharInfo*  info = [words objectAtIndex:0];
    
    UIGraphicsBeginImageContext(CGSizeMake(info.width , info.width));
    CGContextRef content= UIGraphicsGetCurrentContext();
    
    
    
    
    CGContextSetFillColorWithColor(content, [[UIColor whiteColor]CGColor]);
    CGContextFillRect(content, CGRectMake(0, 0, info.width, info.height));
    
    //for (CharInfo*  info in words) {
     
        
        //imgSize tSize=(imgSize){info.width ,info.height};
//        
//        CGContextRef ctx=  CGBitmapContextCreate(info.P, info.width, info.height, 8, 8*info.width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault);
//    
//    CGImageRef imgref=CGImageCreate(info.width, info.height, 8, 32, 8*info.width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault, nil, info.P, YES, kCGRenderingIntentDefault);
//    
//    CGContextDrawImage(content,  CGRectMake(0,0,info.width, info.height), ctx);
//        
   UIImage* img=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //UIImage* img=[[UIImage alloc] init];
    
    
    
//    CGImageRef inImage =img.CGImage;
//    
//    CFDataRef m_DataRef;  
//    m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage)); 
//    
//    
//    int width = CGImageGetWidth( inImage );
//    int height = CGImageGetHeight( inImage );
//    
//     UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
//    
//    int length = CFDataGetLength(m_DataRef);
//        for (int index = 0; index < length; index += 4)  
//        {                  
//            m_PixelBuf[index + 0] = 255;  // b
//            m_PixelBuf[index + 1] = 0;  // g
//            m_PixelBuf[index + 2] =0;  // r  
//        }  
//
//    
////    for (int i = 0; i < width; i++) 
////    { 
////        for( int j = 0; j < height; j++) 
////        { 
////            
////            
////            //if (info.P[i][j]) {
////               
////                 m_PixelBuf[i*width*4+j] = 0;
////                 m_PixelBuf[i*width*4+j+1]=255;
////                 m_PixelBuf[i*width*4+j+2]=0;
////            //}
////            
////            
////            
//////            int r=m_PixelBuf[i*width*4+j];
//////            int g=m_PixelBuf[i*width*4+j+1];
//////            int b=m_PixelBuf[i*width*4+j+2];  
////            
////            
////            
////            //p[i][j] = r+g+b<500; 
////            
////            
////            //               NSLog(@"%i",r+g+b);
////            //}
////        } 
////    } 
////    
//    CFRelease(m_DataRef);

    
    return img;
        
   // }
    
    
}
@end
