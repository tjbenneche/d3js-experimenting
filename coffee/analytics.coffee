#On load
# 1.Create svg pie chart with individual module data
# 2.Create three divs with overall app data
# 3.Create area chart with overall app data
# All data on load defaults to one-day



# 1. Create svg pie chart

margin =
  top: 50
  right: 50
  bottom: 50
  left: 50
pie_width = 400 - margin.left - margin.right
pie_height = 400 - margin.top - margin.bottom
pie = d3.layout.pie()
#ultimately create our own color scheme, use d3 default for now
color = d3.scale.category10()
#outer radius for module data, inner for overall app name
pie_outerRadius = pie_width/2
pie_innerRadius = 0
pie_arc = d3.svg.arc()
  .innerRadius(pie_innerRadius)
  .outerRadius(pie_outerRadius)
#add svg to the document for pie to fill
pie_svg = d3.select('body')
  .append('svg')
  .attr("width", pie_width + margin.left + margin.right)
  .attr("height", pie_height + margin.top + margin.bottom)
  .attr('class', 'piechart')
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")


# 2. Create svg area chart

chart_width = 800 - margin.left - margin.right
chart_height = 500 - margin.top - margin.bottom
x = d3.scale.ordinal()
  .rangePoints([0, chart_width])
y = d3.scale.linear()
  .range([chart_height, 0])
xAxis = d3.svg.axis()
  .scale(x)
  .orient("bottom")

updateAxes = () ->
  chart_svg.selectAll('.axis')
    .remove()
  chart_svg.append('g')
    .attr('class', 'x axis')
    .attr("transform", "translate(0," + chart_height + ")")
    .call(xAxis);
  chart_svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Sessions");

yAxis = d3.svg.axis()
  .scale(y)
  .orient("left")

area = d3.svg.area().x((d) ->
  x d.time
).y0(chart_height).y1((d) ->
  y d.value
)

# parseTime = d3.time.format("%I %p").parse

chart_svg = d3.select('body')
  .append('svg')
  .attr("width", chart_width + margin.left + margin.right)
  .attr("height", chart_height + margin.top + margin.bottom)
  .attr('class', 'areachart')
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

populateData = (url) ->
  #Load json file with today's data
  d3.json url, (error, data) ->

    objectName = Object.keys(data)[0]

    moduleArray = data[objectName].session_count_percentages
    i = 0
    percentages = []
    names = []
    while i < moduleArray.length
      percentages.push(moduleArray[i][1])
      names.push(moduleArray[i].module_name)
      i++
    arcs = pie_svg.selectAll('g.arc')
      .data(pie(percentages))
      .enter()
      .append('g')
      .attr('class', 'arc')
      .attr('transform', 'translate(' + pie_outerRadius + ',' + pie_outerRadius + ')')

    arcs.append('path')
      .attr('fill', (d, i) ->
        color(i)
      )
      .attr('d', pie_arc)

    arcs.append('text')
      .attr('transform', (d) ->
        'translate(' + pie_arc.centroid(d) + ')'
      )
      .attr('text-anchor', 'middle')
      .text( (d) ->
        d.value + '%'
      )
      .style({
        fill: 'white'
        })


    # Generate three boxes for session count, avg length, and retention

    overall_session_data = [data[objectName].session_count, data[objectName].average_session_length, data[objectName].retention_rate]

    # need to figure out how to conditionally add units
    session_boxes = d3.select('.session-data-section')
      .selectAll('.session-box')
      .data(overall_session_data)
      .text( (d) ->
        d
      )

    # Generate area chart for overall app data
    overall_app_chart_data = data[objectName].session_count_graph_data

    overall_app_chart_data.forEach( (d) ->
      d.time = d[0]
      d.value = d[1]
    )

    x.domain(overall_app_chart_data.map( (d) ->
        d.time
    ))

    y.domain([0, d3.max(overall_app_chart_data, (d) ->
        d.value
    )])


    unless $('.area').length > 0
      chart_svg.append('path')
        .attr('class', 'area')

    chart_svg.select('.area')
      .datum(overall_app_chart_data)
      .attr('class', 'area ' + objectName)
      .transition()
        .duration(1000)
        .attr('d', area)

    updateAxes()

$ ->
  populateData("http://localhost:3000/api/v1/apps/2mNFJaz4/analytics/24hour")


$(document).on 'click', '#weekly', (e) ->
  populateData("http://localhost:3000/api/v1/apps/2mNFJaz4/analytics/7day")

$(document).on 'click', '#daily', (e) ->
  populateData("http://localhost:3000/api/v1/apps/2mNFJaz4/analytics/24hour")

$(document).on 'click', '#monthly', (e) ->
  populateData("http://localhost:3000/api/v1/apps/2mNFJaz4/analytics/30day")
