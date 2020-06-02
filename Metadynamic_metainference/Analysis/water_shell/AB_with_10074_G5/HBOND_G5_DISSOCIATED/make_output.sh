#this file organises output from analysis
cat dis | while read line; do tail -n 1 hbond_$line.out >> hbond_output_drug.out; done
