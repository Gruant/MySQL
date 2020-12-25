SELECT 
    title, region_id, country_id
FROM
    geodata._cities
WHERE
    title = 'Москва';
    
SELECT 
    title
FROM
    geodata._cities
WHERE
    region_id = (SELECT 
            id
        FROM
            geodata._regions
        WHERE
            title = 'Московская область');

-- ИЛИ

SELECT 
    c.title
FROM
    geodata._cities AS c
        JOIN
    geodata._regions AS r
WHERE
    c.region_id = r.id
        AND r.title = 'Московская область'
