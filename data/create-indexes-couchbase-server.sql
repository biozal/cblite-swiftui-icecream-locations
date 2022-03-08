CREATE PRIMARY INDEX icecream
CREATE INDEX icecream_state_idx ON icecream(properties.`addr:state`)
CREATE INDEX icecream_state_city_idx ON icecream(properties.`addr:state`, properties.`addr:city`)
