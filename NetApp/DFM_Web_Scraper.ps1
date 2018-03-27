#DFM Web Scraper

#Get Website Contents
$Website = Invoke-WebRequest -UseBasicParsing -Uri "http://1.2.3.4:8080/dfm/report/view/big-graph/aggregate-usage-1d/42993/login?username=dbreader&password=12345"

#Scrape The 1w Chart
$Website.Links | Where {$_.outerHTML -like "*getSelPeriod*1w*"} |Out-GridView



<br/><br/><br/>
<pre>
<img id="GraphObj" alt="" width="560" height="320" border="0" src="http://1.2.3.4:8080/dfm/graph/aggregate-usage-1d/42993?width=560&amp;height=320&amp;group=0&amp;Login?username=dbreader"><p align="CENTER"><a id="1d" class="graphcls" href="javascript:makeAsynCall('http://1.2.3.4:8080/dfm/report/view/big-graph/42993?group=0','aggregate-usage','1d')">1d</a>&nbsp;|&nbsp;<a href="javascript:getSelPeriod('http://1.2.3.4:8080/dfm/report/view/big-graph/aggregate-usage-1w/42993?group=0')"></a><a id="1w" href="javascript:makeAsynCall('http://1.2.3.4:8080/dfm/report/view/big-graph/42993?group=0','aggregate-usage','1w')">1w</a>&nbsp;|&nbsp;<a href="javascript:getSelPeriod('http://1.2.3.4:8080/dfm/report/view/big-graph/aggregate-usage-1m/42993?group=0')"></a><a id="1m" href="javascript:makeAsynCall('http://1.2.3.4:8080/dfm/report/view/big-graph/42993?group=0','aggregate-usage','1m')">1m</a>&nbsp;|&nbsp;<a href="javascript:getSelPeriod('http://1.2.3.4:8080/dfm/report/view/big-graph/aggregate-usage-3m/42993?group=0')"></a><a id="3m" href="javascript:makeAsynCall('http://1.2.3.4:8080/dfm/report/view/big-graph/42993?group=0','aggregate-usage','3m')">3m</a>&nbsp;|&nbsp;<a href="javascript:getSelPeriod('http://1.2.3.4:8080/dfm/report/view/big-graph/aggregate-usage-1y/42993?group=0')"></a><a id="1y" href="javascript:makeAsynCall('http://1.2.3.4:8080/dfm/report/view/big-graph/42993?group=0','aggregate-usage','1y')">1y</a>

<br>
<img src = "http://1.2.3.4:8080/dfm/graph/aggregate-usage-1d/42993?height=300&width=560&Login?username=dbreader">1d</img>

<IFRAME SRC = "http://1.2.3.4:8080/dfm/graph/aggregate-usage-1d/42993?height=300&width=560&Login?username=dbreader&password=12345"></IFRAME>

1d Graph
http://1.2.3.4:8080/dfm/graph/aggregate-usage-1d/42993?height=300&width=560
</pre>
