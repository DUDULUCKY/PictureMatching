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
    [self initButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initButton
{
    for (int i = 1; i < 15; i++)
    {
        for (int j = 1; j < 9; j++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i * 10 + j + 10000;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(23 + 31 * (i - 1), 50 + 31 * (j -1), 30, 30);
            button.alpha = 0.5;
        
            [self.view addSubview:button];
        }
    }
    
    [self initBtnPic];
}

- (void)initBtnPic
{
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
                    picPosition[yPos][xPos] = picNum;
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
    
    if (tag == sender.tag) {
        return;
    }
    
    if (push == FALSE && tag == 0)
    {
        tag = sender.tag;
        push = TRUE;
    }
    else
    {
        if (tag != 0)
        {
            [self matchPic:tag second:sender.tag];
            tag = 0;
            push = FALSE;
        }
    }
}


- (void)clearButton
{
    for (int i = 1; i < 9; i++)
    {
        for (int j = 1; j < 15; j++)
        {
            UIButton *button = (UIButton *)[self.view viewWithTag:(10000 + j * 10 + i)];
            [button removeFromSuperview];
        }
    }
}

- (IBAction)reFlash:(id)sender
{
    [self clearButton];
    [self initButton];
}




//---------------------------------------------------------//

- (BOOL) matchPic:(int)firstTag second:(int)secondTag
{
    if ([self checkLink:firstTag second:secondTag])
    {
        if (picPosition[(firstTag - 10000) % 10][(firstTag - 10000) / 10]
            == picPosition[(secondTag - 10000) % 10][(secondTag - 10000) / 10]
            && picPosition[(firstTag - 10000) % 10][(firstTag - 10000) / 10] != 0
            && picPosition[(secondTag - 10000) % 10][(secondTag - 10000) / 10] != 0)
        {
            UIButton *button = (UIButton *)[self.view viewWithTag:firstTag];
            [button removeFromSuperview];
            
            button = (UIButton *)[self.view viewWithTag:secondTag];
            [button removeFromSuperview];
            
            picPosition[(firstTag - 10000) % 10][(firstTag - 10000) / 10] = 0;
            picPosition[(secondTag - 10000) % 10][(secondTag - 10000) / 10] = 0;
            
            return TRUE;
        }
    }
    
    return FALSE;
}

//同一行的判断
- (BOOL) horizon:(int)firstTag second:(int)secondTag
{
    int firstXLocation = (firstTag - 10000) / 10;
    int YLocation = (firstTag - 10000) % 10;
    int secondXLocation = (secondTag - 10000) / 10;
    
    if (firstTag == secondTag)
    {
        return FALSE;
    }
    
    int xStar = firstXLocation < secondXLocation ? firstXLocation : secondXLocation;
    int xEnd = firstXLocation > secondXLocation ? firstXLocation : secondXLocation;
    
    for (int i = xStar + 1; i < xEnd; i++)
    {
        if (picPosition[YLocation][i] != 0)
        {
            return FALSE;
        }
    }

    return TRUE;
}

//同一列的判断
- (BOOL) vertical:(int)firstTag second:(int)secondTag
{
    int firstXLocation = (firstTag - 10000) / 10;
    int firstYLocation = (firstTag - 10000) % 10;
  //int secondXLocation = (secondTag - 10000) / 10;
    int secondYLocation = (secondTag - 10000) % 10;
    
    if (firstTag == secondTag)
    {
        return FALSE;
    }
    
    int yStar = firstYLocation < secondYLocation ? firstYLocation : secondYLocation;
    int yEnd = firstYLocation > secondYLocation ? firstYLocation : secondYLocation;
    
    for (int i = yStar + 1; i < yEnd; i++)
    {
        if (picPosition[i][firstXLocation] != 0)
        {
            return FALSE;
        }
    }

    return TRUE;
}

//一个拐角的判断
- (BOOL) oneCorner:(int)firstTag second:(int)secondTag
{
    int newTag1 = 10000 + (firstTag - 10000) / 10 * 10 + (secondTag - 10000) % 10;
    int newTag2 = 10000 + (firstTag - 10000) % 10 + (secondTag - 10000) / 10 * 10;
    
    if ((picPosition[(newTag1 - 10000) % 10][(newTag1 - 10000) / 10] == 0)
        && ([self vertical:firstTag second:newTag1] & [self horizon:secondTag second:newTag1]))
    {
        return TRUE;
    }
    
    if ((picPosition[(newTag2 - 10000) % 10][(newTag2 - 10000) / 10] == 0)
        && ([self vertical:secondTag second:newTag2] & [self horizon:firstTag second:newTag2]))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

//两个拐角的判断
-(BOOL) twoCorner:(int)firstTag bTag:(int)secondTag
{
    int xLocation1 = (firstTag - 10000) / 10;
    int yLocation1 = (firstTag - 10000) % 10;
    int xLocation2 = (secondTag - 10000) / 10;
    int yLocation2 = (secondTag - 10000) % 10;
    
    for (int i = 0; i < 16; i++)
    {
        if (picPosition[(firstTag - 10000) % 10][i] == 0
            && picPosition[(secondTag - 10000) % 10][i] == 0
            && [self vertical:(10000 + i * 10 + yLocation1) second:(10000 + i * 10 + yLocation2)])
        {
            if ([self horizon:firstTag second:(10000 + i * 10 + yLocation1)]
                & [self horizon:secondTag second:(10000 + i * 10 + yLocation2)])
            {
                return TRUE;
            }
        }
    }
    
    for (int i = 0; i < 10; i++)
    {
        if (picPosition[i][(firstTag - 10000) / 10] == 0
            && picPosition[i][(secondTag - 10000) / 10] == 0
            && [self horizon:(10000 + i + xLocation1 * 10) second:(10000 + i + xLocation2 * 10)])
        {
            if ([self vertical:firstTag second:(10000 + i + xLocation1 * 10)]
                & [self vertical:secondTag second:(10000 + i + xLocation2 * 10)])
            {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}


- (BOOL) checkLink:(int)firstTag second:(int)secondTag
{
    if ((firstTag - 10000) / 10 == (secondTag - 10000) / 10
        && [self vertical:firstTag second:secondTag])
    {
        NSLog(@"---> 一列");
        return TRUE;
    }
    if ((firstTag - 10000) % 10 == (secondTag - 10000) % 10
        && [self horizon:firstTag second:secondTag])
    {
        NSLog(@"---> 一行");
        return TRUE;
    }
    if ([self oneCorner:firstTag second:secondTag])
    {
        NSLog(@"---> 一折");
        return TRUE;
    }
    else
    {
        return [self twoCorner:firstTag bTag:secondTag];
    }
}

@end