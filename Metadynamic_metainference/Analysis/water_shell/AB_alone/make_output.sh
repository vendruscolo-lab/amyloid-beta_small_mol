#this file organises output from analysis
n=252815 #number of frames - 1
for i in `seq 0 ${n}`
do
    cat hbond_${i}.out >> hbond_output.out
done
