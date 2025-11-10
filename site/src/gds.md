# Graph Data Science (GDS)

Neo4j Graph Data Science library provides powerful graph algorithms and machine learning capabilities.

## Available Algorithms

### Centrality

- PageRank
- Betweenness Centrality
- Closeness Centrality
- Article Rank

### Community Detection

- Louvain
- Label Propagation
- Weakly Connected Components

### Similarity

- Node Similarity
- Jaccard Similarity

### Path Finding

- Shortest Path
- All Shortest Paths
- A* Shortest Path

## Example Usage

```cypher
// Create a graph projection
CALL gds.graph.project(
  'myGraph',
  'Node',
  'RELATES_TO'
);

// Run PageRank
CALL gds.pageRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY score DESC;
```

