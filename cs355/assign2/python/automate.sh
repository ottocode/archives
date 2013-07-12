#!/bin/bash

mean=10

while [ $mean -lt 201 ]; do
    #echo Value of mean is: $mean
    python qSim.py $mean
    let mean=mean+5
done
