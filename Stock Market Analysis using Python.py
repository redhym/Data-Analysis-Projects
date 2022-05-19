#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import seaborn as sns
sns.set_style('whitegrid')
plt.style.use("fivethirtyeight")
get_ipython().run_line_magic('matplotlib', 'inline')

# For reading stock data from yahoo
from pandas_datareader.data import DataReader
import yfinance as yf

# For time stamps
from datetime import datetime


# In[2]:


pip install pandas_datareader


# In[2]:


pip install yfinance


# In[21]:


# Lets import yfinance as yf and create a ticker object for a Tesla stock.

import yfinance as yf

TSLA= yf.Ticker("TSLA")


TSLA


# In[3]:


# Lets pull daily stock prices for Tesla(TSLA)

data = yf.download("TSLA", start="2019-01-01", end="2022-04-30", interval="1d")

data


# In[10]:


# Let's get price to earnings ratio

TSLA = yf.Ticker("TSLA")
TSLA.info['forwardPE']


# In[5]:


# Current volume

TSLA.info["volume"]


# In[6]:


# Average volume over the last 24 hours:

TSLA.info["averageVolume"]


# In[11]:


# Let's get the weekly highs and lows for Tesla

data = yf.download("TSLA", period="max", interval="1wk")

data


# In[12]:


# Lets plot an OHLC chart (Open, High, Low, Close prices) for Tesla stock.


import plotly.graph_objects as go

fig = go.Figure(
    data=go.Ohlc(
        x=data.index,
        open=data["Open"],
        high=data["High"],
        low=data["Low"],
        close=data["Close"],
     )
)

fig.update_layout(
     xaxis_title="OHLC chart with Tesla Stock prices"

)  


fig.show()


# In[1]:


pip install --upgrade ta


# In[5]:


#Let’s check out the moving average for stocks over a 10, 20 and 50 day period of time. We’ll add that information to the stock’s dataframe.


ma_day = [10,20,50]

for ma in ma_day:
    column_name = "MA for %s days" %(str(ma))
    data[column_name] = data['Adj Close'].rolling(window=ma,center=False).mean()

data.tail()


# In[8]:


#Let’s plot the same, again using only last year i.e. 2021 data.


data.truncate(before='2021-01-01', after='2022-01-01')[['Adj Close','MA for 10 days','MA for 20 days','MA for 50 days']].plot(subplots=False,figsize=(12,5))


# In[14]:


# Plotting the stock's adjusted closing price using pandas


data.truncate(before='2021-01-01', after='2022-01-01')['Adj Close'].plot(legend=True,figsize=(12,5))


# In[16]:


# Plotting the total volume being traded over time

data.truncate(before='2021-01-01', after='2022-01-01')['Volume'].plot(legend=True,figsize=(12,5))


# In[ ]:





# In[ ]:




