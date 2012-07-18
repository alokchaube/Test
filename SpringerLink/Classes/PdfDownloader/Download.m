//
//  Download.m
//  SpringerLink
//
//  Created by kiwitech  on 16/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "Download.h"
#import "DBManager.h"

@implementation Download
@synthesize filePath;
@synthesize delegate;


NSURLConnection *connection;

float exLength;
float retLength;


- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - public methods

- (void)startDownloadFromURL:(NSURL *)fileURL 
                  withOffset:(int)offset 
                  saveAtPath:(NSString *)path 
{
    
    self.filePath=path;
    retLength=(float)offset;
    
   // NSURL *url=[NSURL URLWithString:fileURL];
    NSLog(@"see url:%@",fileURL);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL];
	NSString *range = @"bytes=";
	range = [range stringByAppendingString:[[NSNumber numberWithInt:offset] stringValue]];
	range = [range stringByAppendingString:@"-"];
	[request setValue:range forHTTPHeaderField:@"Range"];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	if (connection) {
		
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelDownloading) name:@"cancelDownloading" object:nil];
        NSLog(@"Hit time for Download pdf:%@",[NSDate date]);
		[connection start];
        
        
	} else {
       
    }
}

-(void)cancelDownloading {
	if(connection)
        [connection cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark- Connection Delegate methods

- (void)connection:(NSURLConnection *)conection  
  didFailWithError:(NSError *)error {
    NSLog(@"error: %@",[error localizedDescription]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    conection=nil;
    
    if(delegate && [delegate respondsToSelector:@selector(closeDueToError)])
        [delegate closeDueToError];
    
}

- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"total expected length:%f",(double)[response expectedContentLength]);
    
   // [[database sharedDatabase] updateStateOfFile:[self.filePath lastPathComponent] 
     //                                 withValue:1];
    
    exLength=(double)[response expectedContentLength];
    //retLength=0.0;
}

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)data {
	
    NSFileManager *filemanager=[NSFileManager defaultManager];
	if(![filemanager fileExistsAtPath:filePath])
		[[NSFileManager defaultManager] createFileAtPath:filePath	contents: nil attributes: nil];
    
	NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	[handle seekToEndOfFile];
	[handle writeData:data];
    
    [handle closeFile];
    
    retLength+=(float)[data length];
    if([delegate respondsToSelector:@selector(persentageOfDownloading:)])
        [delegate persentageOfDownloading:retLength/exLength];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conection {
    connection = nil;
    //[[database sharedDatabase] updateStateOfFile:[self.filePath lastPathComponent] 
     //                                  withValue:2];
    if([delegate respondsToSelector:@selector(ArticleIsDownloaded)])
        [delegate ArticleIsDownloaded];
}

@end
