//
//  ExampleViewController.m
//  example
//
//  Created by Ethan Sherbondy on 7/9/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "ExampleViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

// this would be more straightforward if the nib just represented the view controller

@synthesize nameLabel = _nameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _nameLabel = [UILabel new]; // need to have a temporary label
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
