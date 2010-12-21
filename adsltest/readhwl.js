// 读取hwl文件，获得页面载入时间。
// 写入loadtime.txt中。
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

var loadtime = 0; 
var pageCount = hwlfile.Pages.Count;
if( pageCount > 0 ) {
    for (i=0; i < pageCount; i++ )
    {
        var summary = hwlfile.Pages(i).Entries.Summary;
        var loadtime2 = summary.Time ;
        if( loadtime2 > loadtime ) {
            loadtime = loadtime2;
        }
    }
}
var fs = WScript.CreateObject("Scripting.FileSystemObject");
var a = fs.OpenTextFile( workpath + "\\loadtime.txt", 8, true);
a.WriteLine( loadtime + "\t" + url );
a.Close();
//WScript.StdIn.ReadLine();
