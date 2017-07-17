# Downloads MODIS active fire data; see:
# https://earthdata.nasa.gov/earth-observation-data/near-real-time/firms/active-fire-data
has_wget=$(which wget)

declare -a files=( "MODIS_C6_Alaska_24h.csv" "MODIS_C6_Australia_and_New_Zealand_24h.csv" "MODIS_C6_Canada_24h.csv" "MODIS_C6_Central_America_24h.csv" "MODIS_C6_Europe_24h.csv" "MODIS_C6_Northern_and_Central_Africa_24h.csv" "MODIS_C6_Russia_and_Asia_24h.csv" "MODIS_C6_South_America_24h.csv" "MODIS_C6_South_Asia_24h.csv" "MODIS_C6_SouthEast_Asia_24h.csv" "MODIS_C6_Southern_Africa_24h.csv" "MODIS_C6_USA_contiguous_and_Hawaii_24h.csv" )

for file in "${files[@]}"
do
  # Strip the leading "MODIS_*" and the file extension
  basename=$(echo ${file:9:100} | cut -d '.' -f 1)
  if [ $has_wget != '' ];
    then wget -O "${basename%_*}.csv" "https://firms.modaps.eosdis.nasa.gov/active_fire/c6/text/${file}"
    else curl -o "${basename%_*}.csv" "https://firms.modaps.eosdis.nasa.gov/active_fire/c6/text/${file}"
  fi
done
