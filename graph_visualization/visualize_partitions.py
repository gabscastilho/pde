import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

# Read the partitioned graph from output.txt
edges = []
edge_partitions = {}
partitions = set()

with open('output.txt', 'r') as f:
    for line in f:
        src, dest, partition = map(int, line.strip().split())
        edges.append((src, dest))
        edge_partitions[(src, dest)] = partition
        partitions.add(partition)

# Create a graph
G = nx.Graph()
G.add_edges_from(edges)

# Set up the plot
plt.figure(figsize=(12, 8))

# Create a layout for the graph
pos = nx.spring_layout(G, k=1, iterations=50)

# Create a color map for partitions
colors = plt.cm.Set3(np.linspace(0, 1, len(partitions)))
color_map = dict(zip(sorted(partitions), colors))

# Draw edges for each partition with different colors
for partition in partitions:
    partition_edges = [(u, v) for (u, v) in edges if edge_partitions[(u, v)] == partition]
    nx.draw_networkx_edges(G, pos, edgelist=partition_edges, 
                         edge_color=[color_map[partition]], 
                         width=2, 
                         label=f'Partition {partition}')

# Draw nodes
nx.draw_networkx_nodes(G, pos, node_color='lightgray', 
                      node_size=500, alpha=0.8)

# Add node labels
nx.draw_networkx_labels(G, pos)

# Add legend
plt.legend()
plt.title('Graph Partitioning Visualization')
plt.axis('off')

# Save the plot
plt.savefig('partition_visualization.png', bbox_inches='tight', dpi=300)
plt.close()

# Print partition statistics
print("\nPartition Statistics:")
for partition in sorted(partitions):
    edges_in_partition = sum(1 for e in edges if edge_partitions[e] == partition)
    print(f"Partition {partition}: {edges_in_partition} edges")

# Print node distribution
node_partitions = {}
for node in G.nodes():
    node_partitions[node] = set()
    for edge in G.edges(node):
        if edge in edge_partitions:
            node_partitions[node].add(edge_partitions[edge])
        else:
            node_partitions[node].add(edge_partitions[(edge[1], edge[0])])

print("\nNode Distribution:")
print("Node\tPartitions")
for node in sorted(G.nodes()):
    print(f"{node}\t{sorted(node_partitions[node])}")

print("\nReplication Factor:")
total_partitions = sum(len(parts) for parts in node_partitions.values())
replication_factor = total_partitions / len(G.nodes())
print(f"Average number of partitions per node: {replication_factor:.2f}") 