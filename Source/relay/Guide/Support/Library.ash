import "relay/Guide/Support/Math.ash"
import "relay/Guide/Support/List.ash"

boolean mafiaIsPastRevision(int revision_number)
{
    if (get_revision() <= 0) //get_revision reports zero in certain cases; assume they're on a recent version
        return true;
    return (get_revision() >= revision_number);
}

//Additions to standard API:
//Auto-conversion property functions:
boolean get_property_boolean(string property)
{
	return get_property(property).to_boolean();
}

int get_property_int(string property)
{
	return get_property(property).to_int_silent();
}

location get_property_location(string property)
{
	return get_property(property).to_location();
}

float get_property_float(string property)
{
	return get_property(property).to_float();
}

monster get_property_monster(string property)
{
	return get_property(property).to_monster();
}

buffer to_buffer(string str)
{
	buffer result;
	result.append(str);
	return result;
}


int PATH_UNKNOWN = -1;
int PATH_NONE = 0;
int PATH_TEETOTALER = 1;
int PATH_BOOZETAFARIAN = 2;
int PATH_OXYGENARIAN = 3;

int PATH_BEES_HATE_YOU = 9;
int PATH_WAY_OF_THE_SURPRISING_FIST = 10;
int PATH_TRENDY = 11;
int PATH_AVATAR_OF_BORIS = 12;
int PATH_BUGBEAR_INVASION = 13;
int PATH_ZOMBIE_SLAYER = 14;
int PATH_CLASS_ACT = 15;
int PATH_AVATAR_OF_JARLSBERG = 16;
int PATH_BIG = 17;
int PATH_KOLHS = 18;
int PATH_CLASS_ACT_2 = 19;
int PATH_AVATAR_OF_SNEAKY_PETE = 20;
int PATH_SLOW_AND_STEADY = 21;
int PATH_HEAVY_RAINS = 22;
int PATH_PICKY = 23;
int PATH_STANDARD = 24;
int PATH_ACTUALLY_ED_THE_UNDYING = 25;

int __my_path_id_cached = -11;
int my_path_id()
{
    if (__my_path_id_cached != -11)
        return __my_path_id_cached;
    string path_name = my_path();
    
    if (path_name == "" || path_name == "None")
        __my_path_id_cached = PATH_NONE;
    else if (path_name == "Teetotaler")
        __my_path_id_cached = PATH_TEETOTALER;
    else if (path_name == "Boozetafarian")
        __my_path_id_cached = PATH_BOOZETAFARIAN;
    else if (path_name == "Oxygenarian")
        __my_path_id_cached = PATH_OXYGENARIAN;
    else if (path_name == "Bees Hate You")
        __my_path_id_cached = PATH_BEES_HATE_YOU;
    else if (path_name == "Way of the Surprising Fist")
        __my_path_id_cached = PATH_WAY_OF_THE_SURPRISING_FIST;
    else if (path_name == "Trendy")
        __my_path_id_cached = PATH_TRENDY;
    else if (path_name == "Avatar of Boris")
        __my_path_id_cached = PATH_AVATAR_OF_BORIS;
    else if (path_name == "Bugbear Invasion")
        __my_path_id_cached = PATH_BUGBEAR_INVASION;
    else if (path_name == "Zombie Slayer")
        __my_path_id_cached = PATH_ZOMBIE_SLAYER;
    else if (path_name == "Class Act")
        __my_path_id_cached = PATH_CLASS_ACT;
    else if (path_name == "Avatar of Jarlsberg")
        __my_path_id_cached = PATH_AVATAR_OF_JARLSBERG;
    else if (path_name == "BIG!")
        __my_path_id_cached = PATH_BIG;
    else if (path_name == "KOLHS")
        __my_path_id_cached = PATH_KOLHS;
    else if (path_name == "Class Act II: A Class For Pigs")
        __my_path_id_cached = PATH_CLASS_ACT_2;
    else if (path_name == "Avatar of Sneaky Pete")
        __my_path_id_cached = PATH_AVATAR_OF_SNEAKY_PETE;
    else if (path_name == "Slow and Steady")
        __my_path_id_cached = PATH_SLOW_AND_STEADY;
    else if (path_name == "Heavy Rains")
        __my_path_id_cached = PATH_HEAVY_RAINS;
    else if (path_name == "Picky")
        __my_path_id_cached = PATH_PICKY;
    else if (path_name == "Standard")
        __my_path_id_cached = PATH_STANDARD;
    else if (path_name == "Actually Ed the Undying")
        __my_path_id_cached = PATH_ACTUALLY_ED_THE_UNDYING;
    else
        __my_path_id_cached = PATH_UNKNOWN;
    return __my_path_id_cached;
}

boolean have_familiar_replacement(familiar f)
{
    //have_familiar bugs in avatar of sneaky pete for now, so:
    if (my_path_id() == PATH_AVATAR_OF_BORIS || my_path_id() == PATH_AVATAR_OF_JARLSBERG || my_path_id() == PATH_AVATAR_OF_SNEAKY_PETE)
        return false;
    return f.have_familiar();
}

//Similar to have_familiar, except it also checks trendy (not sure if have_familiar supports trendy) and 100% familiar runs
boolean familiar_is_usable(familiar f)
{
    //r13998 has most of these
    if (my_path_id() == PATH_AVATAR_OF_BORIS || my_path_id() == PATH_AVATAR_OF_JARLSBERG || my_path_id() == PATH_AVATAR_OF_SNEAKY_PETE || my_path_id() == PATH_ACTUALLY_ED_THE_UNDYING)
        return false;
    if (!is_unrestricted(f))
        return false;
	int single_familiar_run = get_property_int("singleFamiliarRun");
	if (single_familiar_run != -1 && my_turncount() >= 30) //after 30 turns, they're probably sure
	{
		if (f == single_familiar_run.to_familiar())
			return true;
		return false;
	}
	if (my_path_id() == PATH_TRENDY)
	{
		if (!is_trendy(f))
			return false;
	}
	else if (my_path_id() == PATH_BEES_HATE_YOU)
	{
		if (f.to_string().contains_text("b") || f.to_string().contains_text("B")) //bzzzz!
			return false; //so not green
	}
	return have_familiar(f);
}

//inigo's used to show up as have_skill while under restrictions, possibly others
boolean skill_is_usable(skill s)
{
    if (!s.have_skill())
        return false;
    if (!s.is_unrestricted())
        return false;
    return true;
}

boolean in_ronin()
{
	return !can_interact();
}


boolean [item] makeConstantItemArrayMutable(boolean [item] array)
{
    boolean [item] result;
    foreach l in array
        result[l] = array[l];
    
    return result;
}

boolean [location] makeConstantLocationArrayMutable(boolean [location] locations)
{
    boolean [location] result;
    foreach l in locations
        result[l] = locations[l];
    
    return result;
}

boolean [skill] makeConstantSkillArrayMutable(boolean [skill] array)
{
    boolean [skill] result;
    foreach l in array
        result[l] = array[l];
    
    return result;
}

//split_string returns an immutable array, which will error on certain edits
//Use this function - it converts to an editable map.
string [int] split_string_mutable(string source, string delimiter)
{
	string [int] result;
	string [int] immutable_array = split_string(source, delimiter);
	foreach key in immutable_array
		result[key] = immutable_array[key];
	return result;
}

//This returns [] for empty strings. This isn't standard for split(), but is more useful for passing around lists. Hacky, I suppose.
string [int] split_string_alternate(string source, string delimiter)
{
    if (source.length() == 0)
        return listMakeBlankString();
    return split_string_mutable(source, delimiter);
}

//Same as my_primestate(), except refers to substat
stat my_primesubstat()
{
	if (my_primestat() == $stat[muscle])
		return $stat[submuscle];
	else if (my_primestat() == $stat[mysticality])
		return $stat[submysticality];
	else if (my_primestat() == $stat[moxie])
		return $stat[submoxie];
	return $stat[none];
}

item [int] items_missing(boolean [item] items)
{
    item [int] result;
    foreach it in items
    {
        if (it.available_amount() == 0)
            result.listAppend(it);
    }
    return result;
}

string slot_to_string(slot s)
{
    if (s == $slot[acc1] || s == $slot[acc2] || s == $slot[acc3])
        return "accessory";
    else if (s == $slot[sticker1] || s == $slot[sticker2] || s == $slot[sticker3])
        return "sticker";
    else if (s == $slot[folder1] || s == $slot[folder2] || s == $slot[folder3] || s == $slot[folder4] || s == $slot[folder5])
        return "folder";
    else if (s == $slot[fakehand])
        return "fake hand";
    else if (s == $slot[crown-of-thrones])
        return "crown of thrones";
    else if (s == $slot[buddy-bjorn])
        return "buddy bjorn";
    return s;
}

int storage_amount(boolean [item] items)
{
    int count = 0;
    foreach it in items
    {
        count += it.storage_amount();
    }
    return count;
}

int available_amount(boolean [item] items)
{
    //Usage:
    //$items[disco ball, corrupted stardust].available_amount()
    //Returns the total number of all items.
    int count = 0;
    foreach it in items
    {
        count += it.available_amount();
    }
    return count;
}

int available_amount(item [int] items)
{
    int count = 0;
    foreach key in items
    {
        count += items[key].available_amount();
    }
    return count;
}

int available_amount_ignoring_storage(item it)
{
    if (can_interact())
        return it.available_amount() - it.storage_amount();
    else
        return it.available_amount();
}

int available_amount_ignoring_closet(item it)
{
    if (get_property_boolean("autoSatisfyWithCloset"))
        return it.available_amount() - it.closet_amount();
    else
        return it.available_amount();
}

int available_amount_including_closet(item it)
{
    if (get_property_boolean("autoSatisfyWithCloset"))
        return it.available_amount();
    else
        return it.available_amount() + it.closet_amount();
}

//Display case, etc
//WARNING: Does not take into account your shop. Conceptually, the shop is things you're getting rid of... and they might be gone already.
int item_amount_almost_everywhere(item it)
{
    return it.closet_amount() + it.display_amount() + it.equipped_amount() + it.item_amount() + it.storage_amount();
}

//Similar to item_amount_almost_everywhere, but won't trigger a display case load unless it has to:
boolean haveAtLeastXOfItemEverywhere(item it, int amount)
{
    int total = 0;
    total += it.item_amount();
    if (total >= amount) return true;
    total += it.equipped_amount();
    if (total >= amount) return true;
    total += it.closet_amount();
    if (total >= amount) return true;
    total += it.storage_amount();
    if (total >= amount) return true;
    total += it.display_amount();
    if (total >= amount) return true;
    
    return false;
}

int equipped_amount(boolean [item] items)
{
    int count = 0;
    foreach it in items
    {
        count += it.equipped_amount();
    }
    return count;
}

int [item] creatable_items(boolean [item] items)
{
    int [item] creatable_items;
    foreach it in items
    {
        if (it.creatable_amount() == 0)
            continue;
        creatable_items[it] = it.creatable_amount();
    }
    return creatable_items;
}


item [slot] equipped_items()
{
    item [slot] result;
    foreach s in $slots[]
    {
        item it = s.equipped_item();
        if (it == $item[none])
            continue;
        result[s] = it;
    }
    return result;
}

//Have at least one of these familiars:
boolean have_familiar_replacement(boolean [familiar] familiars)
{
    foreach f in familiars
    {
        if (f.have_familiar())
            return true;
    }
    return false;
}


string format_today_to_string(string desired_format)
{
    return format_date_time("yyyyMMdd", today_to_string(), desired_format);
}

item [int] missing_outfit_components(string outfit_name)
{
    item [int] outfit_pieces = outfit_pieces(outfit_name);
    item [int] missing_components;
    foreach key in outfit_pieces
    {
        item it = outfit_pieces[key];
        if (it.available_amount() == 0)
            missing_components.listAppend(it);
    }
    return missing_components;
}

//have_outfit() will tell you if you have an outfit, but only if you pass stat checks. This does not stat check:
boolean have_outfit_components(string outfit_name)
{
    return (outfit_name.missing_outfit_components().count() == 0);
}


string [int] __int_to_wordy_map;
string int_to_wordy(int v) //Not complete, only supports a handful:
{
    if (__int_to_wordy_map.count() == 0)
    {
        __int_to_wordy_map = split_string("zero,one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,nineteen,twenty,twenty-one,twenty-two,twenty-three,twenty-four,twenty-five,twenty-six,twenty-seven,twenty-eight,twenty-nine,thirty,thirty-one", ",");
    }
    if (__int_to_wordy_map contains v)
        return __int_to_wordy_map[v];
    return v.to_string();
}

//Non-API-related functions:

boolean playerIsLoggedIn()
{
    return !(my_hash().length() == 0 || my_id() == 0);
}

int substatsForLevel(int level)
{
	if (level == 1)
		return 0;
	return pow2i(pow2i(level - 1) + 4);
}

int availableFullness()
{
	return fullness_limit() - my_fullness();
}

int availableDrunkenness()
{
    if (inebriety_limit() == 0) return 0; //certain edge cases
	return inebriety_limit() - my_inebriety();
}

int availableSpleen()
{
	return spleen_limit() - my_spleen_use();
}

boolean stringHasPrefix(string s, string prefix)
{
	if (s.length() < prefix.length())
		return false;
	else if (s.length() == prefix.length())
		return (s == prefix);
	else if (substring(s, 0, prefix.length()) == prefix)
		return true;
	return false;
}

boolean stringHasSuffix(string s, string suffix)
{
	if (s.length() < suffix.length())
		return false;
	else if (s.length() == suffix.length())
		return (s == suffix);
	else if (substring(s, s.length() - suffix.length()) == suffix)
		return true;
	return false;
}

string capitalizeFirstLetter(string v)
{
	buffer buf = v.to_buffer();
	if (v.length() <= 0)
		return v;
	buf.replace(0, 1, buf.char_at(0).to_upper_case());
	return buf.to_string();
}

item [int] missingComponentsToMakeItemPrivateImplementation(item it, int it_amounted_needed, int recursion_limit_remaining)
{
	item [int] result;
    if (recursion_limit_remaining <= 0) //possible loop
        return result;
	if (it.available_amount() >= it_amounted_needed)
        return result;
	int [item] ingredients = get_ingredients(it);
	if (ingredients.count() == 0)
    {
        for i from 1 to (it_amounted_needed - it.available_amount())
            result.listAppend(it);
    }
	foreach ingredient in ingredients
	{
		int ingredient_amounted_needed = ingredients[ingredient];
		if (ingredient.available_amount() >= ingredient_amounted_needed) //have enough
            continue;
		//split:
		item [int] r = missingComponentsToMakeItemPrivateImplementation(ingredient, ingredient_amounted_needed, recursion_limit_remaining - 1);
        if (r.count() > 0)
        {
            result.listAppendList(r);
        }
	}
	return result;
}

item [int] missingComponentsToMakeItem(item it, int it_amounted_needed)
{
    return missingComponentsToMakeItemPrivateImplementation(it, it_amounted_needed, 30);
}


item [int] missingComponentsToMakeItem(item it)
{
    return missingComponentsToMakeItem(it, 1);
}

//For tracking time deltas. Won't accurately compare across day boundaries and isn't monotonic (be wary of negative deltas), but still useful for temporal rate limiting.
int getMillisecondsOfToday()
{
    //To replicate value in GCLI:
    //ash (now_to_string("H").to_int() * 60 * 60 * 1000 + now_to_string("m").to_int() * 60 * 1000 + now_to_string("s").to_int() * 1000 + now_to_string("S").to_int())
    return now_to_string("H").to_int_silent() * 60 * 60 * 1000 + now_to_string("m").to_int_silent() * 60 * 1000 + now_to_string("s").to_int_silent() * 1000 + now_to_string("S").to_int_silent();
}

//WARNING: Only accurate for up to five turns.
//It also will not work properly in certain areas, and possibly across day boundaries. Actually, it's kind of a hack.
//But now we have turns_spent so no need to worry.
int combatTurnsAttemptedInLocation(location place)
{
    int count = 0;
    if (place.combat_queue.length() > 0)
        count += place.combat_queue.split_string_alternate("; ").count();
    return count;
}

int noncombatTurnsAttemptedInLocation(location place)
{
    int count = 0;
    if (place.noncombat_queue.length() > 0)
        count += place.noncombat_queue.split_string_alternate("; ").count();
    return count;
}

int turnsAttemptedInLocation(location place)
{
    return place.turns_spent;
}

int turnsAttemptedInLocation(boolean [location] places)
{
    int count = 0;
    foreach place in places
        count += place.turnsAttemptedInLocation();
    return count;
}

string [int] locationSeenNoncombats(location place)
{
    return place.noncombat_queue.split_string_alternate("; ");
}

string [int] locationSeenCombats(location place)
{
    return place.combat_queue.split_string_alternate("; ");
}

string lastNoncombatInLocation(location place)
{
    if (place.noncombat_queue.length() > 0)
        return place.locationSeenNoncombats().listLastObject();
    return "";
}

string lastCombatInLocation(location place)
{
    if (place.noncombat_queue.length() > 0)
        return place.locationSeenCombats().listLastObject();
    return "";
}

int totalDelayForLocation(location place)
{
    int [location] place_delays;
    place_delays[$location[the spooky forest]] = 5;
    place_delays[$location[the haunted bedroom]] = 6; //a guess from spading
    place_delays[$location[the boss bat's lair]] = 4;
    place_delays[$location[the oasis]] = 5;
    place_delays[$location[the hidden park]] = 5;
    place_delays[$location[the haunted gallery]] = 5; //FIXME this is a guess, spade
    place_delays[$location[the haunted bathroom]] = 5;
    place_delays[$location[the haunted ballroom]] = 5; //FIXME rumored
    place_delays[$location[the penultimate fantasy airship]] = 25;
    //the haunted billiards room does not contain delay
    //yojimbos_law saw it on turn two on 2014-7-14, immediately after seeing the pool cue adventure, as have I
    //also failure at 16 skill
    //place_delays[$location[the haunted everyroominthemanor]] = 5;
    
    if (place_delays contains place)
        return place_delays[place];
    return -1;
}

int delayRemainingInLocation(location place)
{
    int delay_for_place = place.totalDelayForLocation();
    
    if (delay_for_place == -1)
        return -1;
    
    int turns_attempted = place.turns_spent;
        
    return MAX(0, delay_for_place - turns_attempted);
}

int turnsCompletedInLocation(location place)
{
    return place.turnsAttemptedInLocation(); //FIXME make this correct
}

string pluralize(float value, string non_plural, string plural)
{
	if (value == 1.0)
		return value + " " + non_plural;
	else
		return value + " " + plural;
}

string pluralize(int value, string non_plural, string plural)
{
	if (value == 1)
		return value + " " + non_plural;
	else
		return value + " " + plural;
}

string pluralize(int value, item i)
{
	return pluralize(value, i.to_string(), i.plural);
}

string pluralize(item i) //whatever we have around
{
	return pluralize(i.available_amount(), i);
}

string pluralize(effect e)
{
    return pluralize(e.have_effect(), "turn", "turns") + " of " + e;
}

string pluralizeWordy(int value, string non_plural, string plural)
{
	if (value == 1)
    {
        if (non_plural == "more time") //we're gonna celebrate
            return "One More Time";
        else if (non_plural == "more turn")
            return "One More Turn";
		return value.int_to_wordy() + " " + non_plural;
    }
	else
		return value.int_to_wordy() + " " + plural;
}

string pluralizeWordy(int value, item i)
{
	return pluralizeWordy(value, i.to_string(), i.plural);
}

string pluralizeWordy(item i) //whatever we have around
{
	return pluralizeWordy(i.available_amount(), i);
}

//Backwards compatibility:
//We want to be able to support new content with daily builds. But, we don't want to ask users to run a daily build.
//So these act as replacements for new content. Unknown lookups are given as $type[none] The goal is to have compatibility with the last major release.
//We use this instead of to_item() conversion functions, so we can easily identify them in the source.
item lookupItem(string name)
{
    return name.to_item();
}

boolean [item] lookupItems(string names) //CSV input
{
    boolean [item] result;
    string [int] item_names = split_string_alternate(names, ",");
    foreach key in item_names
    {
        item it = item_names[key].to_item();
        if (it == $item[none])
            continue;
        result[it] = true;
    }
    return result;
}

boolean [item] lookupItemsArray(boolean [string] names)
{
    boolean [item] result;
    
    foreach item_name in names
    {
        item it = item_name.to_item();
        if (it == $item[none])
            continue;
        result[it] = true;
    }
    return result;
}

skill lookupSkill(string name)
{
    return name.to_skill();
}

boolean [skill] lookupSkills(string names) //CSV input
{
    boolean [skill] result;
    string [int] skill_names = split_string_alternate(names, ",");
    foreach key in skill_names
    {
        skill s = skill_names[key].to_skill();
        if (s == $skill[none])
            continue;
        result[s] = true;
    }
    return result;
}


//lookupSkills(string) will be called instead if we keep the same name, so use a different name:
boolean [skill] lookupSkillsInt(boolean [int] skill_ids)
{
    boolean [skill] result;
    foreach skill_id in skill_ids
    {
        skill s = skill_id.to_skill();
        if (s == $skill[none])
            continue;
        result[s] = true;
    }
    return result;
}

effect lookupEffect(string name)
{
    return name.to_effect();
}

familiar lookupFamiliar(string name)
{
    return name.to_familiar();
}

location lookupLocation(string name)
{
    return name.to_location();
}

boolean [location] lookupLocations(string names_string)
{
    boolean [location] result;
    
    string [int] names = names_string.split_string();
    foreach key, name in names
    {
        if (name.length() == 0)
            continue;
        location l = name.to_location();
        if (l != $location[none])
            result[l] = true;
    }
    
    return result;
}

monster lookupMonster(string name)
{
    return name.to_monster();
}

boolean monsterDropsItem(monster m, item it)
{
	//record [int] drops = m.item_drops_array();
	foreach key in m.item_drops_array()
	{
		if (m.item_drops_array()[key].drop == it)
			return true;
	}
	return false;
}


Record StringHandle
{
    string s;
};

Record FloatHandle
{
    float f;
};


buffer generateTurnsToSeeNoncombat(int combat_rate, int noncombats_in_zone, string task, int max_turns_between_nc, int extra_starting_turns)
{
    float turn_estimation = -1.0;
    float noncombat_rate = 1.0 - (combat_rate + combat_rate_modifier()).to_float() / 100.0;
    
    
    if (noncombats_in_zone > 0)
    {
        float minimum_nc_rate = 0.0;
        if (max_turns_between_nc != 0)
            minimum_nc_rate = 1.0 / max_turns_between_nc.to_float();
        if (noncombat_rate < minimum_nc_rate)
            noncombat_rate = minimum_nc_rate;
        
        if (noncombat_rate > 0.0)
            turn_estimation = noncombats_in_zone.to_float() / noncombat_rate;
    }
    else
        turn_estimation = 0.0;
    
    turn_estimation += extra_starting_turns;
    
    
    buffer result;
    
    if (turn_estimation == -1.0)
    {
        result.append("Impossible");
    }
    else
    {
        result.append("~");
        result.append(turn_estimation.roundForOutput(1));
        if (turn_estimation == 1.0)
            result.append(" turn");
        else
            result.append(" turns");
    }
    
    if (task.length() > 0)
    {
        result.append(" to ");
        result.append(task);
    }
    else
    {
        if (turn_estimation == -1.0)
        {
        }
        else if (turn_estimation == 1.0)
            result.append(" remains");
        else
            result.append(" remain");
    }
    if (noncombats_in_zone > 0)
    {
        result.append(" at ");
        result.append(combat_rate_modifier().floor());
        result.append("% combat rate");
    }
    result.append(".");
    
    return result;
}

buffer generateTurnsToSeeNoncombat(int combat_rate, int noncombats_in_zone, string task, int max_turns_between_nc)
{
    return generateTurnsToSeeNoncombat(combat_rate, noncombats_in_zone, task, max_turns_between_nc, 0);
}

buffer generateTurnsToSeeNoncombat(int combat_rate, int noncombats_in_zone, string task)
{
    return generateTurnsToSeeNoncombat(combat_rate, noncombats_in_zone, task, 0);
}


int damageTakenByElement(int base_damage, float elemental_resistance)
{
    if (base_damage < 0)
        return 1;
    
    float effective_base_damage = MAX(30, base_damage).to_float();
    
    return MAX(1, ceil(base_damage.to_float() - effective_base_damage * elemental_resistance));
}

int damageTakenByElement(int base_damage, element e)
{
    float elemental_resistance = e.elemental_resistance() / 100.0;
    
    //mafia might already do this for us already, but I haven't checked:
    
    if (e == $element[cold] && $effect[coldform].have_effect() > 0)
        elemental_resistance = 1.0;
    else if (e == $element[hot] && $effect[hotform].have_effect() > 0)
        elemental_resistance = 1.0;
    else if (e == $element[sleaze] && $effect[sleazeform].have_effect() > 0)
        elemental_resistance = 1.0;
    else if (e == $element[spooky] && $effect[spookyform].have_effect() > 0)
        elemental_resistance = 1.0;
    else if (e == $element[stench] && $effect[stenchform].have_effect() > 0)
        elemental_resistance = 1.0;
        
        
    return damageTakenByElement(base_damage, elemental_resistance);
}

boolean locationHasPlant(location l, string plant_name)
{
    string [int] plants_in_place = get_florist_plants()[l];
    foreach key in plants_in_place
    {
        if (plants_in_place[key] == plant_name)
            return true;
    }
    return false;
}

float initiative_modifier_ignoring_plants()
{
    //FIXME strange bug here, investigate
    //seen in cyrpt
    float init = initiative_modifier();
    
    location my_location = my_location();
    if (my_location != $location[none] && (my_location.locationHasPlant("Impatiens") || my_location.locationHasPlant("Shuffle Truffle")))
        init -= 25.0;
    
    return init;
}

float item_drop_modifier_ignoring_plants()
{
    float modifier = item_drop_modifier();
    
    location my_location = my_location();
    if (my_location != $location[none])
    {
        if (my_location.locationHasPlant("Rutabeggar") || my_location.locationHasPlant("Stealing Magnolia"))
            modifier -= 25.0;
        if (my_location.locationHasPlant("Kelptomaniac"))
            modifier -= 40.0;
    }
    return modifier;
}

int monster_level_adjustment_ignoring_plants() //this is unsafe to use in heavy rains
{
    //FIXME strange bug possibly here, investigate
    int ml = monster_level_adjustment();
    
    location my_location = my_location();
    
    if (my_location != $location[none])
    {
        string [3] location_plants = get_florist_plants()[my_location];
        foreach key in location_plants
        {
            string plant = location_plants[key];
            if (plant == "Rabid Dogwood" || plant == "War Lily"  || plant == "Blustery Puffball")
            {
                ml -= 30;
                break;
            }
        }
        
    }
    return ml;
}

int water_level_of_location(location l)
{
    int water_level = 1;
    if (l.recommended_stat >= 40) //FIXME is this threshold spaded?
        water_level += 1;
    if (l.environment == "indoor")
        water_level += 2;
    if (l.environment == "underground" || l == $location[the lower chambers]) //per-location fix
        water_level += 4;
    water_level += numeric_modifier("water level");
    
    water_level = clampi(water_level, 1, 6);
    if (l.environment == "underwater") //or does the water get the rain instead? nobody knows, rain man
        water_level = 0; //the aquaman hates rain man, they have a fight, aquaman wins
    return water_level;
}

float washaway_rate_of_location(location l)
{
    //Calculate washaway chance:
    int current_water_level = l.water_level_of_location();
    
    int washaway_chance = current_water_level * 5;
    if ($item[fishbone catcher's mitt].equipped_amount() > 0)
        washaway_chance -= 15; //GUESS
    
    if ($effect[Fishy Whiskers].have_effect() > 0)
    {
        //washaway_chance -= ?; //needs spading
    }
    return clampNormalf(washaway_chance / 100.0);
}

int monster_level_adjustment_for_location(location l)
{
    int ml = monster_level_adjustment_ignoring_plants();
    
    if (l.locationHasPlant("Rabid Dogwood") || l.locationHasPlant("War Lily") || l.locationHasPlant("Blustery Puffball"))
    {
        ml += 30;
    }
    
    if (my_path_id() == PATH_HEAVY_RAINS)
    {
        //complicated:
        //First, cancel out the my_location() rain:
        int my_location_water_level_ml = monster_level_adjustment() - numeric_modifier("Monster Level");
        ml -= my_location_water_level_ml;
        
        //Now, calculate the water level for the location:
        int water_level = water_level_of_location(l);
        
        //Add that as ML:
        if (!($locations[oil peak,the typical tavern cellar] contains l)) //kind of hacky to put this here, sorry
        {
            ml += water_level * 10;
        }
    }
    
    return ml;
}

float initiative_modifier_for_location(location l)
{
    float base = initiative_modifier_ignoring_plants();
    
    if (l.locationHasPlant("Impatiens") || l.locationHasPlant("Shuffle Truffle"))
        base += 25.0;
    return base;
}

float item_drop_modifier_for_location(location l)
{
    int base = item_drop_modifier_ignoring_plants();
    if (l.locationHasPlant("Rutabeggar") || l.locationHasPlant("Stealing Magnolia"))
        base += 25.0;
    if (l.locationHasPlant("Kelptomaniac"))
        base += 40.0;
    return base;
}

int monsterExtraInitForML(int ml)
{
	if (ml < 21)
		return 0.0;
	else if (ml < 41)
		return 0.0 + 1.0 * (ml - 20.0);
	else if (ml < 61)
		return 20.0 + 2.0 * (ml - 40.0);
	else if (ml < 81)
		return 60.0 + 3.0 * (ml - 60.0);
	else if (ml < 101)
		return 120.0 + 4.0 * (ml - 80.0);
	else
		return 200.0 + 5.0 * (ml - 100.0);
}

int stringCountSubstringMatches(string str, string substring)
{
    int count = 0;
    int position = 0;
    int breakout = 100;
    int str_length = str.length(); //uncertain whether this is a constant time operation
    while (breakout > 0 && position + 1 < str_length)
    {
        position = str.index_of(substring, position + 1);
        if (position != -1)
            count += 1;
        else
            break;
        breakout -= 1;
    }
    return count;
}

effect to_effect(item it)
{
	return effect_modifier(it, "effect");
}



boolean weapon_is_club(item it)
{
    if (it.to_slot() != $slot[weapon]) return false;
    if (it.item_type() == "club")
        return true;
    if (it.item_type() == "sword" && $effect[Iron Palms].have_effect() > 0)
        return true;
    return false;
}

buffer prepend(buffer in_buffer, buffer value)
{
    buffer result;
    result.append(value);
    result.append(in_buffer);
    in_buffer.set_length(0);
    in_buffer.append(result);
    return result;
}

buffer prepend(buffer in_buffer, string value)
{
    return prepend(in_buffer, value.to_buffer());
}

float pressurePenaltyForLocation(location l, Error could_get_value)
{
    float pressure_penalty = 0.0;
    
    if (my_location() != l)
    {
        ErrorSet(could_get_value);
        return -1.0;
    }
    
    pressure_penalty = MAX(0, -numeric_modifier("item drop penalty"));
    return pressure_penalty;
}

int XiblaxianHoloWristPuterTurnsUntilNextItem()
{
    int drops = get_property_int("_holoWristDrops");
    int progress = get_property_int("_holoWristProgress");
    
    //_holoWristProgress resets when drop happens
    if (!mafiaIsPastRevision(15148))
        return -1;
    int next_turn_hit = 5 * (drops + 1) + 6;
    if (!mafiaIsPastRevision(15493)) //old behaviour
    {
        if (drops != 0)
            next_turn_hit += 1;
    }
    return MAX(0, next_turn_hit - progress);
}

int ka_dropped(monster m)
{
    if (m.phylum == $phylum[dude] || m.phylum == $phylum[hobo] || m.phylum == $phylum[hippy] || m.phylum == $phylum[pirate])
        return 2;
    if (m.phylum == $phylum[goblin] || m.phylum == $phylum[humanoid] || m.phylum == $phylum[beast] || m.phylum == $phylum[bug] || m.phylum == $phylum[orc] || m.phylum == $phylum[elemental] || m.phylum == $phylum[elf] || m.phylum == $phylum[penguin])
        return 1;
    return 0;
}


boolean is_underwater_familiar(familiar f)
{
    return $familiars[Barrrnacle,Emo Squid,Cuddlefish,Imitation Crab,Magic Dragonfish,Midget Clownfish,Rock Lobster,Urchin Urchin,Grouper Groupie,Squamous Gibberer,Dancing Frog,Adorable Space Buddy] contains f;
}