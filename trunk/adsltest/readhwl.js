// 读取hwl文件，获得页面载入时间。
workpath = ""
url = ""
objArgs   =   WScript.Arguments;   
    if ( objArgs.length>0 ){   
        workpath = objArgs(0);
        url = objArgs(1);
    }   

// Create a new instance of HttpWatch in IE
var control = new ActiveXObject('HttpWatch.Controller');
var hwlfile = control.OpenLog(workpath+"\\"+url + ".hwl")

var ret = "";
if ( hwlfile.Pages.Count != 0 )
{
    var summary = hwlfile.Pages(0).Entries.Summary;
    var loadtime = summary.Time ;
}

var fs = WScript.CreateObject("Scripting.FileSystemObject");
var a = fs.OpenTextFile( workpath + "\\loadtime.txt", 8, true);
a.WriteLine( loadtime + "\t" + url +"\n");
a.Close();
//WScript.StdIn.ReadLine();
