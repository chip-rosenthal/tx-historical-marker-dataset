This project contains a dataset of Texas Historical Markers, enriched
with latitude/longitude information.

The original dataset was provided by the Texas State Historical Commission
at ATX Hack for Change 2015.

* Historical_Marker_20150521_145030_254.csv - Source dataset (run through dos2unix).
* Historical_Marker_20150521_145030_254_latlng.csv - Dataset enriched with latitude/longitude information.
* historical_marker_add_latlng.rb - Ruby script that performs the enrichment.
* Historical_Marker_20150521_145030_254_latlng.geojson - Dataset with missing location rows removed and then converted to GeoJSON by http://www.convertcsv.com/csv-to-geojson.htm

Chip Rosenthal
<chip@unicom.com>
