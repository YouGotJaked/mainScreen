//
//  PHPController.m
//  mainScreen
//
//  Created by Jake Day on 5/5/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import "PHPController.h"

@interface PHPController ()

@end

@implementation PHPController

-(id)init {
    self = [super init];
    _uuid = [self loadUUID];
    _hr = [self loadHR];
    _calibrated = [self calibrationSet];
    return self;
}

-(void)startCalibration {
    if (![self calibrationSet]) {
        // present ORKHrCaptureStepViewController
        // acquire hr
        // update calibration column in UUID's row
    }
}

-(BOOL)calibrationSet {
    // PHP script to check if user UUID exists
    NSURL *requestURL = [NSURL URLWithString:@"http://students.engr.scu.edu/~jday/php/HEART/exists.php"];
    
    //The actual request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestURL];
    [request setPostValue:[self getUUID] forKey:@"uuid"];
    [request setDelegate:self];
    
    // start request
    [request startSynchronous];
    return [[request responseString] isEqualToString:@"true"];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"request finished");
    NSString *response = [request responseString];
    NSLog(@"response: %@",response);
}

// Get device UUID to anonymously manage users
-(NSString *)loadUUID {
    NSLog(@"calling loadUUID");
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

-(NSString *)getUUID {
    return _uuid;
}

// outdated
-(NSString *)getHR {
    return _hr;
}

// outdated
-(NSString *)loadHR {
    NSString *uuid = [self getUUID];
    // PHP script to get user's hr
    NSURL *requestURL = [NSURL URLWithString:@"http://students.engr.scu.edu/~jday/php/HEART/loadHR.php"];
    //The actual request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestURL];
    [request setPostValue:uuid forKey:@"uuid"];
    [request setDelegate:self];
    
    // start request
    [request startSynchronous];
    return [request responseString];
}

-(NSString *)loadNullSession {
    NSString *uuid = [self getUUID];
    // PHP script to get user's hr
    NSURL *requestURL = [NSURL URLWithString:@"http://students.engr.scu.edu/~jday/php/HEART/loadNullSession.php"];
    //The actual request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestURL];
    [request setPostValue:uuid forKey:@"uuid"];
    [request setDelegate:self];
    
    // start request
    [request startSynchronous];
    return [request responseString];
}

// change to NSData
-(NSString *)loadSession:(NSString *)session {
    NSString *uuid = [self getUUID];
    NSURL *requestURL = [NSURL URLWithString:@"http://students.engr.scu.edu/~jday/php/HEART/loadSession.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestURL];
    [request setPostValue:uuid forKey:@"uuid"];
    [request setPostValue:session forKey:@"session"];
    [request setDelegate:self];
    
    // start request
    [request startSynchronous];
    return [request responseString];
}

-(void)updateSession:(NSString *)session {
    NSString *uuid = [self getUUID];
    NSString *hr = [self getHR];
    NSURL *requestURL = [NSURL URLWithString:@"http://students.engr.scu.edu/~jday/php/HEART/updateSession.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestURL];
    [request setPostValue:uuid forKey:@"uuid"];
    [request setPostValue:hr forKey:@"hr"];
    [request setPostValue:session forKey:@"session"];
    [request setDelegate:self];
    
    // start request
    [request startSynchronous];
}

// 
-(void)addToSession:(NSString *)session WithHR:(NSString *)hr {
    NSString *uuid = [self getUUID];
    
    NSURL *requestURL = [NSURL URLWithString:@"http://students.engr.scu.edu/~jday/php/HEART/updateSession.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestURL];
    [request setPostValue:uuid forKey:@"uuid"];
    [request setPostValue:hr forKey:@"hr"];
    [request setPostValue:session forKey:@"session"];
    [request setDelegate:self];
    
    // start request
    [request startSynchronous];
}

// outdated
-(NSString *)updateHR {
    NSString *uuid = [self getUUID];
    NSString *hr = [self getHR];

    // PHP script to update user's hr
    NSURL *requestURL = [NSURL URLWithString:@"http://students.engr.scu.edu/~jday/php/HEART/updateHR.php"];
    // The actual request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestURL];
    [request setPostValue:uuid forKey:@"uuid"];
    [request setPostValue:hr forKey:@"hr"];
    [request setDelegate:self];
    
    [request startSynchronous];
    return [request responseString];
}

-(NSString *)getTimeAsString {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss a"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

-(void)test {
    NSArray *hrArray = [[NSArray alloc] initWithObjects:@58,@58,@57,@57,@71,@71,@50,@50,@57,@57,@50,@50,@106,@106,@92,@85,@85,@78,@78,@78,@50,@50,@50,@50,@50,@50,@50,@50,@50,@64,@57,@57,@57,@64,@64,@50,@50,@50,@57,@57,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@57, nil];
    NSString *time = [self getTimeAsString];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *hrString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dict[@"time"] = time;
    dict[@"hr"] = hrArray;

    NSString *nullSession = [self loadNullSession];
    [self addToSession:nullSession WithHR:hrString];
}

-(NSArray *)parseArrayFromSession:(NSString *)session {
    NSString *requestString = [self loadSession:session];
    
    NSRange range = NSMakeRange(1, requestString.length-2);
    NSString *newStr = [requestString substringWithRange:range];
    
    NSData* newData = [newStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingAllowFragments error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    } else {
        NSString *className = NSStringFromClass([jsonArray class]);
        NSLog(@"class: %@", className);
    }

    return jsonArray;
}

-(NSDictionary *)parseDictionary {
    NSString *uuid = [self getUUID];
    // PHP script to get user's hr
    NSURL *requestURL = [NSURL URLWithString:@"http://students.engr.scu.edu/~jday/php/HEART/loadSession.php"];
    //The actual request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestURL];
    [request setPostValue:uuid forKey:@"uuid"];
    [request setPostValue:@"SESSION5" forKey:@"session"];
    [request setDelegate:self];
    
    // start request
    [request startSynchronous];
    NSData *requestData = [request responseData];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingAllowFragments error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON, %@", [error description]);
    } else {
        NSLog(@"parsed: %@", json);
        NSString *className = NSStringFromClass([json class]);
        NSLog(@"class: %@", className);
    }

    
    return json;
}

-(int)getFilledSessions {
    NSString *nullSession = [self loadNullSession];
    
    NSString *lastChar = [nullSession substringFromIndex: [nullSession length] - 1];
    int lastValue = [lastChar intValue];

    int filled = 5;
    
    switch (lastValue) {
        case 1:
            filled = 0;
            break;
        case 2:
            filled = 1;
            break;
        case 3:
            filled = 2;
            break;
        case 4:
            filled = 3;
            break;
        case 5:
            filled = 4;
            break;
        default:
            break;
    }
    
    return filled;
}

@end
