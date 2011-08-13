function show_chart(title, url) {
   $.get(url, function(data) { show_chart_data(title, data) });
}

function show_chart_data(title, data) {
   var options = {
      chart: { renderTo: 'gcontainer' },
      title: { text: title },
      rangeSelector: { selected: 1 },
      subtitle: { text: "conversions" },
      yAxis: { title: { text: "participants" } },
      series: []
   };

   var series_c = null;
   var series_p = null;
   $.each(data.split('\n'), function(lineNo, line) {
	     var items = line.split("\t");
	     var ctitle = items[0] + " conversions";
	     var ptitle = items[0] + " participants";
	     if(series_c == null || series_c.name != ctitle) {
		if(series_c != null) { options.series.push(series_p); options.series.push(series_c); }
		series_c = { data: [], name: ctitle };
		series_p = { data: [], name: ptitle };
	     }
	     var date = Date.UTC(parseInt(items[1]), parseInt(items[2]), parseInt(items[3]));
	     var value = parseFloat(items[4]);
	     series_p.data.push([date, parseFloat(items[4])]);
	     series_c.data.push([date, parseFloat(items[5])]);
          });
   options.series.push(series_p);
   options.series.push(series_c);
   var chart = new Highcharts.StockChart(options);
}
