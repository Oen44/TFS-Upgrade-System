function onLogin(player)
  us_onLogin(player)
  return true
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
  return us_onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
end

function onManaChange(creature, attacker, manaChange, origin)
  return us_onManaChange(creature, attacker, manaChange, origin)
end

function onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
  return us_onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
end

function onKill(player, target, lastHit)
  return us_onKill(player, target, lastHit)
end

function onPrepareDeath(creature, killer)
  return us_onPrepareDeath(creature, killer)
end
