#PowerShell Script To Generate Data Files For Dashboard

#Personal Access Token
#$PAT = ""


#Region Functions
Function Write-NumericsLabelDataFile
{

#FORMAT
# POSTFIX: Label For Metric
# COLOR (Optional): RED, BLUE, GREEN, PURPLE, ORANGE, MIDNIGHT_BLUE, COFFEE, BURGUNDY, WINTERGREEN
# VALUE: The Main Text Value For The Widget


# {
#  "postfix": "Build Status",
#  "color": "green",
#  "data": {
#    "value": "Passed"
#  }
# }

}

Function Write-NumericsNumberDataFile
{

#FORMAT
# POSTFIX: Label For Metric
# COLOR (Optional): RED, BLUE, GREEN, PURPLE, ORANGE, MIDNIGHT_BLUE, COFFEE, BURGUNDY, WINTERGREEN
# VALUE: The Main Numeric Value For The Widget


# {
#  "postfix": "Build Streak",
#  "data": {
#    "value": 18
#  }
# }

}

Function Write-NumericsDayDensityChartDataFile
{

#FORMAT
# NOTES: Data Array Cannot Exceed 31 Days
# POSTFIX: Label For Metric
# COLOR (Optional): RED, BLUE, GREEN, PURPLE, ORANGE, MIDNIGHT_BLUE, COFFEE, BURGUNDY, WINTERGREEN
# DATE: The Date For The Data Point 
# VALUE: The Numeric Value For The Data Point


# {
#  "postfix": "Build Count",
#  "color": "green",
#  "data": [
#   {
#    "date": "2018-06-01",
#    "value": 14
#   },
#   {
#    "date": "2018-06-02",
#    "value": 11
#   },
#   {
#    "date": "2018-06-03",
#    "value": 18
#   },
#   {
#    "date": "2018-06-04",
#    "value": 7
#   }
#  ]
# }

}

Function Write-NumericsHourDensityChartDataFile
{

#FORMAT
# NOTES: Data Array Must Contain 24 Hours (Whole Day)
# POSTFIX: Label For Metric
# COLOR (Optional): RED, BLUE, GREEN, PURPLE, ORANGE, MIDNIGHT_BLUE, COFFEE, BURGUNDY, WINTERGREEN
# HOUR: The Date For The Data Point 
# VALUE: The Numeric Value For The Data Point


#{
# "postfix": "Builds",
# "data": [
#  {
#   "hour": 0,
#   "value": 4
#  },
#  {
#   "hour": 1,
#   "value": 4
#  },
#  {
#   "hour": 2,
#   "value": 1
#  },
#  {
#   "hour": 3,
#   "value": 6
#  },
#  {
#   "hour": 4,
#   "value": 2
#  },
#    {
#   "hour": 5,
#   "value": 4
#  },
#  {
#   "hour": 6,
#   "value": 1
#  },
#  {
#   "hour": 7,
#   "value": 6
#  },
#  {
#   "hour": 8,
#   "value": 2
#  },
#  {
#   "hour": 9,
#   "value": 4
#  },
#  {
#   "hour": 10,
#   "value": 4
#  },
#  {
#   "hour": 11,
#   "value": 1
#  },
#  {
#   "hour": 12,
#   "value": 6
#  },
#  {
#   "hour": 13,
#   "value": 2
#  },
#    {
#   "hour": 14,
#   "value": 4
#  },
#  {
#   "hour": 15,
#   "value": 1
#  },
#  {
#   "hour": 16,
#   "value": 6
#  },
#  {
#   "hour": 17,
#   "value": 2
#  },
#  {
#   "hour": 18,
#   "value": 6
#  },
#  {
#   "hour": 19,
#   "value": 2
#  },
#  {
#   "hour": 20,
#   "value": 4
#  },
#  {
#  "hour": 21,
#   "value": 1
#  },
#  {
#   "hour": 22,
#   "value": 6
#  },
#  {
#   "hour": 23,
#   "value": 2
#  }
# ]
#}

}

Function Write-NumericsLineGraphDataFile
{

#FORMAT
# POSTFIX: Label For Metric
# COLOR (Optional): RED, BLUE, GREEN, PURPLE, ORANGE, MIDNIGHT_BLUE, COFFEE, BURGUNDY, WINTERGREEN
# VALUE: The Numeric Value For The Data Point


#{
# "postfix": "Build Count",
# "color": "green",
# "data": [
#  {
#   "value": 4
#  },
#  {
#   "value": 1
#  },
#  {
#   "value": 6
#  },
#  {
#   "value": 2
#  }
# ]
#}

}

Function Write-NumericsNamedLineGraphDataFile
{

#FORMAT
# POSTFIX: Label For Metric
# COLOR (Optional): RED, BLUE, GREEN, PURPLE, ORANGE, MIDNIGHT_BLUE, COFFEE, BURGUNDY, WINTERGREEN
# NAME: The Name For The Data Point
# VALUE: The Numeric Value For The Data Point


# {
#  "postfix": "Build Count",
#  "color": "green",
#  "data": [
#   {
#    "name": "Monday",
#    "value": 44
#   },
#   {
#    "name": "Tuesday",
#    "value": 61
#   },
#   {
#    "name": "Wednesday",
#    "value": 78
#   },
#   {
#    "name": "Thursday",
#    "value": 72
#   }
#  ]
# }

}

Function Write-NumericsNumberDiffDataFile
{

#FORMAT
# NOTES: 1st Value Is Most Recent Value. 2nd Value Is Previous Value
# POSTFIX: Label For Metric
# COLOR (Optional): RED, BLUE, GREEN, PURPLE, ORANGE, MIDNIGHT_BLUE, COFFEE, BURGUNDY, WINTERGREEN
# VALUE: The Numeric Value For The Data Point


#{
# "postfix": "Builds Week Over Week",
# "color": "green",
# "data": [
#  {
#   "value": 82
#  },
#  {
#   "value": 46
#  }
# ]
#}

}

Function Write-NumericsPieChartDataFile
{

#FORMAT
# NOTES: Only Top 5 Items Will Be Shown, All Others Will Be Aggregated Into "Other" Slice. All Values Must Equal 100.
# POSTFIX: Label For Metric
# COLOR (Optional): RED, BLUE, GREEN, PURPLE, ORANGE, MIDNIGHT_BLUE, COFFEE, BURGUNDY, WINTERGREEN
# NAME: The Name For The Data Point
# VALUE: The Numeric Value For The Data Point


#{
# "postfix": "Team Builds",
# "color": "green",
# "data": [
#  {
#   "name": "Iron Man",
#   "value": 36
#  },
#  {
#   "name": "Captain America",
#   "value": 31
#  },
#  {
#   "name": "Thor",
#   "value": 13
#  },
#  {
#   "name": "Loki",
#   "value": 7
#  },
#  {
#   "name": "Black Widow",
#   "value": 5
#  },
#  {
#   "name": "Hawkeye",
#   "value": 3
#  },
#  {
#   "name": "Hulk",
#   "value": 3
#  },
#  {
#   "name": "Nick Fury",
#   "value": 2
#  }
# ]
#}

}

Function Write-NumericsFunnelListDataFile
{

#FORMAT
# NOTES: Only Top 5 Items Will Be Shown
# VALUENAMEHEADER: The Title For The Name Field
# VALUEHEADER: The Title For The Value Field
# COLOR (Optional): RED, BLUE, GREEN, PURPLE, ORANGE, MIDNIGHT_BLUE, COFFEE, BURGUNDY, WINTERGREEN
# NAME: The Name For The Data Point
# VALUE: The Numeric Value For The Data Point


#{
# "valueNameHeader": "Team Members",
# "valueHeader": "Confirmed Kills",
# "color": "green",
# "data": [
#  {
#   "name": "Iron Man",
#   "value": 36
#  },
#  {
#   "name": "Captain America",
#   "value": 31
#  },
#  {
#   "name": "Thor",
#   "value": 13
#  },
#  {
#   "name": "Loki",
#   "value": 7
#  },
#  {
#   "name": "Black Widow",
#   "value": 5
#  },
#  {
#   "name": "Hawkeye",
#   "value": 3
#  },
#  {
#   "name": "Hulk",
#   "value": 3
#  },
#  {
#   "name": "Nick Fury",
#   "value": 2
#  }
# ]
#}

}

#endregion


#Get The Data


#Write The JSON Data Files
