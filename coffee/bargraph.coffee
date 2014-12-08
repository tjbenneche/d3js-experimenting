#create padding around the graph itself
#because of svg's origin being top left (0,0), margins are used this way
margin =
  top: 20
  right: 20
  bottom: 30
  left: 40

width = 660 - margin.left - margin.right
height = 500 - margin.top - margin.bottom

#ordinal scale used because data is not qualitative
#rangeRoundBands computes padding between bars and reevaluates width
x = d3.scale.ordinal().rangeRoundBands([0,width], .1)

#linear scale used for qualitative data (y axis)
y = d3.scale.linear().range([height, 0]);

#create x axis, bind to x scale, orient it on the bottom of the chart
xAxis = d3.svg.axis().scale(x).orient("bottom")
#create y axis, bind to y scale, orient it on the left, and use ticks to communicate data
yAxis = d3.svg.axis().scale(y).orient("left").ticks(10, "%")



svg = d3.select("body")
  .append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")


d3.tsv "data.tsv", type, (error, data) ->
  x.domain data.map((d) ->
    d.letter
  )
  y.domain [
    0
    d3.max(data, (d) ->
      d.frequency
    )
  ]
  svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
  svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "Frequency"
  svg.selectAll(".bar").data(data).enter().append("rect").attr("class", "bar").attr("x", (d) ->
    x d.letter
  ).attr("width", x.rangeBand()).attr("y", (d) ->
    y d.frequency
  ).attr "height", (d) ->
    height - y(d.frequency)

  return

type = (d) ->
  d.frequency = +d.frequency
  d
