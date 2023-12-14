-- Load the badge names from both files
badges_ai = LOAD '/project/StackExchange/Badges/badges_ai.csv' USING PigStorage(',') AS (badge:chararray);
badges_gaming = LOAD '/project/StackExchange/Badges/badges_gaming.csv' USING PigStorage(',') AS (badge:chararray);
badges_history = LOAD '/project/StackExchange/Badges/badges_history.csv' USING PigStorage(',') AS (badge:chararray);
badges_movies = LOAD '/project/StackExchange/Badges/badges_movies.csv' USING PigStorage(',') AS (badge:chararray);
badges_music = LOAD '/project/StackExchange/Badges/badges_music.csv' USING PigStorage(',') AS (badge:chararray);
badges_softwareengineering = LOAD '/project/StackExchange/Badges/badges_softwareengineering.csv' USING PigStorage(',') AS (badge:chararray);



-- Remove the 'Name' value from both datasets
badges_ai_filtered = FILTER badges_ai BY badge != 'Name';
badges_gaming_filtered = FILTER badges_gaming BY badge != 'Name';
badges_history_filtered = FILTER badges_history BY badge != 'Name';
badges_movies_filtered = FILTER badges_movies BY badge != 'Name';
badges_music_filtered = FILTER badges_music BY badge != 'Name';
badges_softwareengineering_filtered = FILTER badges_softwareengineering BY badge != 'Name';


-- Find common values
common_badges = JOIN badges_ai_filtered BY badge, badges_gaming_filtered BY badge, badges_history_filtered BY badge, badges_movies_filtered BY badge, badges_music_filtered BY badge, badges_softwareengineering_filtered BY badge;

-- Extract the common values
common_values = FOREACH common_badges GENERATE badges_ai_filtered::badge AS common_badge;


-- Store the common values in a new file
STORE common_values INTO '/project/StackExchange/Badges/Common_Badges.csv' USING PigStorage(',');





