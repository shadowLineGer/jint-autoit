
var actIE = new ActiveXObject('InternetExplorer.Application');
actIE.visible = true;
actIE.navigate("http://www.baidu.com");

while(actIE.busy){
	WScript.sleep(100);
}

// Create a new instance of HttpWatch in IE
var control = new ActiveXObject('HttpWatch.Controller');
var plugin = control.IE.Attach(actIE);
plugin.ClearCache();

// Start Recording HTTP traffic
plugin.Log.EnableFilter(false);
plugin.clear();
plugin.Record();
WScript.sleep(500);

var ws = new ActiveXObject('WScript.shell');

ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("15291599968");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("111111");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{Enter}");WScript.sleep(300);

plugin.Stop();
plugin.Log.Save( "c:\\test.hwl")


while(actIE.busy){
	WScript.sleep(100);
}
WScript.sleep(2000);

ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{TAB}");WScript.sleep(300);
ws.SendKeys("{Enter}");WScript.sleep(300);
ws.SendKeys("{Enter}");WScript.sleep(300);
ws.SendKeys("{Enter}");WScript.sleep(300);

WScript.Quit();

