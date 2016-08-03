# recreate the database from seeds
begin
  system('dropdb togetherness_development')
end
begin
  system('createdb togetherness_development')
end
system('pg_restore -d togetherness_development seed_data.dump')
