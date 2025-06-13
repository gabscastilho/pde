"""
Read a .txt file and returns a .csv graph for neo4j
"""

import csv
import sys

def write_neo4j_csv(graph):
    # Write relationships.csv
    with open('relationships.csv', 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['source', 'target', 'partition'])
        for source, target, partition in graph:
            writer.writerow([source, target, 'CONNECTED_TO'])

    
def main():
    input_path = sys.argv[1]
    output_path = 'output.csv'
    if sys.argv == 3:
        output_path = sys.argv[2]

    with open(input_path, 'r') as input_file:
        with open(output_path, 'w') as output_file:
            writer = csv.writer(output_file)
            writer.writerow(['source', 'target', 'partition'])
            for line in input_file.readlines():
                source, target, partition = line.strip().split('\t')
                writer.writerow([source, target, partition])
    
if __name__ == '__main__':
    main()