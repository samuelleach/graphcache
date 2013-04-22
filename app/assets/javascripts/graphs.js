    d3.json("/graphs/d3data.json", function(error, json) {
      if (error) return console.warn(error);

      nodes = json.nodes;
      links = json.links;

      var myMouseOverFunction = function(d) {
        var circle = d3.select(this);
        //circle.attr("fill", "red");

        d3.select(".infobox").style("display", "block");  
        d3.select("p").text("Number of followers: " + d.size +
                            ", Twitter ID: "+ d.id + 
                            ", Screen Name: "+d.name);

        d3.select("p").style("opacity", 0)
                      .transition()
                      .style("opacity", 1).duration(500);
      }

      var myMouseOutFunction = function() {
        var circle = d3.select(this);
       // circle.attr("fill", "steelblue" );
        
        d3.select(".infobox").style("display", "none"); 
      }

      var myMouseMoveFunction = function() {
        var infobox = d3.select(".infobox");
        var coord = d3.mouse(this)
        infobox.style("left", coord[0] + 105  + "px" );
        infobox.style("top", coord[1] + 30 + "px");
      }

      var w = 800; 
      var h = 400;

      vis = d3.select("#graphcontainer").append("svg")
        .attr("width", w)
        .attr("height", h)
        .on('mousemove', myMouseMoveFunction),
      
      force = d3.layout.force()
        .nodes(nodes)
        .links(links)
        .charge(-1500)
        .friction(0.8)
        .gravity(0.9)
        .size([w,h])
        .start(),
              
      link = vis.selectAll("line")
        .data(links)
        .enter()
          .append("line")
          .attr("class","link"),
          
      node = vis.selectAll(".node")
        .data(nodes)
        .enter()
          .append("g")
          .attr("class","node")
          .call(force.drag);

      fill = d3.scale.category20(),

      node.append("circle")
        .attr("r", function(d) {
          return Math.pow(40*d.size,1/3);
          })
        .attr("fill",function(d) {
          return fill(d.size);
          })
        .attr("stroke","black")
        .attr("stroke-width",2)
        .on("mouseover", myMouseOverFunction)
        .on("mouseout", myMouseOutFunction),
  
        // node.append("text")
        //   .attr("dx",function(d) {
        //     return Math.pow(40*d.size,1/3)+1;
        //     })
        //   .attr("dy",".35em")
        //   .text(function(d) {return d.atom;});
        
      force.on("tick", function() {
        link.attr("x1", function(d) { return d.source.x; })
          .attr("y1", function(d) { return d.source.y; })
          .attr("x2", function(d) { return d.target.x; })
          .attr("y2", function(d) { return d.target.y; });
          
      node.attr("transform", function(d) { 
          return "translate(" + d.x + "," + d.y + ")"; 
          });   
      });
  });