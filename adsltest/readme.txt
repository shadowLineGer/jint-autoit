

这个程序现在只能在前台运行，并且接管键盘鼠标。
如果要把程序改成可在后台运行，估计在windows下用autoit是不可能了。
如果考虑后台处理，curl或者wget也许是可行的。


由于程序的认证需要GAE，所以当GAE挂了，就啥也干不成，
于是，数据的上送程序就不用考虑GAE挂掉的情况。

而对于GAE挂掉，分两种情况，一种是GAE自己挂了，那没办法。
一种是GFW搞的，那就使用代理接通两边。
（不知道“反向代理”是否说的就是这种代理，应该就是它了）



cscript //nologo page_check.js c:\temp g.cn http://kuandaiceshi.appspot.com "/savedata?place=枢纽楼4楼&roundno=2010122115&testtime=100&pingtime=10"

cscript //nologo page_check.js C:\temp\2010122700金天笔记本 10086.cn http://kuandaiceshi.appspot.com "/savedata?place=金天笔记本&roundno=2010122700&testtime=100"


cscript //nologo readhwl.js C:\temp\2010122617金天笔记本 cpro.baidu.com