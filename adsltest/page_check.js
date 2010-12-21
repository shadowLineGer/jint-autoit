// 测试一个url，并将测试数据送到Server端。
//
workpath = "";
url = "";
serverUrl = "";
otherReqStr = ""

objArgs   =   WScript.Arguments;   
if ( objArgs.length>0 ){   
    workpath = objArgs(0);
    url = objArgs(1);
    serverUrl = objArgs(2);
    otherReqStr = objArgs(3);
}

WScript.Echo("\nChecking " + url + "...\n");

// Create a new instance of HttpWatch in IE
var control = new ActiveXObject('HttpWatch.Controller');
var plugin = control.IE.New();

// Start Recording HTTP traffic
plugin.Log.EnableFilter(false);
plugin.Record();

// Goto to the URL and wait for the page to be loaded
plugin.GotoURL(url);
control.Wait(plugin, 120);

// Stop recording HTTP
plugin.Stop();
plugin.Log.Save( workpath + "\\" + url + ".hwl")

if ( plugin.Log.Pages.Count != 0 )
{
    var title = plugin.Log.Pages(0).Title ;
    // Display summary statistics for page
    var summary = plugin.Log.Pages(0).Entries.Summary;
    var loadtime = summary.Time;
    var bytesSent = summary.BytesSent;
    var bytesreceived = summary.BytesReceived;
    var compressionSavedBytes = summary.CompressionSavedBytes;
    var roundTrips = summary.RoundTrips;
    var errorCount = summary.Errors.Count;
}
var urlSendData = serverUrl + otherReqStr + "&url=" + url + "&loadtime=" + loadtime ;
plugin.GotoURL(urlSendData);
control.Wait(plugin, 20);

// Close down IE
plugin.CloseBrowser();

// WScript.StdIn.ReadLine();
