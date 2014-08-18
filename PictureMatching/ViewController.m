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
    for (int i = 1; i < 15; i++) {
        for (int j = 1; j < 9; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i * 10 + j + 10000;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(23 + 31 * (i - 1), 50 + 31 * (j -1), 30, 30);
            //button.backgroundColor = [UIColor redColor];
            button.alpha = 0.5;
        
            [self.view addSubview:button];
        }
    }
    
    [self initBtnPic];
}

- (void)initBtnPic
{
    static int picPosition[8][14] = {0};      //存储各个按钮上的图片种类
    int repeat[14] = {0};            //各个图片出现次数
    
    for (int xPos = 1; xPos < 15; xPos++)
    {
        for (int yPos = 1; yPos < 9; yPos++)
        {
            while (TRUE)
            {
                int picNum = arc4random() % 14 + 1;
                
                if (repeat[picNum - 1] < 8)
                {
                    NSString *picName = [[NSString alloc] initWithFormat:@"%d.jpg", picNum];
                    UIButton *button = (UIButton *)[self.view viewWithTag:(10000 + xPos * 10 + yPos)];
                    [button setBackgroundImage:[UIImage imageNamed:picName] forState:UIControlStateNormal];
                    picPosition[yPos - 1][xPos - 1] = picNum;
                    repeat[picNum - 1]++;
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
    static BOOL push = FALSE;
    static int tag = 0;
    
    if (push == FALSE)
    {
        tag = sender.tag;
        push = TRUE;
    }
    else
    {
        push = FALSE;
        if (tag != sender.tag) {
            self.BtnTag.text = @"两次点击不一致";
        }
        else
        {
            self.BtnTag.text = @"两次点击一致";
        }
    }
}

- (IBAction)reFlash:(id)sender
{
    [self initBtnPic];
}
@end