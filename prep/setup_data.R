# this comes directly from Carpentries and gets the data
# files necessary for the lesson.
# it would be helpful to get curl in here like the 
# Ratlas (the images tend to time out)

# the NaturalEarth files fail just like they do for Ratlas.


## file structure

if (! file.exists("data/NEON-DS-Site-Layout-Files")) {
  dest <- tempfile()
  download.file("https://ndownloader.figshare.com/files/3708751", dest,
                mode = "wb")
  unzip(dest, exdir = "data")
}

if (! file.exists("data/NEON-DS-Airborne-Remote-Sensing")) {
  dest <- tempfile()
  download.file("https://ndownloader.figshare.com/files/3701578", dest,
                mode = "wb")
  unzip(dest, exdir = "data")
}

if (! file.exists("data/NEON-DS-Met-Time-Series")) {
  dest <- tempfile()
  download.file("https://ndownloader.figshare.com/files/3701572", dest,
                mode = "wb")
  unzip(dest, exdir = "data")
}

if (! file.exists("data/NEON-DS-Landsat-NDVI")) {
  dest <- tempfile()
  download.file("https://ndownloader.figshare.com/files/4933582", dest,
                mode = "wb")
  unzip(dest, exdir = "data")
}

if (! file.exists("data/Global/Boundaries/ne_110m_graticules_all")) {
  dest <- tempfile()
  download.file("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_graticules_all.zip",
                dest, mode = "wb")
  unzip(dest, exdir = "data/Global/Boundaries/ne_110m_graticules_all")
}

if (! file.exists("data/Global/Boundaries/ne_110m_land")) {
  dest <- tempfile()
  download.file("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_land.zip",
                dest, mode = "wb")
  unzip(dest, exdir = "data/Global/Boundaries/ne_110m_land")
}
