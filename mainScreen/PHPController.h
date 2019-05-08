//
//  PHPController.h
//  mainScreen
//
//  Created by Jake Day on 5/5/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "PHPControllerDelegate.h"

@interface PHPController : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *hr;
@property (nonatomic) BOOL calibrated;

enum SESSIONS {
    SESSION1,
    SESSION2,
    SESSION3,
    SESSION4,
    SESSION5
};

-(id)init;
-(void)startCalibration;
-(BOOL)calibrationSet;
-(NSString *)loadUUID;
-(NSString *)loadHR;
-(NSString *)loadNullSession;
-(NSString *)loadSession:(NSString *)session;
-(NSString *)getUUID;
-(NSString *)getHR;
-(NSString *)getTimeAsString;
-(NSArray *)parseArrayFromSession:(NSString *)session;
-(void)test;
-(NSDictionary *)parseDictionary;
-(int)getFilledSessions;
@end
