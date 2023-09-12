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