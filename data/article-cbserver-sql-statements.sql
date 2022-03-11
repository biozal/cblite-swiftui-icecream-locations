SELECT id, properties.addrCity, properties.addrHousenumber, properties.addrPostcode, 
properties.addrStreet, properties.addrState, properties.name 
FROM icecream 
WHERE properties.addrCity <> "" 
AND type = "Feature" 
ORDER BY properties.name

SELECT id, properties.addrCity, properties.addHousenumber, properties.addrPostcode, 
properties.addrStreet, properties.addrState, properties.name 
FROM icecream 
WHERE
properties.addrCity IS NOT NULL  
AND properties.addrState = 'GA'
AND type = "Feature" 
ORDER BY properties.name
