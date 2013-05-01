    d3.json("/graphs/d3data.json", function(error, json) {
      if (error) return console.warn(error);

      var opacity = 0.1;

      nodes = json.nodes;
      links = json.links;

      var mouseOverFunction = function(d) {
    
        infobox
          .style("display", "block")
          .select("p")
          .text("Number of followers: " + d.size + ", Twitter ID: " + d.id + ", Name: " + d.name)
          .style("opacity", 0)
          .transition()
            .style("opacity", 1)
          .duration(500);

        node
          .transition(500)
            .style("opacity", function(o) {
              return isConnected(o, d) ? 1 : opacity;
            })
          .style("fill", function(o) {
            if (isConnectedAsTarget(o, d) && isConnectedAsSource(o, d) ) {
              fillcolor = 'green';
            } else if (isConnectedAsSource(o, d)) {
              fillcolor = 'red';
            } else if (isConnectedAsTarget(o, d)) {
              fillcolor = 'blue';
            } else if (isEqual(o, d)) {
              fillcolor = "hotpink";
            } else {
              fillcolor = "black";
            }
            return fillcolor;
          });

        link
          .transition()
            .style("stroke-opacity", function(o) {
              return o.source === d || o.target === d ? 1 : opacity;
            })
          .style("stroke-width",2.0)
          // .attr("marker-end", function(o) {
          //     return o.source === d || o.target === d ? "url(#arrowhead)" : "url()";
          // })
          .duration(500);

        var circle = d3.select(this);

        circle
          .transition()
            .attr("r", function(){ return 1.2 * node_radius(d)})
          .duration(500);
      }

      var mouseOutFunction = function() {
        var circle = d3.select(this);
        
        infobox
          .style("display", "none"); 

        // node
        //   .transition().style("opacity", 1).duration(500);

        link
          .transition()
            // .attr("marker-end","url()")
            // .style("stroke-opacity", 1)
            // .style("stroke-width",0.8)
          // .duration(500);

        circle
          .transition()
            .attr("r", node_radius)
          .duration(500);
      }

      var mouseMoveFunction = function() {
        var coord = d3.mouse(this)
        infobox
          .style("left", coord[0] + 105  + "px" )
          .style("top", coord[1] + 30 + "px");
      }

      function zoom() {
          svg.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
      }

      function tick() {
        link
          .attr("x1", function(d) { return d.source.x; })
          .attr("y1", function(d) { return d.source.y; })
          .attr("x2", function(d) { return d.target.x; })
          .attr("y2", function(d) { return d.target.y; });

        node
          .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
      }

      function node_radius(d) {
        return Math.pow(30.0 * d.weight, 1/3);
      }

      function isConnected(a, b) {
          return isConnectedAsTarget(a, b) || isConnectedAsSource(a, b) || isEqual(a,b);
      }

      function isConnectedAsSource(a, b) {
          return linkedByIndex[a.index + "," + b.index];
      }

      function isConnectedAsTarget(a, b) {
          return linkedByIndex[b.index + "," + a.index];
      }

      function isEqual(a, b) {
          return a.index == b.index;
      }


      var w = 1000; 
      var h = 500;

      force = d3.layout.force()
        .nodes(nodes)
        .links(links)
        .charge(-1500)
        .friction(0.6)
        .gravity(0.9)
        .size([w,h])
        .start();

      // Place this after the d3.layout.force()
      var linkedByIndex = {};
      links.forEach(function(d) {
          linkedByIndex[d.source.index + "," + d.target.index] = 1;
      });

      force.on("tick",tick);

      var svg = d3.select('#graphcontainer').append('svg')
                  .attr('width', w)
                  .attr('height', h)
                .on('mousemove', mouseMoveFunction)
                .append("g")
                .call(d3.behavior.zoom().scaleExtent([0.5, 8]).on("zoom", zoom))
                .append('g');

      var link = svg.selectAll("line")
                    .data(links)
                  .enter().append("line");

      var node = svg.selectAll(".node")
                    .data(nodes)
                  .enter().append("g")
                    .attr("class","node")
                    .call(force.drag);

      var fill = d3.scale.category20();

      svg
        .append("marker")
        .attr("id", "arrowhead")
        .attr("refX", 6 + 3) // Controls the shift of the arrow head along the path
        .attr("refY", 2)
        .attr("markerWidth", 6)
        .attr("markerHeight", 4)
        .attr("orient", "auto")
        .append("path")
          .attr("d", "M 0,0 V 4 L6,2 Z");

      node
        .append("circle")
        .attr("r", node_radius)
        .attr("stroke","white")
        .attr("stroke-width",2.0)
        .on("mouseover", mouseOverFunction)
        .on("mouseout", mouseOutFunction);

      link
        .attr("class","link")
        .style("stroke-width",1);

      link
        .attr("marker-end", "url()");

      var infobox = d3.select('.infobox');

  });