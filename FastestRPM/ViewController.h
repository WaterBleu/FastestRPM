//
//  ViewController.h
//  FastestRPM
//
//  Created by Jeff Huang on 2015-07-09.
//  Copyright (c) 2015 Jeff Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *speedNeedle;

- (void) setRPM:(id) sender;

@end

