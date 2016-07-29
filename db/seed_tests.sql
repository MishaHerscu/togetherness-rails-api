-- Checks join table between tags and attractions
SELECT
  t.tag,
  a.title
FROM tags t, attractions a, attraction_tags at
WHERE t.id = at.tag_id
  AND a.id = at.attraction_id
LIMIT 10;
