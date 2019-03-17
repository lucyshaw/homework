function buildMetadata(sample) {
  //define the link to the metadata in flast app
  var metaData = '/metadata/' + sample
  
//select the metadata id from the index.html
  metaDataPanel = d3.select('#sample-metadata')
  metaDataPanel.html('')

  //append the metadata to the metadata panel
  d3.json(metaData).then(function(data) {
     Object.entries(data).forEach(([key, value]) => {
       metaDataPanel.append('h6').text(`${key}: ${value}`)
     }
     )
  })
  
}

function buildCharts(sample) {
  var sampleData = '/samples/' + sample

  d3.json(sampleData).then(function(data) {
  //build a bubble plot of the belly button bacteria
  var trace1 = {
    x: data.otu_ids,
    y: data.sample_values,
    mode: 'markers',
    text: data.otu_lables,
    marker: {
      color: data.otu_ids,
      size: data.sample_values,
      colorscale: 'Viridis'
    }
  }
  var trace2 = [trace1]
  var layout = {
    showlegend: false,
    height: 600,
    width: 1500,
  }
  Plotly.newPlot('bubble', trace2, layout)
//build a pichart of the belly button bacteria
  var data = [{
    type: 'pie',
    values: data.sample_values.slice(0, 10),
    labels: data.otu_ids.slice(0, 10),
    hovertext: data.otu_labels.slice(0, 10),
    
    }]
  var layout = {
    showlegend: true,
  }
  Plotly.newPlot('pie', data, layout)
  })
  }

  // @TODO: Use `d3.json` to fetch the sample data for the plots

    // @TODO: Build a Bubble Chart using the sample data

    // @TODO: Build a Pie Chart
    // HINT: You will need to use slice() to grab the top 10 sample_values,
    // otu_ids, and labels (10 each).


function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
