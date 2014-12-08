margin =
  top: 50
  right: 50
  bottom: 50
  left: 50

width = 600 - margin.left - margin.right
height = 600 - margin.top - margin.bottom

dummy = [11, 32, 26, 16, 15]

i = 0
dataTotal = 0
while i < dummy.length
  dataTotal += dummy[i]
  i++

pie = d3.layout.pie()

color = d3.scale.category10()

outerRadius = width/2
innerRadius = width/3
arc = d3.svg.arc()
  .innerRadius(innerRadius)
  .outerRadius(outerRadius)

svg = d3.select('body')
  .append('svg')
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .attr('class', 'piechart')
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

d3.json "app_data.json", (error, data) ->
  moduleArray = $.map(data.app.modules, (value, index) ->
    [value]
  )
  console.log(moduleArray)
  i = 0
  percentages = []
  names = []
  while i < moduleArray.length
    percentages.push(moduleArray[i].percentage)
    names.push(moduleArray[i].module_name)
    i++
  arcs = svg.selectAll('g.arc')
    .data(pie(percentages))
    .enter()
    .append('g')
    .attr('class', 'arc')
    .attr('transform', 'translate(' + outerRadius + ',' + outerRadius + ')')

  arcs.append('path')
    .attr('fill', (d, i) ->
      color(i)
    )
    .attr('d', arc)

  arcs.append('text')
    .attr('transform', (d) ->
      'translate(' + arc.centroid(d) + ')'
    )
    .attr('text-anchor', 'middle')
    .text( (d) ->
      d.value/dataTotal * 100 + '%'
    )
    .style({
      fill: 'white'
      })
