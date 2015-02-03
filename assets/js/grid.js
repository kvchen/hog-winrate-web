!function(){function t(t){return function(e,i){e=d3.hsl(e),i=d3.hsl(i);var r=(e.h+120)*a,h=(i.h+120)*a-r,s=e.s,l=i.s-s,o=e.l,u=i.l-o;return isNaN(l)&&(l=0,s=isNaN(s)?i.s:s),isNaN(h)&&(h=0,r=isNaN(r)?i.h:r),function(a){var e=r+h*a,i=Math.pow(o+u*a,t),c=(s+l*a)*i*(1-i);return"#"+n(i+c*(-.14861*Math.cos(e)+1.78277*Math.sin(e)))+n(i+c*(-.29227*Math.cos(e)-.90649*Math.sin(e)))+n(i+c*1.97294*Math.cos(e))}}}function n(t){var n=(t=0>=t?0:t>=1?255:0|255*t).toString(16);return 16>t?"0"+n:n}var a=Math.PI/180;d3.scale.cubehelix=function(){return d3.scale.linear().range([d3.hsl(300,.5,0),d3.hsl(-240,.5,1)]).interpolate(d3.interpolateCubehelix)},d3.interpolateCubehelix=t(1),d3.interpolateCubehelix.gamma=t}();

var margin = {top: 20, right: 0, bottom: 0, left: 20},
		width = 720,
		height = 720;

var n = 100;

var x = d3.scale.ordinal()
			.domain(d3.range(n))
			.rangeRoundBands([0, width]);

var z = d3.scale.linear()
		.domain([0, 5, 10])
		.interpolate(d3.interpolateCubehelix)
		.range([d3.hsl(160, 1, 0.2), d3.hsl(60, 1, 0.9), d3.hsl(-40, 1, 0.2)])
		.clamp(true);

var p = d3.select("#moveset-grid");

var svg = p.append("svg")
		.attr("width", width + margin.left + margin.right)
		.attr("height", height + margin.top + margin.bottom)
		.style("margin-left", -margin.left + "px")
	.append("g")
		.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var displayTick = function(d, i) {
	if (i % 5 === 0) {
		return i;
	} else {
		return "";
	}
}

var plotMoveset = function(matrix) {
	svg.selectAll("*").remove();
	
	var row = svg.selectAll(".row")
			.data(matrix)
		.enter().append("g")
			.attr("class", "row")
			.attr("transform", function(d, i) { return "translate(0," + x(i) + ")"; });

	row.selectAll(".cell")
			.data(function(d) { return d; })
		.enter().append("rect")
			.style("shape-rendering", "crispEdges")
			.attr("class", "cell")
			.attr("x", function(d, i) { return x(i); })
			.attr("width", x.rangeBand())
			.attr("height", x.rangeBand())
			.style("fill", z);

	row.append("line")
			.attr("x2", width);

	row.append("text")
			.attr("x", x(0) - 6)
			.attr("y", x.rangeBand() / 2)
			.attr("dy", ".32em")
			.text(displayTick);

	var column = svg.selectAll(".column")
			.data(matrix)
		.enter().append("g")
			.attr("class", "column")
			.attr("transform", function(d, i) { return "translate(" + x(i) + ",0)";	});

	column.append("line")
			.attr("x1", -width);

	column.append("text")
			.attr("x", 6 - x(0))
			.attr("y", x.rangeBand() / 2)
			.attr("dy", ".32em")
			.attr("transform", "rotate(-90)")
			.text(displayTick);
}
