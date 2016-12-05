<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
 <!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Sequences sunburst</title>
  
 <!--    <script src="//d3js.org/d3.v3.js"></script> -->
    <link href="<%=request.getContextPath()%>/resources/css/jquery-ui-12.css" rel="stylesheet" type="text/css" />
    <link type="text/css"
	href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css"
	rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css"
      href="https://fonts.googleapis.com/css?family=Open+Sans:400,600">
    <link href="<%=request.getContextPath()%>/resources/css/sequence.css" rel="stylesheet" type="text/css" />
    
  
  </head>
  <body>
  
  
      <script src="resources/js/jquery.js"></script> 
<script type="text/javascript" src="resources/js/jquery-ui.min.js"></script>
    <script src="//d3js.org/d3.v3.min.js"></script>
    <script src="resources/js/echarts.min.js"></script>

 
    <div id="main">
      <div id="sequence">  
      </div>
      <div id="chart">
      </div>
    </div>
    <div id="sidebar">
      <input type="checkbox" id="togglelegend"> Legend<br/>
      <div id="legend" style="visibility: hidden;"></div>
    </div>
    <div id="test" style="height: 700px;width: 700px;"></div>
    
    <div id="tableContainer">
    </div>
 <div id="slider">
 <h4> <span class = "label label-default">Frequency Selector</span></h4>
 		<form action="index" method="post">
		 Min: <input type="text" name="minVal">  Max: <input type="text" name="maxVal"><button type ="submit" id="submitClicked">Submit</button></form>
		 <input type="hidden" id="minVal" value='${minVal}'/>
		 <input type="hidden" id="maxVal" value='${maxVal}'/>
 </div>
    <script type="text/javascript">
      d3.select(self.frameElement).style("height", "700px");
  </script> 
 
<script src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="resources/js/sequence.js"></script>
  
    
  </body>
</html>