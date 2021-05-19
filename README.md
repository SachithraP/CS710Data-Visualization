# CS710Data-Visualization
Land Surface Temperature long term trend analysis 

Increasing trends in Land Surface Temperature (LST) is crucial to counter the climate change effects. According to the NOAA 2019 Global Climate Summary, the combined land and ocean temperature has increased at an average rate of 0.07°C (0.13°F) per decade since 1880. However, the average rate of increase since 1981 (0.18°C / 0.32°F) is more than twice as great. Remote sensing and GIS techniques are widely used to detect the changes in land surface temperature. Additionally, statistical, and mathematical modelling such as time series analysis, Fourier transform, Asymmetric Gaussian function, logistic function, wavelet transform, breaks for additive seasonal and trend, principal component analysis (PCA)/empirical orthogonal function have been proposed to quantify continuous temporal variations in LST. 

In this study, LST timeseries is decomposed into trend, seasonal and noise component to detect long-term climate change using Seasonal and Trend decomposition using Loess (STL). LST data is collected using MOD11A2 version 06, Level 3 for Abu Ali island, Saudi Arabia from 2010 to 2020.

Seasonal land surface temperatures for year 2020 are plotted using rgee package in R which binds the google earth engine platform in R. You can access the code along with step by step guidance to recreate seasonal land surface temperature plots.    
