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

@property (weak, nonatomic) IBOutlet KyoTagView *kyoTagView;

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
    
    self.kyoTagView.title = @"改变文本";
    [self.kyoTagView setNeedsDisplay];
    
    KyoTagView *tagView1 = [[KyoTagView alloc] initWithTitle:@"代码创建" withFrame:CGRectMake(200, 200, 56, 28)];
    [self.view addSubview:tagView1];
    
    KyoTagView *tagView2 = [[KyoTagView alloc] initWithTitle:@"代码创建1" withPoint:CGPointMake(200, 250) withMargin:CGSizeMake(16, 30)];
    [self.view addSubview:tagView2];
    
    KyoTagView *tagView3 = [[KyoTagView alloc] initWithTitle:@"代码创建2" withPoint:CGPointMake(200, 300) withMargin:CGSizeMake(16, 30) withIcon:[UIImage imageNamed:@"com_icon_location"]];
    [self.view addSubview:tagView3];
    
    KyoTagView *tagView4 = [[KyoTagView alloc] initWithTitle:@"代码创建3" withPoint:CGPointMake(200, 350) withMargin:CGSizeMake(16, 30) withIcon:[UIImage imageNamed:@"com_icon_location"]];
    tagView4.iconYInset = -6;
    tagView4.space = 0;
    [self.view addSubview:tagView4];
    
    KyoTagView *tagView5 = [[KyoTagView alloc] initWithTitle:@"代码创建4" withPoint:CGPointMake(200, 400) withMargin:CGSizeMake(16, 30) withIcon:[UIImage imageNamed:@"com_icon_location"]];
    tagView5.iconYInset = -6;
    tagView5.space = 0;
    tagView5.direction = KyoTagViewIconDirectionRight;
    [self.view addSubview:tagView5];
    
    KyoTagView *tagView6 = [[KyoTagView alloc] initWithTitle:@"代码创建4" withPoint:CGPointMake(200, 450) withMargin:CGSizeMake(16, 30) withIcon:[UIImage imageNamed:@"com_icon_location"] withFontSize:13];
    tagView6.iconYInset = -6;
    tagView6.space = 0;
    tagView6.direction = KyoTagViewIconDirectionRight;
    [self.view addSubview:tagView6];
}
@end
