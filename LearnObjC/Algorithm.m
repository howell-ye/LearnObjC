//
//  Algorithm.m
//  LearnObjC
//
//  Created by yehowell on 2018/4/9.
//  Copyright © 2018年 howell. All rights reserved.
//

#import "Algorithm.h"

@implementation Algorithm


struct node
{
    int val;
    struct node *pNext;
};

//求字节中“1”的个数，方法一
uint8_t bitcount(uint8_t n)
{
    uint8_t count=0 ;
    while (n)
    {
        count++ ;
        n &= (n - 1) ;
    }
    return count ;
}
//求字节中“1”的个数，方法二
uint8_t count_ones(uint8_t a)
{
    int count = 0;
    
    for (; a; a >>= 1) {
        if (a & 1) count ++;
    }
    return count;
}

//反转字符串
void reverse(char* str)
{
    char* p = str + strlen(str)-1;
    char temp;
    while(str<p)
        
        temp=*p, *p--=*str, *str++=temp;
}
//反转字符串
void Reverse(char *s,int n){
    for(int i=0,j=n-1;i<j;i++,j--){
        char c=s[i];
        s[i]=s[j];
        s[j]=c;
    }
}

//反转链表-递归实现
struct node * reverse_recursion(struct node *pHead)
{
    if (pHead == NULL || pHead -> pNext == NULL)
    {
        return pHead;
    }
    struct node *p = pHead -> pNext;
    struct node *pNewHead =  reverse_recursion(p);
    p -> pNext = pHead;
    pHead ->pNext = NULL;
    return pNewHead;
}

//反转链表-尾递归实现
struct node * do_reverse_tail(struct node *pHead, struct node *pNewHead)
{
    if(pHead == NULL)
    {
        return pNewHead;
    }
    else
    {
        struct node *pNext = pHead->pNext;
        pHead->pNext = pNewHead;
        return do_reverse_tail(pNext, pHead);
    }
}

struct node * reverse_tail(struct node *pHead)
{
    return do_reverse_tail(pHead, NULL);
}

//反转链表-迭代实现
struct node * reverse_it(struct node *pHead)
{
    struct node *pNewHead = NULL;
    struct node *pPrev = NULL;
    struct node *pCur = pHead;
    while(pCur != NULL)
    {
        struct node *pTmp = pCur->pNext;
        if(pTmp == NULL)
        {
            pNewHead = pCur;
        }
        pCur->pNext = pPrev;
        pPrev = pCur;
        pCur = pTmp;
    }
    
    return pNewHead;
}

//字符形转数字
int atoi_my(const char *str)
{
    int s=0;
    bool falg=false;
    //处理前面的空格
    while(*str==' ')
    {
        str++;
    }
    //处理正负号
    if(*str=='-'||*str=='+')
    {
        if(*str=='-')
            falg=true;
        str++;
    }
    
    while(*str>='0'&&*str<='9')
    {
        s=s*10+*str-'0';
        str++;
        if(s<0)//内存溢出
        {
            s=2147483647;
            break;
        }
    }
    return s*(falg?-1:1);
}


//求最大公约数
int hcf(int u,int v)
{    int temp;
    if (u<v)
    {temp=u;u=v;v=temp;}
    while (v!=0)//碾转相除法
    {
        temp=u%v;
        u=v;
        v=temp;
    }
    return u;
}

//求最小公倍数
int lcd(int u,int v,int h)
{
    return(u*v/h);
}

//冒泡排序
void bubble_sort(int *array,int num)
{
    int i = 0;
    int j = 0;
    int temp;
    for(;j < num;++j)
    {
        for(i= num;i >j ;--i)
        {
            if(array[i] < array[i-1])
            {
                temp =array[i];
                array[i] = array[i-1];
                array[i-1] = temp;
            }
        }
    }
}
//插入排序
void insertion_sort(int *array,int num)
{
    int i,j;
    int temp;
    i = 0;
    j = 0;
    for(;i < num;i++)
    {
        for(j=i;(j > 0)&&(array[j] < array[j-1]);j--)
        {
            temp =  array[j-1];
            array[j-1] = array[j];
            array[j] = temp;
        }
    }
}

//选择排序
void Select_Sort(int arr[],int n)
{
    int i,j,k,temp;
    for(i=0;i<n;i++)
    {
        k=i;
        for(j=i+1;j<n;j++)
        {
            if(arr[j]<arr[k]) k = j;
        }
        if(k>i)
        {
            temp = arr[i];
            arr[i] = arr[k];
            arr[k] = temp;
        }
    }
}

@end








