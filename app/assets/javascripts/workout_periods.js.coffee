window.summary = (graphData) ->
  google.load 'visualization', '1.0', packages: ['corechart'], callback: ->
    new WorkoutPeriod(graphData) 

class WorkoutPeriod
  constructor: (graphData) ->
    this.drawChart graphData

  drawChart: (graphData) ->
    data = new google.visualization.arrayToDataTable(graphData)

    options =
      'title': 'Exercises',
      'height': 400

    chart = new google.visualization.LineChart($('#chart_div')[0]);
    chart.draw data, options
