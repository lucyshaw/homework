// from data.js
var tableData = data;

//reference tbody 
var tbody = d3.select('tbody')

// loop through the data and put it into a table on the website
tableData.forEach((ufoSighting) => {
    var row = tbody.append('tr')
    Object.entries(ufoSighting).forEach(([key, value]) => {
        var cell = tbody.append('td')
        cell.text(value)
    })
})


var filter = d3.select("#filter-btn")

//create a button click listener to filter the table by the input date
filter.on('click', function() {

    //remove rows that do not meet filter criteria
    tbody.selectAll('*').remove()
    
    d3.event.preventDefault()

    var inputDate = d3.select('#datetime')

    var inputValue = inputDate.property('value')

    var filterTable = tableData.filter(ufoSighting => ufoSighting.datetime === inputValue)

    filterTable.forEach((ufoSighting) => {
        var row = tbody.append('tr')
        Object.entries(ufoSighting).forEach(([key, value]) => {
            var cell = tbody.append('td')
            cell.text(value)
        })
    })
})






