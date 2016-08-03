# recreate the database from seeds
begin
  system('dropdb togetherness_development')
end
begin
  system('createdb togetherness_development')
end
system('psql togetherness_development < seed_data.csv')
