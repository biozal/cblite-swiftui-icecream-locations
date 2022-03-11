CREATE PRIMARY INDEX icecream

CREATE INDEX adv_properties_addrCity_type ON `icecream`(`properties`.`addrCity`) WHERE `type` = 'Feature'

CREATE INDEX adv_properties_addrCity_addrState_type ON `icecream`(`properties`.`addrState`, `properties`.`addrCity`) WHERE `type` = 'Feature'

CREATE INDEX icecream_state_city_idx ON icecream(properties.addrState, properties.addrCity)
