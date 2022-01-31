-- Collect all albums with a title, collect all photos mapping
-- onto those albums, and list their UUIDs, titles, and original
-- filenames (prior to Photos's filename conversion).

with
albums as (
    select z_pk album_id
         , ztitle album_title
         , zparentfolder parent_album_id
         , zcachedcount album_items_count
      from zgenericalbum
     where album_title is not null
),
links as (
    select z_27albums album_id
         , z_3assets photo_id
      from z_27assets a
     where album_id in (select album_id from albums)
),
photos as (
    select z_pk photo_id
         , zadditionalattributes attr_id
         , zuuid photo_uuid
      from zasset
     where z_pk in (select photo_id from links)
),
attrs as (
    select z_pk attr_id
         , ztitle photo_title
         , zoriginalfilename photo_filename
      from zadditionalassetattributes
     where attr_id in (select attr_id from photos)
)
select a.album_id
     , a.album_title
     , b.album_id parent_album_id
     , b.album_title parent_album_title
     , p.photo_id
     , p.photo_uuid
     , t.photo_filename
     , t.photo_title
  from albums a
       left join albums b
       on b.album_id = a.parent_album_id
       left join links l
       on l.album_id = a.album_id
       left join photos p
       on p.photo_id = l.photo_id
       left join attrs t
       on t.attr_id = p.attr_id
 where a.album_items_count > 0
 order by parent_album_id, a.album_id, t.photo_filename;
