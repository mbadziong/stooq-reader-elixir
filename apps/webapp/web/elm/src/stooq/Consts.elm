module Stooq.Consts exposing (..)


indexes : List String
indexes =
    [ "WIG", "WIG20", "WIG20FUT", "MWIG40", "SWIG80" ]


columnNames : List String
columnNames =
    "Date" :: indexes


dateFormat : String
dateFormat =
    "EEEE, MMMM d, y 'at' h:mm a"
