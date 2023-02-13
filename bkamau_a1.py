#Importing pandas
import pandas as pd

##creating a the data columns as lists
id=[0,1,2,3,4,4,5,6,7,8]

age=[21,22,23,24,25,25,26,27,"28",29]
##A list comprehension to convert "28" from a string to an interger
age=[int(i) for i in age]

height=[180,170, float("Nan"), 175,190,190,195,200,205,210]

weight=[70,65,"80",75,90,90,95,100,105,110]
##A list comprehension to convert "80" from a string to an interger
weight=[int(i) for i in weight]

##creating a dictionary
df={"id":id,"age":age,"height":height,"weight":weight}

##creating a dataframe
df=pd.DataFrame(df)

##checking for missing values
df.isna().sum()

##dropping missing values
df.dropna(inplace=True)

## a function that returns the mean, median and standard deviation of weight column
def summary_statistics(data, column):
    #calculation the mean
        mean_weight=sum(column)/len(column)
    #calculating the median
        median_weight=sorted(column)
        n=len(median_weight)
        if n%2 == 0:
            median = (median_weight[n // 2 - 1] + median_weight[n // 2]) / 2
        else:
             median = median_weight[n // 2]
     # Calculating the standard deviation
        variance = sum((i - mean_weight) ** 2 for i in column) / len(column)
        std_dev = variance ** 0.5
        return(mean_weight,median,std_dev)
    
summary_statistics(df,df["weight"])