# Peter Xue
# 2021-04
# text analysis homework
# -*- coding: utf-8 -*-

# 统计文件file1.txt文件中包含的字符个数和行数
f=open('file1.txt','r')
txt=f.read()
print('字符个数%d'%len(txt))
f=open('file1.txt','r')
lis=f.readlines()
print('行数%d'%len(lis))

# 词频统计1
import string
txt='Different people have different dreams. Some people dream of making a lot of money. Some people dream of living a happy life. Some people dream of being famous. Some people dream of going abroad, and so on.But my dream is different. Maybe you will get a surprise after you know my dream.'

txt=txt.lower()
for i in string.punctuation:
    txt=txt.replace(i,'')
lis=txt.split()
print(lis)
print('有%d个单词'%len(lis))
x=input('请输入想要查找的单词:')
count=0
for i in lis:
    if x==i:
        count=count+1
print('单词%s出现的次数%d'%(x,count))

# 词频统计2
txt='Different people have different dreams. Some people dream of making a lot of money. Some people dream of living a happy life. Some people dream of being famous. Some people dream of going abroad, and so on.But my dream is different. Maybe you will get a surprise after you know my dream.'
import string
txt=txt.lower()
for i in string.punctuation:
    txt=txt.replace(i,' ')
lis=txt.split()
print(lis)
print('这段文本一共有%d个单词'%len(lis))
d={}
for i in lis:
    if i not in d.keys():
        d[i]=1
    else:
        d[i]+=1
x=list(d.items())
x.sort(key=lambda x:x[1],reverse=True)
print(x)
for i in x:
    print('单词%s出现的次数为%d'%(i[0],i[1]))

# 对file1.txt文件复制一份保存到file2.txt中，然后再把每一行按逆序方式输出到file3.txt文件中
f=open('file1.txt','rt')
f2=open('file2.txt','wt')
f3=open('file3.txt','wt')
s=f.read()
f2.write(s)
s1=s[::-1]
f3.write(s1)

# 读取xindiantu.txt文件中的心电图数据，利用turtle绘制心电图图形
import turtle as t
t.setup(600,600)
t.pencolor('black')
t.penup()
t.speed(10)
t.goto(-300,0)
t.pendown()
f=open('xindiantu.txt')
lis=f.readlines()
# print(lis)
x=0
while x<len(lis)-1:
    t.goto(-300+x,int(lis[x]))
    x=x+1
t.done()

# scores.txt中存放着某班学生的计算机成绩，包含学号、平时成绩、期末成绩三列。请根据平时成绩占40%，期末占60%的比例计算总评成绩，并按学号、总评成绩# 两列写入另一个文件scored.txt中。同时再屏幕上输出学生总人数，按总评成绩计算90分以上、80~89分、 70~79分、
# 60~69分、 60分以下各成绩区间的人数和班级总平均分（保留2位小数）
f=open('scores.txt','rt')
fout=open('scored.txt','wt')
fout.write('学号\t总评\n')
sum,zp90,zp80,zp70,zp60,zp00=(0,0,0,0,0,0)
lis=f.readlines()
lis=lis[1:]
for i in lis:
    stu=i.split()
    for j in range(1,3):
        stu[j]=int(stu[j])
    zp=0.4*stu[1]+0.6*stu[2]
    sum=sum+zp
    if 90<=zp<=100:
        zp90+=1
    elif zp>=80:
        zp80+=1
    elif zp>=70:
        zp70+=1
    elif zp>=60:
        zp60+=1
    else:
        zp00+=1
    fout.write('%s\t%0.2f\n'%(stu[0],zp))
f.close()
fout.close()
avr=sum/(len(lis))
print('学生总人数%d,按总评成绩：90分以上%d人、80~89分%d人、70~79分%d人、60~69分%d人、 60分以下%d人，班级平均分%0.2f'%(len(lis),zp90,zp80,zp70,zp60,zp00,avr))

# 把 I hava a dream.txt的词语以词云形式展示出来
import wordcloud
from imageio import imread
f=open('i_have_a_dream.txt','rt')
txt=f.read()
m=imread('fivestar.jpg')
w = wordcloud.WordCloud(width=800,height=600, background_color = "white",mask=m)
w.generate(txt)
w.to_file("dream.png")


# 把2021年1号文件里的政府工作报告以词云的形式展示出来，形状用中国地图的形式。
import jieba
import wordcloud
from imageio import imread
import matplotlib.colors as c
cl= c.ListedColormap(['#FF0000','#007F00','#0000C4'])
m = imread("china.png")
f = open("2021年1号.txt", "r", encoding="utf-8")
t = f.read()
stopword=['和','的','在','为','等']
f.close()
ls = jieba.lcut(t)
txt = " ".join(ls)
w = wordcloud.WordCloud(mask = m, width = 1000, height = 700, background_color = "black",colormap=cl, font_path='C:/Windows/Fonts/STZHONGS.TTF',stopwords=stopword)
w.generate(txt)
w.to_file("baogaocloud.png")

'''附件是《沉默的羔羊》中文版内容，请读入内容，分词后输出长度大于2且出现次数最多的前10位词语。‪‪‪‪‪‫‫‪‪‪‪‪‪‪‪‪‪‪‫‫‪‪‪‪‪‫‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‫‪‪‪‪‪‪‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬‬'''
import jieba
f=open('沉默的羔羊.txt','rt',encoding='utf-8')
txt=f.read()
lis=jieba.lcut(txt)
stopword=[]
dic={}
for i in lis:
    if len(i)==1:
        continue
    else:
        if i not in stopword:
            if i not in dic:
                dic[i]=1
            else:
                dic[i]+=1
newlis=list(dic.items())
newlis.sort(key=lambda x:x[1],reverse=True)
for i in newlis[0:10]:
    print('%s\t出现的次数为\t%d'%(i[0],i[1]))
f.close()

'''统计英文文章《we are all fighters》单词出现的次数，并排序输出. 再完善程序，去掉介词和冠词等后出现最多的前15个词语'''
import string
f=open('we are all fighter.txt','rt',encoding='utf-8')
txt=f.read()
f.close()
txt=txt.lower()
exclude=['in','on','at','a','an','the','to','of']
for i in string.punctuation:
    txt=txt.replace(i,' ')
lis=txt.split()
dic={}
for i in lis:
    if i not in exclude:
        dic[i]=dic.get(i,0)+1
newlis=list(dic.items())
newlis.sort(key=lambda x:x[1],reverse=True)
for i in newlis[0:15]:
    print('%s出现的次数为%d'%(i[0],i[1]))