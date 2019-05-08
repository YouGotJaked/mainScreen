//
//  PointerView.m
//  mainScreen
//
//  Created by Jake Day on 5/6/19.
//  Copyright © 2019 Jake Day. All rights reserved.
//

#import "PointerView.h"

@implementation PointerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (drawPointer) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect frame = self.frame;
        
        CGContextTranslateCTM(context, 0, kGraphHeight);
        CGContextScaleCTM(context, 1, -1);
        
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.4 green:0.8 blue:0.4 alpha:1.0] CGColor]);
        CGContextMoveToPoint(context, pointerX, 0);
        CGContextAddLineToPoint(context, pointerX, frame.size.height);
        CGContextStrokePath(context);
        
        [self drawHRLabels:context];
    }
}

- (void)drawHRLabels:(CGContextRef)context {
    // Drawing text
    CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    
    // display hr label
    float xValue = [self getXValueFromXCoordinate:pointerX];
    float yValue = [self getYValueFromYCoordinate:pointerY];
    int lower = [self getLowerBoundFromX:xValue];
    int upper = [self getUpperBoundFromX:xValue];
    
    // get data from session
    PHPController *php = [[PHPController alloc] init];
    NSArray *data = [php parseArrayFromSession:_session];
    
    int lowerObj = (int)[(NSNumber *)[data objectAtIndex:lower] integerValue];
    int upperObj = (int)[(NSNumber *)[data objectAtIndex:upper] integerValue];
    
    // draw lower hr value
    NSString *lowerText = [NSString stringWithFormat:@"%d BPM", lowerObj];
    CGSize lowerLabelSize = [lowerText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]];
    CGContextShowTextAtPoint(context, pointerX - 1.25*lowerLabelSize.width, kGraphHeight - pointerY, [lowerText cStringUsingEncoding:NSUTF8StringEncoding], [lowerText length]);
    // draw upper hr value
    NSString *upperText = [NSString stringWithFormat:@"%d BPM", upperObj];
    CGSize upperLabelSize = [upperText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]];
    CGContextShowTextAtPoint(context, pointerX + 0.25*upperLabelSize.width, kGraphHeight - pointerY, [upperText cStringUsingEncoding:NSUTF8StringEncoding], [upperText length]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    pointerX = point.x;
    pointerY = point.y;
    NSLog(@"x: %f\t y: %f", point.x, point.y);
    
    float xValue = [self getXValueFromXCoordinate:pointerX];
    float yValue = [self getYValueFromYCoordinate:pointerY];
    int lower = [self getLowerBoundFromX:xValue];
    int upper = [self getUpperBoundFromX:xValue];
    [self printPercentageFromLower:lower AndUpper:upper WithValue:xValue];
    NSLog(@"xValue: %f\tyValue: %f\tlower: %d\tupper: %d", xValue, yValue, lower, upper);
    NSArray *data = [[NSArray alloc] initWithObjects:@58,@58,@57,@57,@71,@71,@50,@50,@57,@57,@50,@50,@106,@106,@92,@85,@85,@78,@78,@78,@50,@50,@50,@50,@50,@50,@50,@50,@50,@64,@57,@57,@57,@64,@64,@50,@50,@50,@57,@57,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@57, nil];
    [self getYCoordinateFromData:data AtIndex:lower];
    [self getYCoordinateFromData:data AtIndex:upper];
    
    drawPointer = YES;
    [self setNeedsDisplay];
}

// TODO: get hr value based on x y coordinates pressed
// idea:    get x coordinate of button pressed
//          find which interval that corresponds to
//          find out how far along that is between the two to get offset
//          get the slope of the 2 values with offset
- (float)getXValueFromXCoordinate:(float)x {
    float intervals = kDefaultGraphWidth / kStepX;
    return (x / kDefaultGraphWidth) * intervals;
}

- (float)getYValueFromYCoordinate:(float)y {
    float intervals = kGraphHeight / kStepY;
    return (y / kGraphHeight) * intervals;
}

- (int)getLowerBoundFromX:(float)x {
    return floorf(x);
}

- (int)getUpperBoundFromX:(float)x {
    return ceilf(x);
}

// percentage between lower and upper x values
- (void)printPercentageFromLower:(int)lower AndUpper:(int)upper WithValue:(float)value {
    NSArray *plotData = [[NSArray alloc] initWithObjects:@58,@58,@57,@57,@71,@71,@50,@50,@57,@57,@50,@50,@106,@106,@92,@85,@85,@78,@78,@78,@50,@50,@50,@50,@50,@50,@50,@50,@50,@64,@57,@57,@57,@64,@64,@50,@50,@50,@57,@57,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@50,@57, nil];
    
    float percentage = (value - lower) / (upper - lower);
    NSLog(@"percentage: %f, data[lower] = %@, data[upper] = %@", percentage, plotData[lower], plotData[upper]);
}

- (float)getSlopeFromX1:(float)x1 Y1:(float)y1 AndX2:(float)x2 Y2:(float)y2 {
    float slope = (y2 - y1) / (x2 - x1);
    NSLog(@"slope: %f", slope);
    return slope;
}

- (float)getXCoordinateFromData:(NSArray *)data {
    return 0.0;
}

- (void)getYCoordinateFromData:(NSArray *)data AtIndex:(int)index {
    int obj = (int)[(NSNumber *)[data objectAtIndex:index] integerValue];
    
    float oldValue = [self getYValueFromYCoordinate:pointerY];
    float oldRange = kGraphHeight / kStepY;

    float range = hrHigh - hrLow;
    float newValue = (((oldValue - 0) * range) / oldRange) + hrLow;
    NSLog(@"oldValue: %f, newValue: %f", oldValue, ceilf(hrHigh + hrLow - newValue));
}

// get XY of upper
// get XY of lower
// get slope
// set x = data[index] and solve for y

@end
