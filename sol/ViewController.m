//
//  ViewController.m
//  sol
//
//  Created by Борис Стрельчик on 15.02.14.
//  Copyright (c) 2014 Борис Стрельчик. All rights reserved.
//

#import "ViewController.h"
#import "Pano.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Pano PixelPositionAndColorTest];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
