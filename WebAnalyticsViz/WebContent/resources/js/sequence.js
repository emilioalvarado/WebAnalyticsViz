

/*var arc = d3.svg.arc()
    .startAngle(function(d) { return d.x+100; })
    .endAngle(function(d) { return d.x + d.dx+200; })
    .innerRadius(function(d) { return Math.sqrt(d.y)+100; })
    .outerRadius(function(d) { return Math.sqrt(d.y + d.dy)+200; });*/
var minVal=0;
var maxVal=100;
var dataSend;
var width = 750;
var height = 600;
var radius = Math.min(width, height)/2;
var csv;

// Breadcrumb dimensions: width, height, spacing, width of tip/tail.
var b = {
  w: 75, h: 30, s: 3, t: 10
};

// Mapping of step names to colors.
var colors = {
  'projects':'#80ff00',
'dashboard':'#40ff00',
'users':'#00ff00',
'search':'#00ff40',
'blog':'#00ff80',
'h1.Welcome.Powtoon.users':'#00ffbf',
'reads':'#00ffff',
'account':'#00bfff',
'how.it.works#':'#0080ff',
'talent':'#0040ff',
'profile':'#0000ff',
'contest':'#4000ff',
'admin':'#8000ff',
'samples':'#bf00ff',
'article':'#ff00ff',
'talents':'#ff00bf',
'h1.Welcome.GoAnimate.users':'#ff0080',
'favorites':'#ff0040',
'translation':'#ff0000',
'voice.actors':'#ff4000',
'how.it.works':'#ff8000',
'p':'#ffbf00',
'pages':'#ffff00',
'voice':'#bfff00',
'api':'#80ff00',
'about':'#40ff00',
'h1.Welcome.Wideo.users':'#00ff00',
'profiles':'#00ff40',
'?p=pro.act.cro.web.link.from.bunnyinc.com':'#00ff80',
'contents':'#00ffbf',
'affiliates':'#00ffff',
'logo':'#00bfff',
'creative.services':'#0080ff',
'case.studies':'#0040ff',
'similar':'#0000ff',
'celebrities':'#4000ff',
'writing':'#8000ff',
'farfaria.case.study':'#bf00ff',
'account.agreement':'#ff00ff',
'quoteBoxModal':'#ff00bf',
'referrers':'#ff0080',
'how.it.works?lang=spa#':'#ff0040',
'nuance.case.study':'#ff0000',
'hits':'#ff4000',
'%22http:':'#ff8000',
'black.box.films.case.study':'#ffbf00',
'handup.case.study':'#ffff00',
'phoneunite.case.study':'#bfff00',
'wowzers.case.study':'#80ff00',
'how.it.works?lang=eng#':'#40ff00',
'pungo.games.case.study':'#00ff00',
'ringcaptcha.case.study':'#00ff40',
'signin':'#00ff80',
'h1.Welcome.Envato.users':'#00ffbf',
'account#':'#00ffff',
'eat24.case.study':'#00bfff',
'how.it.works?lang=fra#':'#0080ff',
'how.it.works?lang=deu#':'#0040ff',
'login':'#0000ff',
'project':'#4000ff',
'project_view':'#8000ff',
'read':'#bf00ff',
'error404.html':'#ff00ff',
'how.it.works?gift=sorry.bunny#':'#ff00bf',
'genderAndAges':'#ff0080',
'gender.and.ages':'#ff0040',
'error402.html':'#ff0000',
'errors':'#ff4000',
'files':'#ff8000',
'1':'#ffbf00',
'70538AE74D2631A42B78':'#ffff00',
'sdfs':'#bfff00',
'user':'#80ff00',
'unity':'#40ff00',
'translate_url':'#00ff00',
'users#':'#00ff40',
'searh':'#00ff80',
'shared':'#00ffbf',
's=4&type=m&page=2&minimumPrice=99&maximumPrice=200':'#00ffff',
'questionnaires':'#00bfff',
'projects27923C8D8841D58FAA2C':'#0080ff',
'projects811C27E5B3773C52F327#':'#0040ff',
'proyect':'#0000ff',
'proyects':'#4000ff',
'mariodelguercio':'#8000ff',
'mattpodd':'#bf00ff',
'how.it.works?lang=spa&gift=sorry.bunny#':'#ff00ff',
'how.it.works.new':'#ff00bf',
'how.it.works.new#':'#ff0080',
'javierlacroix':'#ff0040',
'language':'#ff0000',
'languages':'#ff4000',
'7350198FC1FBDD1BB322':'#ff8000',
'798285844BC3D53E8CFB':'#ffbf00',
'7ARCPGC':'#ffff00',
'844':'#bfff00',
'123':'#80ff00',
'1.backup.for.customer.reference.3':'#40ff00',
'actor_profiles':'#00ff00',
'':'#00ff40',
' ingresar':'#00ff80',
'alvaroveiga':'#00ffbf',
'articlebunny':'#00ffff',
'articles':'#00bfff',
'bellmond':'#0080ff',
'belmeier':'#0040ff',
'creative_services':'#0000ff',
'category':'#4000ff',
'b.Welcome.GroundedAnimate.users':'#8000ff',
'filtersModal':'#bf00ff',
'gender':'#ff00ff',
'genderAndAge':'#ff00bf',
'es':'#ff0080',
'fgd':'#ff0040',
'css':'#ff0000',
'error500':'#ff4000',
'error500.html':'#ff8000',
'error500php':'#ffbf00',
'gener':'#ffff00',
'h1.Welcome.GroundedAnimate.users':'#bfff00',
'how.it.works%23':'#80ff00',
'how_we_invite_talent':'#40ff00',
'how.it.':'#00ff00',
'how.it. works':'#00ff40',
'how.it.%20works#':'#00ff80'
};

// Total size of all segments; we set this later, after loading the data.
var totalSize = 0; 
var vis = d3.select("#chart").append("svg:svg")
    .attr("width", width)
    .attr("height", height)
    .append("svg:g")
    .attr("id", "container")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")
    .style("margin","50px 50px 50px 50px");

var partition = d3.layout.partition()
    .size([2 * Math.PI, radius * radius])
    .value(function(d) { return d.size; });

var arc = d3.svg.arc()
    .startAngle(function(d) { return d.x*5; })
    .endAngle(function(d) { return (d.x + d.dx)*5; })
    .innerRadius(function(d) { return (Math.sqrt(d.y))*5; })
    .outerRadius(function(d) { return( Math.sqrt(d.y + d.dy))*5; });

// Use d3.text and d3.csv.parseRows so that we do not need to have a header
// row, and can receive the csv as an array of arrays.
d3.text("sunburst-sequences.txt", function(text) {
   csv = d3.csv.parseRows(text);
  var json = buildHierarchy(csv);
  createVisualization(json);
});

// Main function to draw and set up the visualization, once we have the data.
function createVisualization(json) {

  // Basic setup of page elements.
  initializeBreadcrumbTrail();
  drawLegend();
  d3.select("#togglelegend").on("click", toggleLegend);

  // Bounding circle underneath the sunburst, to make it easier to detect
  // when the mouse leaves the parent g.
  vis.append("svg:circle")
      .attr("r", radius)
      .style("opacity", 0);

  // For efficiency, filter nodes to keep only those large enough to see.
  var nodes = partition.nodes(json)
      .filter(function(d) {
      return (d.dx > 0.005); // 0.005 radians = 0.29 degrees
      });

  var path = vis.data([json]).selectAll("path")
      .data(nodes)
      .enter().append("svg:path")
      .attr("display", function(d) { return d.depth ? null : "none"; })
      .attr("d", arc)
      .attr("fill-rule", "evenodd")
      .style("fill", function(d) { return colors[d.name]; })
      .style("opacity", 1)
      .on("mouseover", mouseover)
      .on('click',click);

  // Add the mouseleave handler to the bounding circle.
  d3.select("#container").on("mouseleave", mouseleave);

  // Get total size of the tree = value of root node from partition.
  totalSize = path.node().__data__.value;
 };

// Fade all but the current sequence, and show it in the breadcrumb trail.
 function click(d)
 {
	 var sequenceArray = getAncestors(d);
	  dataSend='';
	 for(var i=0;i<sequenceArray.length ;i++)
		{
		 dataSend+=sequenceArray[i].name
		 if(i!= sequenceArray.length-1)
			 dataSend+="-"
		}

		$.ajax({
		  	  type: "POST",
		      url: "generateChart",
		      data :{dataSend :dataSend},
		      success:function(data){
		    	  var user = JSON.parse(data);
		    	  var date=[];
		    	  var visits=[];
		    	  for(var key in user)
		    		  {
		    		  		date[key]=user[key].date;
		    		  		visits[key]=user[key].visits;
		    		  }
		    	  console.log(date);
		    	  console.log(visits);
		    	  genearteChart(date,visits)
		    	
		    		  
		},
		error : function(result)
		{ 

		}
		});
 }
function mouseover(d) {

  var percentage = (100 * d.value / totalSize).toPrecision(3);
  var percentageString = percentage + "%";
  if (percentage < 0.1) {
    percentageString = "< 0.1%";
  }

  d3.select("#percentage")
      .text(percentageString);

  d3.select("#explanation")
      .style("visibility", "");

  var sequenceArray = getAncestors(d);
  updateBreadcrumbs(sequenceArray, percentageString);

  // Fade all the segments.
  d3.selectAll("path")
      .style("opacity", 0.3);

  // Then highlight only those that are an ancestor of the current segment.
  vis.selectAll("path")
      .filter(function(node) {
                return (sequenceArray.indexOf(node) >= 0);
              })
      .style("opacity", 1);
}

// Restore everything to full opacity when moving off the visualization.
function mouseleave(d) {

  // Hide the breadcrumb trail
  d3.select("#trail")
      .style("visibility", "hidden");

  // Deactivate all segments during transition.
  d3.selectAll("path").on("mouseover", null);

  // Transition each segment to full opacity and then reactivate it.
  d3.selectAll("path")
      .transition()
      .duration(1000)
      .style("opacity", 1)
      .each("end", function() {
              d3.select(this).on("mouseover", mouseover);
            });

  d3.select("#explanation")
      .style("visibility", "hidden");
}

// Given a node in a partition layout, return an array of all of its ancestor
// nodes, highest first, but excluding the root.
function getAncestors(node) {
  var path = [];
  var current = node;
  while (current.parent) {
    path.unshift(current);
    current = current.parent;
  }
  return path;
}

function initializeBreadcrumbTrail() {
  // Add the svg area.
  var trail = d3.select("#sequence").append("svg:svg")
      .attr("width", width)
      .attr("height", 50)
      .attr("id", "trail");
  // Add the label at the end, for the percentage.
  trail.append("svg:text")
    .attr("id", "endlabel")
    .style("fill", "#000");
}

// Generate a string that describes the points of a breadcrumb polygon.
function breadcrumbPoints(d, i) {
  var points = [];
  points.push("0,0");
  points.push(b.w + ",0");
  points.push(b.w + b.t + "," + (b.h / 2));
  points.push(b.w + "," + b.h);
  points.push("0," + b.h);
  if (i > 0) { // Leftmost breadcrumb; don't include 6th vertex.
    points.push(b.t + "," + (b.h / 2));
  }
  return points.join(" ");
}

// Update the breadcrumb trail to show the current sequence and percentage.
function updateBreadcrumbs(nodeArray, percentageString) {

  // Data join; key function combines name and depth (= position in sequence).
  var g = d3.select("#trail")
      .selectAll("g")
      .data(nodeArray, function(d) { return d.name + d.depth; });

  // Add breadcrumb and label for entering nodes.
  var entering = g.enter().append("svg:g");

  entering.append("svg:polygon")
      .attr("points", breadcrumbPoints)
      .style("fill", function(d) { return colors[d.name]; });

  entering.append("svg:text")
      .attr("x", (b.w + b.t) / 2)
      .attr("y", b.h / 2)
      .attr("dy", "0.35em")
      .attr("text-anchor", "middle")
      .text(function(d) { return d.name; });

  // Set position for entering and updating nodes.
  g.attr("transform", function(d, i) {
    return "translate(" + i * (b.w + b.s) + ", 0)";
  });

  // Remove exiting nodes.
  g.exit().remove();

  // Now move and update the percentage at the end.
  d3.select("#trail").select("#endlabel")
      .attr("x", (nodeArray.length + 0.5) * (b.w + b.s))
      .attr("y", b.h / 2)
      .attr("dy", "0.35em")
      .attr("text-anchor", "middle")
      .text(percentageString);

  // Make the breadcrumb trail visible, if it's hidden.
  d3.select("#trail")
      .style("visibility", "");

}

function drawLegend() {

  // Dimensions of legend item: width, height, spacing, radius of rounded rect.
  var li = {
    w: 75, h: 30, s: 3, r: 3
  };

  var legend = d3.select("#legend").append("svg:svg")
      .attr("width", li.w)
      .attr("height", d3.keys(colors).length * (li.h + li.s));

  var g = legend.selectAll("g")
      .data(d3.entries(colors))
      .enter().append("svg:g")
      .attr("transform", function(d, i) {
              return "translate(0," + i * (li.h + li.s) + ")";
           });

  g.append("svg:rect")
      .attr("rx", li.r)
      .attr("ry", li.r)
      .attr("width", li.w)
      .attr("height", li.h)
      .style("fill", function(d) { return d.value; });

  g.append("svg:text")
      .attr("x", li.w / 2)
      .attr("y", li.h / 2)
      .attr("dy", "0.35em")
      .attr("text-anchor", "middle")
      .text(function(d) { return d.key; });
}

function toggleLegend() {
  var legend = d3.select("#legend");
  if (legend.style("visibility") == "hidden") {
    legend.style("visibility", "");
  } else {
    legend.style("visibility", "hidden");
  }
}

// Take a 2-column CSV and transform it into a hierarchical structure suitable
// for a partition layout. The first column is a sequence of step names, from
// root to leaf, separated by hyphens. The second column is a count of how 
// often that sequence occurred.
function buildHierarchy(csv) {
  var root = {"name": "root", "children": []};
  for (var i = 0; i < csv.length; i++) {
    var sequence = csv[i][0];
    var size = +csv[i][1];
  /*  console.log(minVal +"  "+maxVal);
    */
    console.log(size+"P");
    if (isNaN(size)) { // e.g. if this is a header row
      continue;
    }
 
    var parts = sequence.split("-");
    var currentNode = root;
    for (var j = 0; j < parts.length; j++) {
      var children = currentNode["children"];
      var nodeName = parts[j];
      var childNode;
      if (j + 1 < parts.length) {
   // Not yet at the end of the sequence; move down the tree.
 	var foundChild = false;
 	for (var k = 0; k < children.length; k++) {
 	  if (children[k]["name"] == nodeName) {
 	    childNode = children[k];
 	    foundChild = true;
 	    break;
 	  }
 	}
  // If we don't already have a child node for this branch, create it.
 	if (!foundChild) {
 	  childNode = {"name": nodeName, "children": []};
 	  children.push(childNode);
 	}
 	currentNode = childNode;
      } else {
 	// Reached the end of the sequence; create a leaf node.
 	childNode = {"name": nodeName, "size": size};
        //console.log(childNode);
 	children.push(childNode);
      }
    }
  }
  return root;
};

function genearteChart(date,visits)
{
	  var myChart = echarts.init(document.getElementById('test')); 	     

	option = {
		    title : {
		        text: 'Number Of Visitors With Date',
		    },
		    toolbox: {
		        show : true,
		        feature : {
		       dataView : {show: true, readOnly: false, title:'Data View' , lang: ['Data', 'Stop', 'Reload']},
		            magicType : {show: true, type: ['line', 'bar'],title:'Chart'},
		            restore : {show: true, title : 'Reload'},
		            saveAsImage : {show: true,
		            	 title : 'Save'	
		            }
		        }
		    },
	    xAxis: {
	        data: date
	    },
	    yAxis: {
	        axisLine: {
	            show: false
	        },
	        axisTick: {
	            show: false
	        },
	        axisLabel: {
	            textStyle: {
	                color: '#999'
	            }
	        }
	    },
	    series: [

	        {
	            type: 'bar',
	            itemStyle: {
	                normal: {
	                    color: new echarts.graphic.LinearGradient(
	                        0, 0, 0, 1,
	                        [
	                            {offset: 0, color: '#83bff6'},
	                            {offset: 0.5, color: '#188df0'},
	                            {offset: 1, color: '#188df0'}
	                        ]
	                    )
	                },
	                emphasis: {
	                    color: new echarts.graphic.LinearGradient(
	                        0, 0, 0, 1,
	                        [
	                            {offset: 0, color: '#2378f7'},
	                            {offset: 0.7, color: '#2378f7'},
	                            {offset: 1, color: '#83bff6'}
	                        ]
	                    )
	                }
	            },
	            data: visits
	        }
	    ]
	};
	 myChart.setOption(option); 
	myChart.on('click', function (params) {
		var date = params.name ;
		$.ajax({
		  	  type: "POST",
		      url: "generateTable",
		      data :{dataSend :dataSend, date: date},
		      success:function(data){
		    	  var user = JSON.parse(data);
		    	  generateTable(user);
		    	
		    		  
		},
		error : function(result)
		{ 

		}
		});
	});
}
function   generateTable(user)
{
	$("#tableContainer").html('');
	var table ='<table id= "table" class="table table-condensed  table-hover"><thead>';
	table+='<th style="background-color: #D9D9D9; color: #000000">User Id</th><th  style="background-color: #D9D9D9; color: #000000">Domain SessionId</th><th  style="background-color: #D9D9D9; color: #000000">Domain UserId</th><th  style="background-color: #D9D9D9; color: #000000">NavPath</th><th style="background-color: #D9D9D9; color: #000000">Page Url</th><th style="background-color: #D9D9D9; color: #000000">Device Stmp</th></thead><tbody>';
	
	for(var key in user)
		{
		
			table += '<tr><td>'+user[key].userId+'</td>';
			table += '<td>'+user[key].domainSessionId+'</td>';
			table += '<td>'+user[key].domainUserId+'</td>';
			table += '<td>'+user[key].navPath+'</td>';
			table += '<td>'+user[key].pageUrl+'</td>';
			table += '<td>'+user[key].dateStmp+'</td></tr>';
			
		}
	table+='</tbody></table>'
	$("#tableContainer").append(table);
    $('#table').DataTable();	
	}

function showValue(newValue)
{
	minVal = newValue
	document.getElementById("range").innerHTML=newValue;
 	d3.text("sunburst-sequences.txt", function(text) {
		  var csv = d3.csv.parseRows(text);
		  var json = buildHierarchy(csv);
		  createVisualization(json);
		}); 
}
function showValueMax(newValue)
{
	maxVal=newValue;
	document.getElementById("rangeMax").innerHTML=newValue;
		  var json = buildHierarchy(csv);
		  createVisualization(json);
		
}