//
//  ViewController.m
//  new_camera_test
//
//  Created by Inje Cho on 2020/04/27.
//  Copyright © 2020 Inje Cho. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(IBAction)StartClicked:(id)sender{
    NSLog(@"start camera application");
    [self performSegueWithIdentifier:@"viewToCamera" sender:self];
}

@end
