//
//  ViewController.m
//  PictureMatching
//
//  Created by fengsl on 14-8-13.
//  Copyright (c) 2014年 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "Globel.h"

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
    //extern int picPosition[8][14] = {0};      //存储各个按钮上的图片种类
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
        NSLog(@"First tag X-->%d", (tag - 10000) / 10);
        NSLog(@"First tag Y-->%d", (tag - 10000) % 10);
        NSLog(@"Second tag X-->%d", (sender.tag - 10000) / 10);
        NSLog(@"Second tag Y-->%d\n\n", (sender.tag - 10000) % 10);
        
        if ((tag - 10000) % 10 == (sender.tag - 10000) % 10)
        {
            push = FALSE;
            if ([self horizon:tag second:sender.tag]) {
                self.BtnTag.text = @"同一行";
            }
            else
            {
                self.BtnTag.text = @"不同行";
            }
        }
        else
        {
            if ((tag - 10000) / 10 == (sender.tag - 10000) / 10)
            {
                push = FALSE;
                if ([self vertical:tag second:sender.tag]) {
                    self.BtnTag.text = @"同一列";
                }
                else
                {
                    self.BtnTag.text = @"不同列";
                }
            }
        }
        tag = sender.tag;
    }
}

- (IBAction)reFlash:(id)sender
{
    [self initBtnPic];
}




- (BOOL) horizon:(int)firstTag second:(int)secondTag       //同一行的判断
{
    int firstXLocation = (firstTag - 10000) / 10;
    int YLocation = (firstTag - 10000) % 10;
    int secondXLocation = (secondTag - 10000) / 10;
    //int secondYLocation = (firstTag - 10000) % 10;
    
    if (firstTag == secondTag) {
        return FALSE;
    }
    
    int xStar = firstXLocation < secondXLocation ? firstXLocation : secondXLocation;
    int xEnd = firstXLocation > secondXLocation ? firstXLocation : secondXLocation;
    
    for (int i = xStar + 1; i < xEnd; i++) {
        if (picPosition[YLocation - 1][i - 1] != 0) {
            return FALSE;
        }
    }
    
    return TRUE;
}

- (BOOL) vertical:(int)firstTag second:(int)secondTag       //同一列的判断
{
    int firstXLocation = (firstTag - 10000) / 10;
    int firstYLocation = (firstTag - 10000) % 10;
    //int secondXLocation = (secondTag - 10000) / 10;
    int secondYLocation = (secondTag - 10000) % 10;
    
    if (firstTag == secondTag) {
        return FALSE;
    }
    
    int yStar = firstYLocation < secondYLocation ? firstYLocation : secondYLocation;
    int yEnd = firstYLocation > secondYLocation ? firstYLocation : secondYLocation;
    
    for (int i = yStar + 1; i < yEnd; i++) {
        if (picPosition[i - 1][firstXLocation - 1] != 0) {
            return FALSE;
        }
    }
    
    return TRUE;
}

- (BOOL) oneCorner:(int)firstTag second:(int)secondTag       //一个拐角的判断
{
    int newTag1 = 10000 + (firstTag - 10000) % 10 + (secondTag - 10000) / 10;
    int newTag2 = 10000 + (firstTag - 10000) / 10 + (secondTag - 10000) % 10;
    
    if (picPosition[(firstTag - 10000) / 10 - 1][(secondTag - 10000) % 10 - 1] == 0)
    {
        return ([self horizon:firstTag second:newTag1] && [self horizon:secondTag second:newTag1]);
    }
    
    if (picPosition[(secondTag - 10000) / 10][(firstTag - 10000) % 10])
    {
        return ([self horizon:firstTag second:newTag2] && [self horizon:secondTag second:newTag2]);
    }
    else
    {
        return FALSE;
    }
}



@end