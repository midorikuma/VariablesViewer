##particle(block_marker warped_planks)
particle minecraft:block_marker warped_planks ^ ^1 ^1 0 0 0 1 1 force
##rendertype_entity_cutout_no_cull(pig)
summon pig
##rendertype_entity_translucent_cull(customized carrot_on_a_stick)
give @p minecraft:carrot_on_a_stick{CustomModelData:1}
##rendertype_solid(warped_planks)
setblock ^ ^1 ^1 warped_planks