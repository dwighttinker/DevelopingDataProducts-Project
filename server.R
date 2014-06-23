  library(RJSONIO) # acquiring and parsing data
  library(ggmap)
  library(RCurl)
  library(plyr)  # manipulating data
  library(lubridate) #dates
  
shinyServer(function(input, output, session) {

    # get the geocode for the address
    gGeoCode <- function(address,verbose=FALSE) {
        address.list<-c(input$address)
    } ##

    output$mychart <- renderLineChart({
        geoCodes <- geocode(input$address, output = c("latlona"))
        # http://api.mygasfeed.com/stations/radius/37.4954481/-88.41857039999999/45/mid/price/chmodpl9lb.json

        # obtain and process daily count data by month by target
        getStation <- function(type){
            url <- paste("http://api.mygasfeed.com/stations/radius/", geoCodes[1,2], "/", geoCodes[1,1], "/45/", type, "/price/bvcyecd3ld.json", sep="") #,yr,mth,"/",target)
            raw.data <- readLines(url, warn="F") 
            rd  <- fromJSON(raw.data)
            rd.geoLocation <- rd$geoLocation
            rd.stations <- rd$stations

            rd.stations[grep("N/A", rd.stations$price, ignore.case=TRUE), "price"] <- NA

            # Return a data frame. Each column will be a series in the line chart.
            df <- data.frame(
                rd.stations[,c("price", "date", "city", "address", "station", "distance", "id")]
            )
            
            if(input$rank == TRUE) df <- df[order(df$distance), ]
            #df <- df[complete.cases(df[,1]),]
            colnames(df[1]) <- c("Regular")
            df
        }
        reg <- getStation("reg")
        mid <- getStation("mid")
        pre <- getStation("pre")
        diesel <- getStation("diesel")

        df <- cbind(reg$price, mid$price, pre$price, diesel$price, by=c("id"))
        
        df <- data.frame(df[,1:4])
        rename(df, c("V1" = "Regular", "V2" = "Midgrade", "V3" = "Premium", "V4" ="Diesel"))
    })


  output$text1 <- renderText({ 
      geoCodes <- geocode(input$address, output = c("latlona"))

      paste("Location: ", geoCodes$address)
    })
  

})
