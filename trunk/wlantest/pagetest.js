// 测试一个url，并将测试数据送到Server端。
//
workpath = "";
url = "";

objArgs   =   WScript.Arguments;
if ( objArgs.length>0 ){
    workpath = objArgs(0);
    url = objArgs(1);
}

// WScript.Echo("\nChecking " + url + "...\n");

// Create a new instance of HttpWatch in IE
var control = new ActiveXObject('HttpWatch.Controller');
var plugin = control.IE.New();
plugin.ClearCache();

// Start Recording HTTP traffic
plugin.Log.EnableFilter(false);
plugin.clear();
plugin.Record();

// Goto to the URL and wait for the page to be loaded
plugin.GotoURL(url);
control.Wait(plugin, 100);

// Stop recording HTTP
plugin.Stop();
plugin.Log.Save( workpath + "\\" + url + ".hwl")

var pageCount = plugin.Log.Pages.Count;
if ( pageCount > 0 )
{
    var indexPage = 0;
    var roundTrips = 0;
    for( i=0; i<pageCount; i++ ) {
        var summary = plugin.Log.Pages(i).Entries.Summary;
        var roundTrips2 = summary.RoundTrips;
        if( roundTrips2 > roundTrips ){
            roundTrips = roundTrips2;
            indexPage = i;
        }
    }
    var title = plugin.Log.Pages(indexPage).Title ;
    // Display summary statistics for page
    var resCount = plugin.Log.Pages(indexPage).Entries.Count;
    var summary = plugin.Log.Pages(indexPage).Entries.Summary;
    var loadtime = summary.Time;
    var bytesSent = summary.BytesSent;
    var bytesReceived = summary.BytesReceived;
    var compressionSavedBytes = summary.CompressionSavedBytes;
    var errorCount = summary.Errors.Count;

    // write test data to file
}
plugin.Stop();

// Close down IE
plugin.CloseBrowser();

// WScript.StdIn.ReadLine();
