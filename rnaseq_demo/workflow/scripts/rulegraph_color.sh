
# AUTHOR: Jonathan Nowacki
# INPUT: NONE
# OUTPUT: flowgram of snakemake workflow .PNG
# DESCRIPTION: Produces a color coded rule graph to see how the workflow operates.
snakemake --rulegraph | \
# Convert all colors to black
perl -pe "s/color = \".*\",/color = \"red\"/" | \
# Convert lines with "search_term_1" to blue
sed /search_term_1/s/red/blue/ | \
# Convert lines with "search_term_2" to black
sed /search_term_2/s/red/black/ | \
# Convert lines with "search_term_3" to green
sed /search_term_3/s/red/green/ | \
dot -T png > rulegraph_colored.png
