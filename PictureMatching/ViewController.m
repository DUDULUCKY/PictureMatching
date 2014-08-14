//
//  ViewController.m
//  PictureMatching
//
//  Created by fengsl on 14-8-13.
//  Copyright (c) 2014年 fengsl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initButton
{
    for (int i = 1; i < 10; i++) {
        for (int j = 1; j < 15; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i + j * 10 + 10000;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(20 + 31 * (i - 1), 30 + 31 * (j -1), 30, 30);
            button.backgroundColor = [UIColor redColor];
            button.alpha = 0.5;
        
            [self.view addSubview:button];
        }
    }
    
    [self initBtnPic];
}

- (void)initBtnPic
{
    static int picPosition[14][9] = {0};      //存储各个按钮上得图片种类
    int repeat[9] = {0};            //各个图片出现次数
    
    for (int xPos = 1; xPos < 10; xPos++)
    {
        for (int yPos = 1; yPos < 15; yPos++)
        {
            while (TRUE)
            {
                int picNum = arc4random() % 9 + 1;
                
                if (repeat[picNum - 1] != 14)
                {
                    NSString *picName = [[NSString alloc] initWithFormat:@"%d.jpg", picNum];
                    UIButton *button = (UIButton *)[self.view viewWithTag:(10000 + yPos * 10 + xPos)];
                    [button setBackgroundImage:[UIImage imageNamed:picName] forState:UIControlStateNormal];
                    picPosition[yPos][xPos] = picNum;
                    break;
                }
                else
                {
                    continue;
                }
            }
        }
    
    }
}

- (void)buttonClick:(UIButton *)sender
{
    self.BtnTag.text = [NSString stringWithFormat:@"%d", sender.tag];
}

@end