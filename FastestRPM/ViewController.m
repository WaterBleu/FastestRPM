//
//  ViewController.m
//  FastestRPM
//
//  Created by Jeff Huang on 2015-07-09.
//  Copyright (c) 2015 Jeff Huang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) CGPoint startLocation;
@property (nonatomic) float rpm;
@property (nonatomic) float prevDegree;
@property (nonatomic) NSTimeInterval prevTime;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.rpm = 0;
    float degree = -225;
    self.speedNeedle.transform = CGAffineTransformMakeRotation(degree * M_PI/180);
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(setRPM:)];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setMinimumNumberOfTouches:1];
    
    [self.view addGestureRecognizer:panGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateRPM:(float) degree withTime:(NSTimeInterval) time {
    float prevDegree = self.prevDegree;
    NSTimeInterval prevTime = self.prevTime;
    self.prevDegree = degree;
    self.prevTime = time;
    self.rpm = fabsf(prevDegree - degree)/(time - prevTime)/180;
    NSLog(@"rpm is: %f", self.rpm);
}

- (float) getDistance:(CGFloat)x1 withY:(CGFloat)y1 withX2:(CGFloat)x2 withY2:(CGFloat)y2{
    if(self.startLocation.x != 0.0){
        CGFloat dx = x1 - x2;
        CGFloat dy = y1 - y2;
        return sqrt(pow(dx,2) + pow(dy,2));
    }
    return -1.0;
}

//-(void) populateCircle:(float) r{
//    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:r startAngle:0 endAngle:M_PI * 2 clockwise:true];
//    CAShapeLayer *circleLayer = [CAShapeLayer layer];
//    circleLayer.bounds = CGRectMake(0, 0, 2.0*r, 2.0*r);
//    circleLayer.path   = circle.CGPath;
//    circleLayer.strokeColor = [UIColor grayColor].CGColor;
//    circleLayer.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0].CGColor;
//    circleLayer.lineWidth = 3.0;
//    //circleLayer.position = CGPointMake(self.view.center.x - r, self.view.center.y - r);
//    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    drawAnimation.duration = 0.1;
//    [self.view.layer addSublayer:circleLayer];
//    //[circleLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
//    NSLog(@"%@", circle.CGPath);
//    //return circle.CGPath;
//}

- (float)getDegree:(CGPoint) startingPoint withEnd:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

- (void) setRPM:(id)sender{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)sender;
    CGPoint currentLocation = [panGesture locationInView:self.view];
    
    float radius = 0.0;
    float base = 0.0;
    float degree = 0.0;

    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.startLocation = [sender locationInView:self.view];
        
        //[self populateCircle:radius];
        NSLog(@"circle created");
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:5 animations:^{
            self.speedNeedle.transform = CGAffineTransformMakeRotation(-225 * M_PI/180);
        }];
    }
    radius = [self getDistance:self.view.center.x withY:self.view.center.y withX2:self.startLocation.x withY2:self.startLocation.y];
    base = [self getDistance:self.view.center.x withY:self.view.center.y withX2:currentLocation.x withY2:currentLocation.y-self.view.center.y];
    degree = [self getDegree:self.startLocation withEnd:currentLocation];
    [self updateRPM:degree withTime:[[NSDate date] timeIntervalSince1970]];
    self.speedNeedle.transform = CGAffineTransformMakeRotation(self.rpm - 225 * M_PI/180);
    //NSLog(@"degree is :%f", degree);
    //distance = [self getDistance: currentLocation.x withY:currentLocation.y];
    
}

@end
