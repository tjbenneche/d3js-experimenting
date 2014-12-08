(function() {
  var circles, dummy, height, margin, pie, width;

  margin = {
    top: 50,
    right: 50,
    bottom: 50,
    left: 50
  };

  width = 600 - margin.left - margin.right;

  height = 600 - margin.top - margin.bottom;

  dummy = [12, 34, 23, 17, 14];

  pie = d3.select("body").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).attr("class", "piechart").append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  circles = pie.selectAll("circle").data(dummy).enter().append("circle");

  circles.attr({
    cx: function(d, i) {
      return i * 50 + 25;
    },
    cy: height / 2,
    r: function(d) {
      return d;
    }
  }).style({
    fill: "blue"
  });

  pie.selectAll("text").data(dummy).enter().append("text").text(function(d) {
    return d;
  }).attr({
    x: function(d, i) {
      return i * 50 + 25;
    },
    y: height / 2 + 3
  }).style({
    fill: "white",
    "text-anchor": "middle",
    "font-size": 12
  });

}).call(this);
