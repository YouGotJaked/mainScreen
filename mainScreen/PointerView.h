//
//  PointerView.h
//  mainScreen
//
//  Created by Jake Day on 5/6/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "PHPController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PointerView : UIView {
    float pointerX;
    float pointerY;
    BOOL drawPointer;
    NSString *session;
}

@property (nonatomic, strong) NSString *session;

@end

NS_ASSUME_NONNULL_END
