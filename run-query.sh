#!/usr/bin/env bash

cat ./photo-album-mapping.sql \
    | sqlite3 -csv -header Photos.sqlite \
    > ./photos-albums.csv
