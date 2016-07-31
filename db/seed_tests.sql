-- Checks join table between tags and attractions
SELECT
  t.tag,
  a.title
FROM tags t, attractions a, attraction_tags at
WHERE t.id = at.tag_id
  AND a.id = at.attraction_id
LIMIT 10;

-- Checks attractions table
SELECT
  a.eventful_id,
  a.city_name,
  a.country_name,
  a.title,
  a.owner,
  a.db_start_time,
  a.db_stop_time,
  a.event_date,
  a.event_time,
  a.event_time_zone,
  a.all_day,
  a.venue_name
FROM attractions a
LIMIT 10;
