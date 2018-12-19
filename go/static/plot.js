/* global d3 */

let standards = {
    rawData: [],
    plot_kVp: 9,
    plot_mA: 0.25,
    plot_tmin: new Date(),
    plot_tmax: new Date(),
    vals_kVp: {},
    vals_mA: {},
    vals_tmin: new Date(3000,0,1),
    vals_tmax: new Date(1000,0,1)
};

// Initial chart setup //

let SVGwidth = 1200,
SVGheight = 800,
margin = {top: 100, right: 150, bottom: 100, left: 100},
width = SVGwidth - margin.left - margin.right,
height = SVGheight - margin.top - margin.bottom;

let viewBox = "0 0 " + SVGwidth.toString() + " " + SVGheight.toString();

let svg = d3.select("#plotSect").append("svg")
    .attr("id", "plot")
    .attr("viewBox", viewBox)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  
let tooltip = d3.select("#plotSect").append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);
    
let xScaleInit = d3.scaleTime().range([0, width]),
    xAxisInit = d3.axisBottom(xScaleInit);
    
let yScaleInit = d3.scaleLinear().range([height, 0]),
    yAxisInit = d3.axisLeft(yScaleInit);
        
svg.append("g")
    .attr("class", "xAxis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxisInit);
    
svg.append("text")
    .attr("class", "axisLabel")
    .attr("transform", "translate(" + (width/2) + " ," + (height + 50) + ")")
    .style("text-anchor", "middle")
    .text("Measurement Date");
        
svg.append("g")
    .attr("class", "yAxis")
    .call(yAxisInit);
        
svg.append("text")
    .attr("class", "axisLabel")
    .attr("transform", "rotate(-90)")
    .attr("x", 0 - (height/2))
    .attr("y", 0 - Math.round((margin.left/1.5)))
    .style("text-anchor", "middle")
    .text("Throughput (CPS)");
        
let series = [50,100,150];
let legendY = height - 100;
let legend = svg.selectAll(".legend")
    .data(series)
    .enter().append("g")
    .attr("class", "legend")
    .attr("transform", function(d,i) { return "translate(0," + (legendY + (i * 25)) + ")"; });

legend.append("rect")
    .attr("x", width-20)
    .attr("width", 20)
    .attr("height", 20)
    .style("fill", color);
    
legend.append("text")
    .attr("x", width-25)
    .attr("y", 10)
    .attr("dy", "0.5em")
    .style("text-anchor", "end")
    .text(function(d) { return d; });

// Loading the raw data and creating the default plot and UI settings //

d3.csv("summaries.csv", function(error, data) {
    if (error) {
        let errorDiv = document.getElementById("errorSect");
        errorDiv.innerHTML = "There was an error reading the data file.";
        return;
    }
   // Name,X,Date,CPS,kVp,mA,DC Slit,CC Slit
   
    data.forEach(function(d){
        d["X"] = +d["X"];
        d["Date"] = parseDate(d["Date"]);
        d["CPS"] = +d["CPS"];
        d["kVp"] = +d["kVp"];
        d["mA"] = +d["mA"];
        d["DC Slit"] = +d["DC Slit"];
        d["CC Slit"] = +d["CC Slit"];
        
        if (d["Date"] < standards.vals_tmin) {
            standards.vals_tmin = d["Date"];
        }
        if (d["Date"] > standards.vals_tmax) {
            standards.vals_tmax = d["Date"];
        }
        standards.vals_kVp[d["kVp"]] = true;
        standards.vals_mA[d["mA"]] = true;
    });
    standards.plot_tmin = new Date(standards.vals_tmin.valueOf());
    standards.plot_tmax = new Date(standards.vals_tmax.valueOf());
    standards.rawData = data;
    updatePlot(standards.rawData);
    initializeUI();
    
    return;
});

// functions for updating the chart and parsing and manipulating the raw data //

function filterPoints(d) {
    let xPass = false;
    let sizePass = false;
    let excitePass = false;
    let datePass = false;
    
    if ((d["X"] == 50) || (d["X"] == 100) || (d["X"] == 150)) {
        xPass = true;
    }
    if ((d["DC Slit"] == 10) && (d["CC Slit"] == 12)) {
        sizePass = true;
    }
    if ((d["kVp"] == standards.plot_kVp) && (d["mA"] == standards.plot_mA)) {
        excitePass = true;
    }
    if ((d["Date"] >= standards.plot_tmin) && (d["Date"] <= standards.plot_tmax)) {
        datePass = true;
    }
    return xPass && sizePass && excitePass && datePass;
}

// 08-01-2017 16:15:15 //
function parseDate(dateStr) {
    let dateParts = dateStr.split(" ");
    let calDate = dateParts[0];
    let timeDate = dateParts[1];
    let calParts = calDate.split("-");
    let timeParts = timeDate.split(":");
    let year = +calParts[2];
    let month = +calParts[0] - 1;
    let day = +calParts[1];
    let hour = +timeParts[0];
    let minute = +timeParts[1];
    let second = +timeParts[2];
    let dateObj = new Date(year, month, day, hour, minute, second);
    return dateObj;
}

function color(x) {
    if (x == 50) {
        return "steelblue";
    } else if (x == 100) {
        return "orange";
    } else if (x == 150) {
        return "green";
    }
    return "black"; 
}

function tooltipHTML(d) {
    let dateStr = (d["Date"].getMonth() + 1) + "/" + (d["Date"].getDate()) + "/" + (d["Date"].getFullYear());
    let html = d["Name"] + "<br/>X = " + d["X"] + "<br/>";
    html = html + dateStr + "<br/>" + d["CPS"];
    return html;
}

function updatePlot(rawData) {
    // Name,X,Date,CPS,kVp,mA,DC Slit,CC Slit
    let filteredData = rawData.filter(filterPoints);
    
    let xValue = function(d) { return d["Date"]; };
    let xScale = d3.scaleTime().range([0, width]);
    let xAxis = d3.axisBottom(xScale);
    let xMap = function(d) { return xScale(xValue(d)); };
    xScale.domain([standards.plot_tmin, standards.plot_tmax]); ///////////////
    
    let yValue = function(d) { return d["CPS"]; };
    let yScale = d3.scaleLinear().range([height, 0]);
    let yAxis = d3.axisLeft(yScale);
    let yMap = function(d) { return yScale(yValue(d)); };
    yScale.domain([0, (d3.max(filteredData, yValue)*1.1)]);
    
    let plotSect = document.getElementById("plotSect");
    
    var pts = svg.selectAll(".point").remove();
    pts = svg.selectAll(".point").data(filteredData);
    
    pts.enter().append("circle")
        .attr("class", "point")
        .attr("r", 5)
        .attr("cx", xMap)
        .attr("cy", yMap)
        .style("fill", function(d) { return color(d["X"]); })
        .on("mouseover", function(d) {
            tooltip.html(tooltipHTML(d))
                .style("left", (d3.event.pageX + 5) + "px")
                .style("top", (d3.event.pageY - Math.round(plotSect.offsetTop)) + "px")
                .style("opacity", 0.9);
        })
        .on("mouseout", function(d) {
            tooltip.style("opacity", 0);
        });
        
    svg.select(".xAxis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);
    
    svg.select(".yAxis")
        .call(yAxis);
}

// Functions for updating the UI and triggering the chart updates based on user input //

function initializeUI() {
    let list_kVp = document.getElementById("list_kVp");
    let list_mA = document.getElementById("list_mA");
    for (let val in standards.vals_kVp) {
        let option = document.createElement("option");
        option.text = val;
        option.value = val;
        list_kVp.add(option);
    }
    for (let val in standards.vals_mA) {
        let option = document.createElement("option");
        option.text = val;
        option.value = val;
        list_mA.add(option);
    }
    list_kVp.value = standards.plot_kVp;
    list_mA.value = standards.plot_mA;
    
    let start_Yr = document.getElementById("start_Yr");
    let start_Mo = document.getElementById("start_Mo");
    let start_Day = document.getElementById("start_Day");
    let end_Yr = document.getElementById("end_Yr");
    let end_Mo = document.getElementById("end_Mo");
    let end_Day = document.getElementById("end_Day");
    start_Yr.value = standards.plot_tmin.getFullYear();
    start_Mo.value = standards.plot_tmin.getMonth();
    start_Day.value = standards.plot_tmin.getDate();
    end_Yr.value = standards.plot_tmax.getFullYear();
    end_Mo.value = standards.plot_tmax.getMonth();
    end_Day.value = standards.plot_tmax.getDate();
    return;
}

function setFilters() {
    let list_kVp = document.getElementById("list_kVp");
    let list_mA = document.getElementById("list_mA");
    let start_Yr = document.getElementById("start_Yr");
    let start_Mo = document.getElementById("start_Mo");
    let start_Day = document.getElementById("start_Day");
    let end_Yr = document.getElementById("end_Yr");
    let end_Mo = document.getElementById("end_Mo");
    let end_Day = document.getElementById("end_Day");
    
    let start_Yr_val = (+start_Yr.value);
    let start_Mo_val = (+start_Mo.value);
    let start_Day_val = (+start_Day.value);
    let end_Yr_val = (+end_Yr.value);
    let end_Mo_val = (+end_Mo.value);
    let end_Day_val = (+end_Day.value);
    
    standards.plot_kVp = list_kVp.value;
    standards.plot_mA = list_mA.value;
    if (!isNaN(start_Yr_val) && !isNaN(start_Day_val)){
        standards.plot_tmin.setFullYear(start_Yr_val);
        standards.plot_tmin.setMonth(start_Mo_val);
        standards.plot_tmin.setDate(start_Day_val);
    } else {
        alert("Not a valid number for starting year and/or day");
    }
    if (!isNaN(end_Yr_val) && !isNaN(end_Day_val)){
        standards.plot_tmax.setFullYear(end_Yr_val);
        standards.plot_tmax.setMonth(end_Mo_val);
        standards.plot_tmax.setDate(end_Day_val);
    } else {
        alert("Not a valid number for ending year and/or day");
    }
    updatePlot(standards.rawData);
    return;
}
