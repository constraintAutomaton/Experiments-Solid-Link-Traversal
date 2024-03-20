import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
import os

plotFolder = Path('./plots')

def generate(path, query):
    df = pd.read_csv(path,sep=";")
    df.loc[df['error'] == True, ['time','results', 'httpRequests']] = float('nan')
    df.sort_values(by=['name'], axis=0, inplace=True)
    # set the index to be this and don't drop
    df.set_index(keys=['name'], drop=False,inplace=True)
    # get a list of names
    names=df['name'].unique().tolist()
    
    # now we can perform a lookup on a 'view' of the dataframe
    df_query = df.loc[df.name==query]
    return df_query

# https://matplotlib.org/stable/gallery/lines_bars_and_markers/barchart.html
def plotComparif(data, col, queries, path):
    index = np.arange(5)
    
    bar_width = 0.21
    fig, ax = plt.subplots(layout='constrained')
    i = 0
    
    for key, datasets in data.items():        
        offset = bar_width * i
        df = datasets[queries]
        y = df[col].to_numpy()
        rects = ax.bar(index+ offset, y, bar_width, label=key)        
        i+=1

    
    ax.set_xlabel('id')
    ax.set_ylabel(col)
    ax.set_xticks(index + bar_width, index)
    ax.set_ylim(bottom=0)
    ax.legend()
    
    plt.savefig(path, format="svg")
    plt.close()


def generateQueryPlots(paths, queryNameTemplate, folder, nQueryVariance):
    dataFrame = {}
    querySet = []
    for key,path in paths.items():
        dataFrame[key] = {}
        for i in range(nQueryVariance): 
            queries = queryNameTemplate.format(i+1)
            querySet.append(queries)
            dataFrame[key][queries] = generate(path, queries)

    fields = ['time', 'results', 'httpRequests']

    for queries in querySet:
        for field in fields:
            filename = "{}-{}.svg".format(queries, field)
            path = os.path.join(plotFolder,folder, filename)
            plotComparif(dataFrame, field,queries,  path)

pathsQueryShort = {
    'ldp-filtered-type-index': "/home/id357/Downloads/experiments/queries-short/output/combination_0/query-times.csv",
    'ldp-shape-index-type-index':"/home/id357/Downloads/experiments/queries-short/output/combination_1/query-times.csv",
    "ldp-shape-index":"/home/id357/Downloads/experiments/queries-short/output/combination_2/query-times.csv",
    "shape-index":"/home/id357/Downloads/experiments/queries-short/output/combination_3/query-times.csv"
}
queryNameTemplateQueryShort = "interactive-short-{}"
folderQueryShort = "query-short"
nQueryVarianceQueryShort = 7

pathsQueryDiscovery = {
    'ldp-filtered-type-index': "./result_queries_discover/combination_0/query-times.csv",
    'ldp-shape-index-type-index':"./result_queries_discover/combination_1/query-times.csv",
    "ldp-shape-index":"./result_queries_discover/combination_2/query-times.csv",
    "shape-index":"./result_queries_discover/combination_3/query-times.csv"
}
queryNameTemplateQueryDiscovery = "interactive-discover-{}"
folderQueryDiscovery = "query-discovery"
nQueryVarianceQueryDiscovery = 8

generateQueryPlots(pathsQueryDiscovery, queryNameTemplateQueryDiscovery, folderQueryDiscovery, nQueryVarianceQueryDiscovery)
generateQueryPlots(pathsQueryShort, queryNameTemplateQueryShort, folderQueryShort, nQueryVarianceQueryShort)
