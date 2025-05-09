#!/bin/bash
set -e

#------------------------------
# World configuration
#------------------------------
if [ -n "${SANDBOX_ZOMBIES}" ]; then
 	echo "*** SandboxVars: Population Multiplier ${SANDBOX_ZOMBIES} ***"
  sed -i "s/Zombies =.*/Zombies =${SANDBOX_ZOMBIES},/" "${INSTALL_PRESET}"
fi

if [ -n "${SANDBOX_DISTRIBUTION}" ]; then
  # Define an array for mapping distribution values
  DISTRIBUTION_TYPES=(
    "Invalid"          # Placeholder for index 0 (not used)
    "Urban Focused"    # 1
    "Uniform"          # 2
  )

  # Validate and retrieve the distribution type
  if [ "${SANDBOX_DISTRIBUTION}" -ge 1 ] && [ "${SANDBOX_DISTRIBUTION}" -le 2 ]; then
    DISTRIBUTION_TYPE="${DISTRIBUTION_TYPES[${SANDBOX_DISTRIBUTION}]}"
  else
    echo "Error: Invalid SANDBOX_DISTRIBUTION value: ${SANDBOX_DISTRIBUTION}" >&2
    exit 1
  fi

  echo "*** SandboxVars: Zombie distribution is ${DISTRIBUTION_TYPE} (${SANDBOX_DISTRIBUTION}) ***"
  sed -i "s/Distribution =.*/Distribution =${SANDBOX_DISTRIBUTION},/" "${INSTALL_PRESET}"
fi

if [ -n "${SANDBOX_DAYLENGTH}" ]; then
  # Define an array for mapping DayLength values
  DAYLENGTH_TIMES=(
    "Invalid"          # Placeholder for index 0 (not used)
    "15 Minutes"       # 1
    "30 Minutes"       # 2
  )

  # Populate the array for values 3 to 25
  for i in {3..25}; do
    HOURS=$((i - 2))
    DAYLENGTH_TIMES[i]="${HOURS} Hour"
    [ "${HOURS}" -gt 1 ] && DAYLENGTH_TIMES[i]+="s" # Add 's' for plural
  done

  # Validate and retrieve the DayLength time
  if [ "${SANDBOX_DAYLENGTH}" -ge 1 ] && [ "${SANDBOX_DAYLENGTH}" -le 25 ]; then
    DAYLENGTH_TIME="${DAYLENGTH_TIMES[${SANDBOX_DAYLENGTH}]}"
  else
    echo "Error: Invalid SANDBOX_DAYLENGTH value: ${SANDBOX_DAYLENGTH}" >&2
    exit 1
  fi

  echo "*** SandboxVars: Zombies spawn every ${DAYLENGTH_TIME} ***"
  sed -i "s/DayLength =.*/DayLength =${SANDBOX_DAYLENGTH},/" "${INSTALL_PRESET}"
fi

if [ -n "${SANDBOX_STARTYEAR}" ]; then
 	echo "*** SandboxVars: Starting year at ${SANDBOX_STARTYEAR} ***"
  sed -i "s/StartYear =.*/StartYear =${SANDBOX_STARTYEAR},/" "${INSTALL_PRESET}"
fi

if [ -n "${SANDBOX_STARTMONTH}" ]; then
 	echo "*** SandboxVars: Starting at month ${SANDBOX_STARTMONTH} ***"
  sed -i "s/StartMonth =.*/StartMonth =${SANDBOX_STARTMONTH},/" "${INSTALL_PRESET}"
fi

if [ -n "${SANDBOX_STARTDAY}" ]; then
 	echo "*** SandboxVars: Starting at day ${SANDBOX_STARTDAY} ***"
  sed -i "s/StartDay =.*/StartDay =${SANDBOX_STARTDAY},/" "${INSTALL_PRESET}"
fi

if [ -n "${SANDBOX_STARTTIME}" ]; then
  # Define an array for mapping start day values
  STARTTIME_TIMES=(
    "Invalid"  # Placeholder for index 0 (not used)
    "7 AM"     # 1
    "9 AM"     # 2
    "12 PM"    # 3
    "2 PM"     # 4
    "5 PM"     # 5
    "9 PM"     # 6
    "12 AM"    # 7
    "2 AM"     # 8
  )

  # Validate and retrieve the start day time
  if [ "${SANDBOX_STARTTIME}" -ge 1 ] && [ "${SANDBOX_STARTTIME}" -le 8 ]; then
    STARTTIME_TIME="${STARTTIME_TIMES[${SANDBOX_STARTTIME}]}"
  else
    echo "Error: Invalid SANDBOX_STARTTIME value: ${SANDBOX_STARTTIME}" >&2
    exit 1
  fi

  echo "*** SandboxVars: Starting day at ${STARTTIME_TIME} ***"
  sed -i "s/StartTime =.*/StartTime =${SANDBOX_STARTTIME},/" "${INSTALL_PRESET}"
fi

if [ -n "${SANDBOX_WATERSHUT}" ]; then
  # Define an array for mapping water shutoff values
  WATERSHUT_TIMES=(
    "Default (0-30 Days)"  # 0
    "Instant"              # 1
    "0-30 Days"            # 2
    "0-2 Months"           # 3
    "0-6 Months"           # 4
    "0-1 Year"             # 5
    "0-5 Years"            # 6
    "2-6 Months"           # 7
  )

  # Validate and retrieve the water shutoff time
  if [ "${SANDBOX_WATERSHUT}" -ge 0 ] && [ "${SANDBOX_WATERSHUT}" -le 7 ]; then
    WATERSHUT_TIME="${WATERSHUT_TIMES[${SANDBOX_WATERSHUT}]}"
  else
    echo "Error: Invalid SANDBOX_WATERSHUT value: ${SANDBOX_WATERSHUT}" >&2
    exit 1
  fi

  echo "*** SandboxVars: Water shutoff time is ${WATERSHUT_TIME} (${SANDBOX_WATERSHUT}) ***"
  sed -i "s/WaterShut =.*/WaterShut =${SANDBOX_WATERSHUT},/" "${INSTALL_PRESET}"
fi

if [ -n "${SANDBOX_ELECSHUT}" ]; then
  # Define an array for mapping electricity shutoff values
  ELECSHUT_TIMES=(
    "Default (0-30 Days)"  # 0
    "Instant"              # 1
    "0-30 Days"            # 2
    "0-2 Months"           # 3
    "0-6 Months"           # 4
    "0-1 Year"             # 5
    "0-5 Years"            # 6
    "2-6 Months"           # 7
  )

  # Validate and retrieve the electricity shutoff time
  if [ "${SANDBOX_ELECSHUT}" -ge 0 ] && [ "${SANDBOX_ELECSHUT}" -le 7 ]; then
    ELECSHUT_TIME="${ELECSHUT_TIMES[${SANDBOX_ELECSHUT}]}"
  else
    echo "Error: Invalid SANDBOX_WATERSHUT value: ${SANDBOX_ELECSHUT}" >&2
    exit 1
  fi

  echo "*** SandboxVars: Water shutoff time is ${ELECSHUT_TIME} (${SANDBOX_ELECSHUT}) ***"
  sed -i "s/ElecShut =.*/ElecShut =${SANDBOX_ELECSHUT},/" "${INSTALL_PRESET}"
fi



#------------------------------
# Future settings implementations
#------------------------------


# WaterShutModifier
# ElecShutModifier
# FoodLoot = 4,
#     -- Default=Rare
#     -- 1 = None (not recommended)
#     -- 2 = Insanely Rare
#     -- 3 = Extremely Rare
#     -- 4 = Rare
#     -- 5 = Normal
#     -- 6 = Common
#     CannedFoodLoot = 4,
#     -- Default=Rare
#     -- 1 = None (not recommended)
#     -- 2 = Insanely Rare
#     -- 3 = Extremely Rare
#     -- 4 = Rare
#     -- 5 = Normal
#     -- 6 = Common
#     LiteratureLoot = 4,
#     -- Seeds, Nails, Saws, Fishing Rods, various tools, etc... Default=Rare
#     -- 1 = None (not recommended)
#     -- 2 = Insanely Rare
#     -- 3 = Extremely Rare
#     -- 4 = Rare
#     -- 5 = Normal
#     -- 6 = Common
#     SurvivalGearsLoot = 4,
#     -- Default=Rare
#     -- 1 = None (not recommended)
#     -- 2 = Insanely Rare
#     -- 3 = Extremely Rare
#     -- 4 = Rare
#     -- 5 = Normal
#     -- 6 = Common
#     MedicalLoot = 4,
#     -- Default=Rare
#     -- 1 = None (not recommended)
#     -- 2 = Insanely Rare
#     -- 3 = Extremely Rare
#     -- 4 = Rare
#     -- 5 = Normal
#     -- 6 = Common
#     WeaponLoot = 4,
#     -- Default=Rare
#     -- 1 = None (not recommended)
#     -- 2 = Insanely Rare
#     -- 3 = Extremely Rare
#     -- 4 = Rare
#     -- 5 = Normal
#     -- 6 = Common
#     RangedWeaponLoot = 4,
#     -- Default=Rare
#     -- 1 = None (not recommended)
#     -- 2 = Insanely Rare
#     -- 3 = Extremely Rare
#     -- 4 = Rare
#     -- 5 = Normal
#     -- 6 = Common
#     AmmoLoot = 4,
#     -- Default=Rare
#     -- 1 = None (not recommended)
#     -- 2 = Insanely Rare
#     -- 3 = Extremely Rare
#     -- 4 = Rare
#     -- 5 = Normal
#     -- 6 = Common
#     MechanicsLoot = 4,
#     -- Everything else. Also affects foraging for all items in Town/Road zones. Default=Rare
#     -- 1 = None (not recommended)
#     -- 2 = Insanely Rare
#     -- 3 = Extremely Rare
#     -- 4 = Rare
#     -- 5 = Normal
#     -- 6 = Common
#     OtherLoot = 4,
#     -- Controls the global temperature. Default=Normal
#     -- 1 = Very Cold
#     -- 2 = Cold
#     -- 3 = Normal
#     -- 4 = Hot
#     Temperature = 3,
#     -- Controls how often it rains. Default=Normal
#     -- 1 = Very Dry
#     -- 2 = Dry
#     -- 3 = Normal
#     -- 4 = Rainy
#     Rain = 3,
#     -- Number of days until 100% growth. Default=Normal (100 Days)
#     -- 1 = Very Fast (20 Days)
#     -- 2 = Fast (50 Days)
#     -- 3 = Normal (100 Days)
#     -- 4 = Slow (200 Days)
#     ErosionSpeed = 3,
#     -- Number of days until 100% growth. -1 means no growth. Zero means use the Erosion Speed option. Maximum 36,500 (100 years). Minimum=-1 Maximum=36500 Default=0
#     ErosionDays = 0,
#     -- Modifies the base XP gain from actions by this number. Minimum=0.00 Maximum=1000.00 Default=1.00
#     XpMultiplier = 1.0,
#     -- Determines if the XP multiplier affects passively levelled skills eg. Fitness and Strength.
#     XpMultiplierAffectsPassive = false,
#     -- Use this to multiply or reduce engine general loudness. Minimum=0.00 Maximum=100.00 Default=1.00
#     ZombieAttractionMultiplier = 1.0,
#     -- Governs whether cars are locked, need keys to start etc.
#     VehicleEasyUse = false,
#     -- Controls the speed of plant growth. Default=Normal
#     -- 1 = Very Fast
#     -- 2 = Fast
#     -- 3 = Normal
#     -- 4 = Slow
#     Farming = 3,
#     -- Controls the time it takes for food to break down in a composter. Default=2 Weeks
#     -- 1 = 1 Week
#     -- 2 = 2 Weeks
#     -- 3 = 3 Weeks
#     -- 4 = 4 Weeks
#     -- 5 = 6 Weeks
#     -- 6 = 8 Weeks
#     -- 7 = 10 Weeks
#     CompostTime = 2,
#     -- How fast character's hunger, thirst and fatigue will decrease. Default=Normal
#     -- 1 = Very Fast
#     -- 2 = Fast
#     -- 3 = Normal
#     -- 4 = Slow
#     StatsDecrease = 3,
#     -- Controls the abundance of fish and general forage. Default=Normal
#     -- 1 = Very Poor
#     -- 2 = Poor
#     -- 3 = Normal
#     -- 4 = Abundant
#     NatureAbundance = 3,
#     -- Default=Sometimes
#     -- 1 = Never
#     -- 2 = Extremely Rare
#     -- 3 = Rare
#     -- 4 = Sometimes
#     -- 5 = Often
#     Alarm = 4,
#     -- How frequently homes and buildings will be discovered locked Default=Very Often
#     -- 1 = Never
#     -- 2 = Extremely Rare
#     -- 3 = Rare
#     -- 4 = Sometimes
#     -- 5 = Often
#     LockedHouses = 6,
#     -- Spawn with chips, water bottle, school bag, baseball bat and a hammer.
#     StarterKit = false,
#     -- Nutritional value of food affects the player's condition.
#     Nutrition = true,
#     -- Define how fast the food will spoil inside or outside fridge. Default=Normal
#     -- 1 = Very Fast
#     -- 2 = Fast
#     -- 3 = Normal
#     -- 4 = Slow
#     FoodRotSpeed = 3,
#     -- Define how much a fridge will be effective. Default=Normal
#     -- 1 = Very Low
#     -- 2 = Low
#     -- 3 = Normal
#     -- 4 = High
#     FridgeFactor = 3,
#     -- Items will respawn in already-looted containers in towns and trailer parks. Items will not respawn in player-made containers. Default=None
#     -- 1 = None
#     -- 2 = Every Day
#     -- 3 = Every Week
#     -- 4 = Every Month
#     LootRespawn = 1,
#     -- When > 0, loot will not respawn in zones that have been visited within this number of in-game hours. Minimum=0 Maximum=2147483647 Default=0
#     SeenHoursPreventLootRespawn = 0,
#     -- A comma-separated list of item types that will be removed after HoursForWorldItemRemoval hours.
#     WorldItemRemovalList = "Base.Hat,Base.Glasses,Base.Maggots",
#     -- Number of hours since an item was dropped on the ground before it is removed.  Items are removed the next time that part of the map is loaded.  Zero means items are not removed. Minimum=0.00 Maximum=2147483647.00 Default=24.00
#     HoursForWorldItemRemoval = 24.0,
#     -- If true, any items *not* in WorldItemRemovalList will be removed.
#     ItemRemovalListBlacklistToggle = false,
#     -- This will affect starting world erosion and food spoilage. Default=0
#     -- 1 = 0
#     -- 2 = 1
#     -- 3 = 2
#     -- 4 = 3
#     -- 5 = 4
#     -- 6 = 5
#     -- 7 = 6
#     -- 8 = 7
#     -- 9 = 8
#     -- 10 = 9
#     -- 11 = 10
#     -- 12 = 11
#     TimeSinceApo = 1,
#     -- Will influence how much water the plant will lose per day and their ability to avoid disease. Default=Normal
#     -- 1 = Very High
#     -- 2 = High
#     -- 3 = Normal
#     -- 4 = Low
#     PlantResilience = 3,
#     -- Controls the yield of plants when harvested. Default=Normal
#     -- 1 = Very Poor
#     -- 2 = Poor
#     -- 3 = Normal
#     -- 4 = Abundant
#     PlantAbundance = 3,
#     -- Recovery from being tired from performing actions Default=Normal
#     -- 1 = Very Fast
#     -- 2 = Fast
#     -- 3 = Normal
#     -- 4 = Slow
#     EndRegen = 3,
#     -- How regularly helicopters pass over the event zone. Default=Once
#     -- 1 = Never
#     -- 2 = Once
#     -- 3 = Sometimes
#     Helicopter = 2,
#     -- How often zombie attracting metagame events like distant gunshots will occur. Default=Sometimes
#     -- 1 = Never
#     -- 2 = Sometimes
#     MetaEvent = 2,
#     -- Governs night-time metagame events during the player's sleep. Default=Never
#     -- 1 = Never
#     -- 2 = Sometimes
#     SleepingEvent = 1,
#     -- Increase/decrease the chance of electrical generators spawning on the map. Default=Sometimes
#     -- 1 = Extremely Rare
#     -- 2 = Rare
#     -- 3 = Sometimes
#     -- 4 = Often
#     GeneratorSpawning = 3,
#     -- How much fuel is consumed per in-game hour. Minimum=0.00 Maximum=100.00 Default=1.00
#     GeneratorFuelConsumption = 1.0,
#     -- Increase/decrease probability of discovering randomized safe houses on the map: either burnt out, containing loot stashes, dead survivor bodies etc. Default=Rare
#     -- 1 = Never
#     -- 2 = Extremely Rare
#     -- 3 = Rare
#     -- 4 = Sometimes
#     -- 5 = Often
#     SurvivorHouseChance = 3,
#     -- Default=Rare
#     -- 1 = Never
#     -- 2 = Extremely Rare
#     -- 3 = Rare
#     -- 4 = Sometimes
#     -- 5 = Often
#     VehicleStoryChance = 3,
#     -- Default=Rare
#     -- 1 = Never
#     -- 2 = Extremely Rare
#     -- 3 = Rare
#     -- 4 = Sometimes
#     -- 5 = Often
#     ZoneStoryChance = 3,
#     -- Impacts on how often a looted map will have annotations marked on it by a deceased survivor. Default=Sometimes
#     -- 1 = Never
#     -- 2 = Extremely Rare
#     -- 3 = Rare
#     -- 4 = Sometimes
#     -- 5 = Often
#     AnnotatedMapChance = 4,
#     -- Adds free points during character creation. Minimum=-100 Maximum=100 Default=0
#     CharacterFreePoints = 0,
#     -- Gives player-built constructions extra hit points so they are more resistant to zombie damage. Default=Normal
#     -- 1 = Very Low
#     -- 2 = Low
#     -- 3 = Normal
#     -- 4 = High
#     ConstructionBonusPoints = 3,
#     -- Governs the ambient lighting at night. Default=Normal
#     -- 1 = Pitch Black
#     -- 2 = Dark
#     -- 3 = Normal
#     NightDarkness = 3,
#     -- Governs the time from dusk to dawn. Default=Normal
#     -- 1 = Always Night
#     -- 2 = Long
#     -- 3 = Normal
#     -- 4 = Short
#     NightLength = 3,
#     -- Increase and decrease the impact injuries have on your body, and their healing time. Default=Normal
#     -- 1 = Low
#     -- 2 = Normal
#     InjurySeverity = 2,
#     -- Enable or disable broken limbs when survivors receive injuries from impacts, zombie damage and falls.
#     BoneFracture = true,
#     -- How long before zombie bodies disappear. Minimum=-1.00 Maximum=2147483647.00 Default=216.00
#     HoursForCorpseRemoval = 216.0,
#     -- Governs impact that nearby decaying bodies has on the player's health and emotions. Default=Normal
#     -- 1 = None
#     -- 2 = Low
#     -- 3 = Normal
#     DecayingCorpseHealthImpact = 3,
#     -- How much blood is sprayed on floor and walls. Default=Normal
#     -- 1 = None
#     -- 2 = Low
#     -- 3 = Normal
#     -- 4 = High
#     BloodLevel = 3,
#     -- Governs how quickly clothing degrades, becomes dirty, and bloodied. Default=Normal
#     -- 1 = Disabled
#     -- 2 = Slow
#     -- 3 = Normal
#     ClothingDegradation = 3,
#     FireSpread = true,
#     -- Number of in-game days before rotten food is removed from the map. -1 means rotten food is never removed. Minimum=-1 Maximum=2147483647 Default=-1
#     DaysForRottenFoodRemoval = -1,
#     -- If enabled, generators will work on exterior tiles, allowing for example to power gas pump.
#     AllowExteriorGenerator = true,
#     -- Controls the maximum intensity of fog. Default=Normal
#     -- 1 = Normal
#     -- 2 = Moderate
#     MaxFogIntensity = 1,
#     -- Controls the maximum intensity of rain. Default=Normal
#     -- 1 = Normal
#     -- 2 = Moderate
#     MaxRainFxIntensity = 1,
#     -- If disabled snow will not accumulate on ground but will still be visible on vegetation and rooftops.
#     EnableSnowOnGround = true,
#     -- When enabled certain melee weapons will be able to strike multiple zombies in one hit.
#     MultiHitZombies = false,
#     -- Chance of being bitten when a zombie attacks from behind. Default=High
#     -- 1 = Low
#     -- 2 = Medium
#     RearVulnerability = 3,
#     -- Disable to walk unimpeded while melee attacking.
#     AttackBlockMovements = true,
#     AllClothesUnlocked = false,
#     -- if disabled, tainted water will not have a warning marking it as such
#     EnableTaintedWaterText = true,
#     -- Governs how frequently cars are discovered on the map Default=Low
#     -- 1 = None
#     -- 2 = Very Low
#     -- 3 = Low
#     -- 4 = Normal
#     CarSpawnRate = 3,
#     -- Governs the chances of finding vehicles with gas in the tank. Default=Low
#     -- 1 = Low
#     -- 2 = Normal
#     ChanceHasGas = 1,
#     -- Governs how full gas tanks will be in discovered cars. Default=Low
#     -- 1 = Very Low
#     -- 2 = Low
#     -- 3 = Normal
#     -- 4 = High
#     -- 5 = Very High
#     InitialGas = 2,
#     -- Governs how full gas tanks in fuel station will be, initially. Default=Normal
#     -- 1 = Empty
#     -- 2 = Super Low
#     -- 3 = Very Low
#     -- 4 = Low
#     -- 5 = Normal
#     -- 6 = High
#     -- 7 = Very High
#     -- 8 = Full
#     FuelStationGas = 5,
#     -- How gas-hungry vehicles on the map are. Minimum=0.00 Maximum=100.00 Default=1.00
#     CarGasConsumption = 1.0,
#     -- Default=Rare
#     -- 1 = Never
#     -- 2 = Extremely Rare
#     -- 3 = Rare
#     -- 4 = Sometimes
#     -- 5 = Often
#     LockedCar = 3,
#     -- General condition of vehicles discovered on the map Default=Low
#     -- 1 = Very Low
#     -- 2 = Low
#     -- 3 = Normal
#     -- 4 = High
#     CarGeneralCondition = 2,
#     -- Governs the amount of damage dealt to vehicles that crash. Default=Normal
#     -- 1 = Very Low
#     -- 2 = Low
#     -- 3 = Normal
#     -- 4 = High
#     CarDamageOnImpact = 3,
#     -- Damage received by the player from the car in a collision. Default=None
#     -- 1 = None
#     -- 2 = Low
#     -- 3 = Normal
#     -- 4 = High
#     DamageToPlayerFromHitByACar = 1,
#     -- Enable or disable traffic jams that spawn on the main roads of the map.
#     TrafficJam = true,
#     -- How frequently cars will be discovered with an alarm. Default=Extremely Rare
#     -- 1 = Never
#     -- 2 = Extremely Rare
#     -- 3 = Rare
#     -- 4 = Sometimes
#     -- 5 = Often
#     CarAlarm = 2,
#     -- Enable or disable player getting damage from being in a car accident.
#     PlayerDamageFromCrash = true,
#     -- How many in-game hours before a wailing siren shuts off. Minimum=0.00 Maximum=168.00 Default=0.00
#     SirenShutoffHours = 0.0,
#     --  Governs whether player can discover a car that has been maintained and cared for after the infection struck. Default=Low
#     -- 1 = None
#     -- 2 = Low
#     -- 3 = Normal
#     RecentlySurvivorVehicles = 2,
#     -- Enables vehicles to spawn.
#     EnableVehicles = true,
#     -- Governs if poisoning food is enabled. Default=True
#     -- 1 = True
#     -- 2 = False
#     EnablePoisoning = 1,
#     -- Default=In and around bodies
#     -- 1 = In and around bodies
#     -- 2 = In bodies only
#     MaggotSpawn = 1,
#     -- The higher the value, the longer lightbulbs last before breaking. If 0, lightbulbs will never break. Does not affect vehicle headlights. Minimum=0.00 Maximum=1000.00 Default=1.00
#     LightBulbLifespan = 1.0,
#     Map = {
#         AllowMiniMap = false,
#         AllowWorldMap = true,
#         MapAllKnown = false,
#     },
#     ZombieLore = {
#         -- Controls the zombie movement rate. Default=Fast Shamblers
#         -- 1 = Sprinters
#         -- 2 = Fast Shamblers
#         -- 3 = Shamblers
#         Speed = 2,
#         -- Controls the damage zombies inflict per attack. Default=Normal
#         -- 1 = Superhuman
#         -- 2 = Normal
#         -- 3 = Weak
#         Strength = 2,
#         -- Controls the difficulty to kill zombies. Default=Normal
#         -- 1 = Tough
#         -- 2 = Normal
#         -- 3 = Fragile
#         Toughness = 2,
#         -- Controls how the zombie virus spreads. Default=Blood + Saliva
#         -- 1 = Blood + Saliva
#         -- 2 = Saliva Only
#         -- 3 = Everyone's Infected
#         Transmission = 1,
#         -- Controls how quickly the infection takes effect. Default=2-3 Days
#         -- 1 = Instant
#         -- 2 = 0-30 Seconds
#         -- 3 = 0-1 Minutes
#         -- 4 = 0-12 Hours
#         -- 5 = 2-3 Days
#         -- 6 = 1-2 Weeks
#         Mortality = 5,
#         -- Controls how quickly corpses rise as zombies. Default=0-1 Minutes
#         -- 1 = Instant
#         -- 2 = 0-30 Seconds
#         -- 3 = 0-1 Minutes
#         -- 4 = 0-12 Hours
#         -- 5 = 2-3 Days
#         Reanimate = 3,
#         -- Controls zombie intelligence. Default=Basic Navigation
#         -- 1 = Navigate + Use Doors
#         -- 2 = Navigate
#         -- 3 = Basic Navigation
#         Cognition = 3,
#         -- Controls which zombies can crawl under vehicles. Default=Often
#         -- 1 = Crawlers Only
#         -- 2 = Extremely Rare
#         -- 3 = Rare
#         -- 4 = Sometimes
#         -- 5 = Often
#         -- 6 = Very Often
#         CrawlUnderVehicle = 5,
#         -- Controls how long zombies remember players after seeing or hearing. Default=Normal
#         -- 1 = Long
#         -- 2 = Normal
#         -- 3 = Short
#         -- 4 = None
#         Memory = 2,
#         -- Controls zombie vision radius. Default=Normal
#         -- 1 = Eagle
#         -- 2 = Normal
#         -- 3 = Poor
#         Sight = 2,
#         -- Controls zombie hearing radius. Default=Normal
#         -- 1 = Pinpoint
#         -- 2 = Normal
#         -- 3 = Poor
#         Hearing = 2,
#         -- Zombies that have not seen/heard player can attack doors and constructions while roaming.
#         ThumpNoChasing = false,
#         -- Governs whether or not zombies can destroy player constructions and defences.
#         ThumpOnConstruction = true,
#         -- Governs whether zombies are more active during the day, or whether they act more nocturnally.  Active zombies will use the speed set in the "Speed" setting. Inactive zombies will be slower, and tend not to give chase. Default=Both
#         -- 1 = Both
#         -- 2 = Night
#         ActiveOnly = 1,
#         -- Allows zombies to trigger house alarms when breaking through windows and doors.
#         TriggerHouseAlarm = false,
#         -- When enabled if multiple zombies are attacking they can drag you down to feed. Dependent on zombie strength.
#         ZombiesDragDown = true,
#         -- When enabled zombies will have a chance to lunge after climbing over a fence if you're too close.
#         ZombiesFenceLunge = true,
#         -- Default=Some zombies in the world will pretend to be dead
#         -- 1 = Some zombies in the world will pretend to be dead
#         -- 2 = Some zombies in the world, as well as some you 'kill', can pretend to be dead
#         DisableFakeDead = 1,
#     },
#     ZombieConfig = {
#         -- Set by the "Zombie Count" population option. 4.0 = Insane, Very High = 3.0, 2.0 = High, 1.0 = Normal, 0.35 = Low, 0.0 = None. Minimum=0.00 Maximum=4.00 Default=1.00
#         PopulationMultiplier = 1.0,
#         -- Adjusts the desired population at the start of the game. Minimum=0.00 Maximum=4.00 Default=1.00
#         PopulationStartMultiplier = 1.0,
#         -- Adjusts the desired population on the peak day. Minimum=0.00 Maximum=4.00 Default=1.50
#         PopulationPeakMultiplier = 1.5,
#         -- The day when the population reaches it's peak. Minimum=1 Maximum=365 Default=28
#         PopulationPeakDay = 28,
#         -- The number of hours that must pass before zombies may respawn in a cell. If zero, spawning is disabled. Minimum=0.00 Maximum=8760.00 Default=72.00
#         RespawnHours = 72.0,
#         -- The number of hours that a chunk must be unseen before zombies may respawn in it. Minimum=0.00 Maximum=8760.00 Default=16.00
#         RespawnUnseenHours = 16.0,
#         -- The fraction of a cell's desired population that may respawn every RespawnHours. Minimum=0.00 Maximum=1.00 Default=0.10
#         RespawnMultiplier = 0.1,
#         -- The number of hours that must pass before zombies migrate to empty parts of the same cell. If zero, migration is disabled. Minimum=0.00 Maximum=8760.00 Default=12.00
#         RedistributeHours = 12.0,
#         -- The distance a zombie will try to walk towards the last sound it heard. Minimum=10 Maximum=1000 Default=100
#         FollowSoundDistance = 100,
#         -- The size of groups real zombies form when idle. Zero means zombies don't form groups. Groups don't form inside buildings or forest zones. Minimum=0 Maximum=1000 Default=20
#         RallyGroupSize = 20,
#         -- The distance real zombies travel to form groups when idle. Minimum=5 Maximum=50 Default=20
#         RallyTravelDistance = 20,
#         -- The distance between zombie groups. Minimum=5 Maximum=25 Default=15
#         RallyGroupSeparation = 15,
#         -- How close members of a group stay to the group's leader. Minimum=1 Maximum=10 Default=3
#         RallyGroupRadius = 3,
#     },
# }