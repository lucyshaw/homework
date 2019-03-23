
//wrap chart in a function to make it responsive to screen size
function makeResponsive() {
    //select the svg
    var svgArea = d3.select('body').selectAll('svg')

    if (!svgArea.empty()) {
        svgArea.remove()
    }

    var margin = {
        top: 50,
        bottom: 50,
        right: 50,
        left: 50
      };

    var svgWidth = window.innerWidth
    var svgHeight = window.innerHeight

    var height = svgHeight - margin.top - margin.bottom
    var width = svgWidth - margin.left - margin.right

    var svg = d3.select('#scatter')
        .append('svg')
        .attr('height', svgHeight)
        .attr('width', svgWidth)

    var chartGroup = svg.append('g')
      .attr('transform', `translate(${margin.left}, ${margin.top})`)

    //read the csv
    var x = d3.csv('assets/data/data.csv')
      .then(function(sdhData) {
        //set the x and y scales
        var xScale = d3.scaleLinear()
            .domain(d3.extent(sdhData, d => d.income))
            .range([0, width])
    
        var yScale = d3.scaleLinear()
            .domain([0, d3.max(sdhData, d => d.obesity)])
            .range([height, 0])
    //set x and y axis to the scales set above
        var xAxis = d3.axisBottom(xScale)
        var yAxis = d3.axisLeft(yScale).ticks(20)
        //append a chart group
        chartGroup.append('g')
            .attr('transform', `translate(0, ${height})`)
            .call(xAxis)
    
        chartGroup.append('g')
            .call(yAxis)
      //create the state circles  
        var circlesGroup = chartGroup.selectAll("circle")
            .data(sdhData)
            .enter()
            .append("circle")
            .attr("cx", d => xScale(d.income))
            .attr("cy", d => yScale(d.obesity))
            .attr("r", "15")
            .attr("class", "stateCircle")
        
        var textGroup = chartGroup.selectAll('.stateText')
            .data(sdhData)
            .enter()
            .append("text")
            .text(function(data) {
                
                return data.abbr;
            })
            .attr('x', d => xScale(d.income))
            .attr('y', d => yScale(d.obesity))
            .attr('class', 'stateText')
            .attr('dominant-baseline', 'middle');
    
    //adding the tooltip
        var toolTip = d3.tip()
            .attr('class', '.d3-tip')
            .offset([80, -60])
            .html(function(d) {
                return (`${d.state}<br>Obesity: ${d.obesity}<br>Income: ${d.income}`);
            });

        
        chartGroup.call(toolTip);

       //add event listeners click and mouseout 
        circlesGroup.on("click", function(data) {
            toolTip.show(data, this);
        })
    
        .on("mouseout", function(data, index) {
            toolTip.hide(data);
        });

    //adding axis labels
        chartGroup.append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 0 - margin.left)
        .attr("x", 0 - (height / 2))
        .attr("dy", "1em")
        .text("% of Population Obese");
  
      chartGroup.append("text")
        .attr("transform", `translate(${width / 2}, ${height + margin.top})`)
        .text("Average Income");
    });
}

makeResponsive()

d3.select(window).on('resize', makeResponsive)