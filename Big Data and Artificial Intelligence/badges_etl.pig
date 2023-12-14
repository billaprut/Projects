-- Load Badges.csv file using PigStorage and define schema
badges_data = LOAD '/project/StackExchange/ai.stackexchange.com/Badges.csv' USING PigStorage(',') AS (Id:int, UserId:int, Class:int, Name:chararray, TagBased:int, Date:chararray );

-- Project only Name column
badges = FOREACH badges_data GENERATE Name;

badges_distinct = DISTINCT badges;

STORE badges_distinct INTO '/project/StackExchange/Badge/ai.csv' USING PigStorage(',');


-- Load Badges.csv file using PigStorage and define schema
badges_data = LOAD '/project/StackExchange/gaming.stackexchange.com/Badges.csv' USING PigStorage(',') AS (Id:int, UserId:int, Class:int, Name:chararray, TagBased:int, Date:chararray );

-- Project only Name column
badges = FOREACH badges_data GENERATE Name;

badges_distinct	= DISTINCT badges;

STORE badges_distinct INTO '/project/StackExchange/Badge/gaming.csv' USING PigStorage(',');

-- Load Badges.csv file using PigStorage and define schema
badges_data = LOAD '/project/StackExchange/history.stackexchange.com/Badges.csv' USING PigStorage(',') AS (Id:int, UserId:int, Class:int, Name:chararray, TagBased:int, Date:chararray );

-- Project only Name column
badges = FOREACH badges_data GENERATE Name;

badges_distinct	= DISTINCT badges;

STORE badges_distinct INTO '/project/StackExchange/Badge/history.csv' USING PigStorage(',');


-- Load Badges.csv file using PigStorage and define schema
badges_data = LOAD '/project/StackExchange/movies.stackexchange.com/Badges.csv' USING PigStorage(',') AS (Id:int, UserId:int, Class:int, Name:chararray, TagBased:int, Date:chararray );

-- Project only Name column
badges = FOREACH badges_data GENERATE Name;

badges_distinct = DISTINCT badges;

STORE badges_distinct INTO '/project/StackExchange/Badge/movies.csv' USING PigStorage(',');

-- Load Badges.csv file using PigStorage and define schema
badges_data = LOAD '/project/StackExchange/music.stackexchange.com/Badges.csv' USING PigStorage(',') AS (Id:int, UserId:int, Class:int, Name:chararray, TagBased:int, Date:chararray );

-- Project only Name column
badges = FOREACH badges_data GENERATE Name;

badges_distinct	= DISTINCT badges;

STORE badges_distinct INTO '/project/StackExchange/Badge/music.csv' USING PigStorage(',');


-- Load Badges.csv file using PigStorage and define schema
badges_data = LOAD '/project/StackExchange/softwareengineering.stackexchange.com/Badges.csv' USING PigStorage(',') AS (Id:int, UserId:int, Class:int, Name:chararray, TagBased:int, Date:chararray );

-- Project only Name column
badges = FOREACH badges_data GENERATE Name;

badges_distinct = DISTINCT badges;

STORE badges_distinct INTO '/project/StackExchange/Badge/softwreengineering.csv' USING PigStorage(',');

