//
//  Match.m
//  PictureMatching
//
//  Created by fengsl on 14-8-20.
//  Copyright (c) 2014年 fengsl. All rights reserved.
//

#import "Match.h"

@implementation Match
{
    int picPosition[8][14];
    NSMutableDictionary *dic;
    
}

//同一行的判断
- (BOOL) horizon:(int)firstTag second:(int)secondTag
{
    int firstXLocation = (firstTag - 10000) / 10;
    int YLocation = (firstTag - 10000) % 10;
    int secondXLocation = (secondTag - 10000) / 10;
    //int secondYLocation = (firstTag - 10000) % 10;
    
    if (firstTag == secondTag)
    {
        return FALSE;
    }
    
    int xStar = firstXLocation < secondXLocation ? firstXLocation : secondXLocation;
    int xEnd = firstXLocation > secondXLocation ? firstXLocation : secondXLocation;
    
    for (int i = xStar + 1; i < xEnd; i++)
    {
        if (picPosition[YLocation - 1][i - 1] != 0)
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
        if (picPosition[i - 1][firstXLocation - 1] != 0)
        {
            return FALSE;
        }
    }
    
    return TRUE;
}
//一个拐角的判断
- (BOOL) oneCorner:(int)firstTag second:(int)secondTag
{
    int newTag1 = 10000 + (firstTag - 10000) % 10 + (secondTag - 10000) / 10;
    int newTag2 = 10000 + (firstTag - 10000) / 10 + (secondTag - 10000) % 10;
    
    if (picPosition[(firstTag - 10000) % 10 - 1][(secondTag - 10000) / 10 - 1] == 0)
    {
        return ([self horizon:firstTag second:newTag1] && [self horizon:secondTag second:newTag1]);
    }
    
    if (picPosition[(secondTag - 10000) % 10][(firstTag - 10000) / 10])
    {
        return ([self horizon:firstTag second:newTag2] && [self horizon:secondTag second:newTag2]);
    }
    else
    {
        return FALSE;
    }
}

-(void) scan:(int)Tag1 bTag:(int)Tag2
{
    int xLocation1 = (Tag1 - 10000) / 10;
    int yLocation1 = (Tag1 - 10000) % 10;
    int xLocation2 = (Tag2 - 10000) / 10;
    int yLocation2 = (Tag2 - 10000) % 10;
    
    
    //检测两点的左侧能否垂直相连
    for (int i = yLocation1 - 1; i >= 0; i--)
    {
        if (picPosition[i - 1][xLocation1 - 1] != 0
            && picPosition[i - 1][xLocation2 - 1] != 0
            && [self vertical:(10000 + xLocation1 * 10 + i) second:(10000 + xLocation2 * 10 + i)])
        {
            [dic setObject:[NSString stringWithFormat:@"%d", 10000 + xLocation1 * 10 + i]
                    forKey:[NSString stringWithFormat:@"%d", 10000 + xLocation2 * 10 + i]];
            return;
        }
    }
    
    //检测两点的右侧能否垂直相连
    for (int i = yLocation1 - 1; i < 14; i--)
    {
        if (picPosition[i - 1][xLocation1 - 1] != 0
            && picPosition[i - 1][xLocation2 - 1] != 0
            && [self vertical:(10000 + xLocation1 * 10 + i) second:(10000 + xLocation2 * 10 + i)])
        {
            [dic setObject:[NSString stringWithFormat:@"%d", 10000 + xLocation1 * 10 + i]
                    forKey:[NSString stringWithFormat:@"%d", 10000 + xLocation2 * 10 + i]];
            return;
        }
    }
    
    //检测两点的上侧能否水平相连
    for (int i = xLocation1 - 1; i >= 0; i--)
    {
        if (picPosition[yLocation1 - 1][i - 1] != 0
            && picPosition[yLocation2 - 1][i - 1] != 0
            && [self horizon:(10000 + i * 10 + yLocation1) second:(10000 + i * 10 + yLocation2)])
        {
            [dic setObject:[NSString stringWithFormat:@"%d", 20000 + i * 10 + yLocation1]
                    forKey:[NSString stringWithFormat:@"%d", 20000 + i * 10 + yLocation2]];
            return;
        }
    }
    
    //检测两点的下侧能否水平相连
    for (int i = xLocation1 - 1; i < 8; i--)
    {
        if (picPosition[yLocation1 - 1][i - 1] != 0
            && picPosition[yLocation2 - 1][i - 1] != 0
            && [self horizon:(10000 + i * 10 + yLocation1) second:(10000 + i * 10 + yLocation2)])
        {
            [dic setObject:[NSString stringWithFormat:@"%d", 20000 + i * 10 + yLocation1]
                    forKey:[NSString stringWithFormat:@"%d", 20000 + i * 10 + yLocation2]];
            return;
        }
    }
}

//两个拐角的判断
- (BOOL) twoCorner:(int)firstTag second:(int)secondTag
{
    [self scan:firstTag bTag:secondTag];
    
    if ([dic count] == 0)
    {
        return FALSE;
    }
    
    NSString *Tag1;
    NSString *Tag2;
    for (Tag1 in dic)
    {
        if ([Tag1 intValue] / 10000 == 2)
        {
            if ([self vertical:firstTag second:([Tag1 intValue] - 10000)]
                && [self vertical:secondTag second:([Tag2 intValue] - 10000)])
            {
                return TRUE;
            }
        }
        else
        {
            if ([Tag1 intValue] / 10000 ==1)
            {
                if ([self horizon:firstTag second:[Tag1 intValue]]
                    && [self horizon:secondTag second:[Tag2 intValue]])
                {
                    return TRUE;
                }
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
        return TRUE;
    }
    if ((firstTag - 10000) % 10 == (secondTag - 10000) % 10
        && [self horizon:firstTag second:secondTag])
    {
        return TRUE;
    }
    if ([self oneCorner:firstTag second:secondTag])
    {
        return TRUE;
    }
    else
    {
        return [self twoCorner:firstTag second:secondTag];
    }
}
/*
- (BOOL) matchPic:(int)firstTag second:(int)secondTag
{
    if ([self checkLink:firstTag second:secondTag])
    {
        NSLog(@"First Pic-->%d", picPosition[(firstTag - 10000) % 10 - 1][(firstTag - 10000) / 10 - 1]);
        NSLog(@"First Pic-->%d\n\n", picPosition[(secondTag - 10000) % 10 - 1][(secondTag - 10000) / 10 - 1]);
        if (picPosition[(firstTag - 10000) % 10 - 1][(firstTag - 10000) / 10 - 1]
            == picPosition[(secondTag - 10000) % 10 - 1][(secondTag - 10000) / 10 - 1]
            && picPosition[(firstTag - 10000) % 10 - 1][(firstTag - 10000) / 10 - 1] != 0
            && picPosition[(secondTag - 10000) % 10 - 1][(secondTag - 10000) / 10 - 1] != 0)
        {
            return TRUE;
        }
    }
    
    return FALSE;
}
*/
@end
