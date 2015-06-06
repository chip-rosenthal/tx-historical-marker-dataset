require 'csv'

class NilClass
  def empty?
    true
  end
end


#
# Convert a lat/lng string produced by cs2cs to a decimal value.
#
# "97d34'40.401\"W" => 33.23424333333333
# "33d14'3.276\"N" => -97.57788916666667
#
def parse_degrees(s)
  a = s.match(/^([0-9]+)d(([0-9]+)')?(([.0-9]+)")?([NSEW])$/)

  # Examples:
  #  <MatchData "97d34'40.401\"W" 1:"97" 2:"34'" 3:"34" 4:"40.401\"" 5:"40.401" 6:"W">
  #  <MatchData "90dN" 1:"90" 2:nil 3:nil 4:nil 5:nil 6:"N">

  secs = (a[5].to_f || 0.0)
  mins = (a[3].to_i || 0) + (secs/60)
  deg = a[1].to_i + (mins/60)

  return (a[6] == "S" || a[6] == "W") ? -deg : deg
end


#
# Convert a UTM coordinate to lat/lng.
#
# Geospatial reference info at: http://spatialreference.org/
#
# UTM zones in use by this dataset: 13, 14, 15
#
# To use "cs2cs" on Fedora, I needed to:
#
#   yum intall proj proj-epsg
#
#
def convert_utm_to_degrees(utm_zone, utm_east, utm_north)

  if utm_zone.empty? || utm_east.empty? || utm_north.empty?
    return {"lat" => nil, "lng" => nil}
  end

  proj_from="epsg:326#{utm_zone}"
  proj_to="epsg:4326"
  cnv_cmd = "cs2cs +init=#{proj_from} +to +init=#{proj_to}"

  #
  # echo "632501 3678157" | cs2cs +init=epsg:32614 +to +init=epsg:4326
  # 97d34'40.401"W	33d14'3.276"N 0.000
  #
  out = `echo "#{utm_east} #{utm_north} "| #{cnv_cmd}`
  lng, lat = out.split
  {"lat" => parse_degrees(lat), "lng" => parse_degrees(lng)}

end

did_header = false
CSV.filter($stdin, $stdout, :headers => true, :write_headers => true) do |row|

  row << convert_utm_to_degrees(row["utm_zone"], row["utm_east"], row["utm_north"])

  if ! did_header
    $stdout.puts row.headers.to_csv
    did_header = true
  end

end

