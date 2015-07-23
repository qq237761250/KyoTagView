//
//  ViewController.m
//  Demo
//
//  Created by Kyo on 7/24/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "ViewController.h"
#import "KyoTagView.h"

@interface ViewController ()

- (IBAction)btnTouchIn:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTouchIn:(id)sender {
    KyoTagView *tagView = [[KyoTagView alloc] initWithTitle:@"代码创建" withFrame:CGRectMake(200, 200, 56, 28)];
    [self.view addSubview:tagView];
}
@end
