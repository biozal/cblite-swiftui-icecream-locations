CREATE PRIMARY INDEX icecream

CREATE INDEX adv_properties_name ON `icecream`(`properties`.`name`)

CREATE INDEX adv_properties_name_properties_addrcity ON `icecream`(`properties`.`name`,`properties`.`addr:city`)

CREATE INDEX icecream_state_city_idx ON icecream(properties.`addr:state`, properties.`addr:city`)
