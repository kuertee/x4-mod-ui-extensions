-- section == cArch_configureships
-- param == { 0, 0, container, mode, modeparam, immediate }

-- modes:	"purchase",	param:	{}
--			"upgrade",			{ selectableships }
--			"modify",			{ [ paintonly = false, selectedships = {} ] }
--			"customgamestart",	{ gamestartid, creative, shipproperty, shiploadoutproperty, shippeopleproperty, shippeoplefillpercentageproperty, shippilotproperty, paintthemeproperty, playerpropertyid, propertymacro, propertycommander, propertypeopledef, propertypeoplefillpercentage }
--			"comparison",		{ id }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef int32_t BlacklistID;
	typedef uint64_t BuildTaskID;
	typedef int32_t FightRuleID;
	typedef uint64_t NPCSeed;
	typedef uint64_t UniverseID;
	typedef struct {
		const char* id;
		uint32_t textid;
		uint32_t descriptionid;
		uint32_t value;
		uint32_t relevance;
		const char* ware;
	} SkillInfo;
	typedef struct {
		const char* ammomacroname;
		const char* weaponmode;
	} UILoadoutWeaponSetting;

	typedef struct {
		const char* macro;
		const char* ware;
		uint32_t amount;
		uint32_t capacity;
	} AmmoData;
	typedef struct {
		BlacklistID id;
		const char* type;
	} BlacklistTypeID;
	typedef struct {
		BuildTaskID id;
		UniverseID buildingcontainer;
		UniverseID component;
		const char* macro;
		const char* factionid;
		UniverseID buildercomponent;
		int64_t price;
		bool ismissingresources;
		uint32_t queueposition;
	} BuildTaskInfo;
	typedef struct {
		const char* newroleid;
		NPCSeed seed;
		uint32_t amount;
		int64_t price;
	} CrewTransferContainer2;
	typedef struct {
		CrewTransferContainer2* removed;
		uint32_t numremoved;
		CrewTransferContainer2* added;
		uint32_t numadded;
		CrewTransferContainer2* transferred;
		uint32_t numtransferred;
	} CrewTransferInfo2;
	typedef struct {
		uint32_t numremoved;
		uint32_t numadded;
		uint32_t numtransferred;
	} CrewTransferInfoCounts;
	typedef struct {
		const char* state;
		float defaultvalue;
	} CustomGameStartFloatPropertyState;
	typedef struct {
		const char* state;
	} CustomGameStartLoadoutPropertyState;
	typedef struct {
		const char* race;
		const char* tags;
		uint32_t numskills;
		SkillInfo* skills;
	} CustomGameStartPersonEntry;
	typedef struct {
		const char* state;
		const char* defaultvalue;
		const char* options;
	} CustomGameStartStringPropertyState;
	typedef struct {
		const char* tag;
		const char* name;
	} EquipmentCompatibilityInfo;
	typedef struct {
		const char* type;
		const char* ware;
		const char* macro;
		int amount;
	} EquipmentWareInfo;
	typedef struct {
		const char* PropertyType;
		float MinValueFloat;
		float MaxValueFloat;
		uint32_t MinValueUINT;
		uint32_t MaxValueUINT;
		uint32_t BonusMax;
		float BonusChance;
	} EquipmentModInfo;
	typedef struct {
		FightRuleID id;
		const char* type;
	} FightRuleTypeID;
	typedef struct {
		const char* id;
		const char* name;
		int32_t state;
		const char* requiredversion;
		const char* installedversion;
	} InvalidPatchInfo;
	typedef struct {
		const char* name;
		const char* icon;
	} LicenceInfo;
	typedef struct {
		MissionID missionid;
		const char* macroname;
		uint32_t amount;
	} MissionShipDeliveryInfo;
	typedef struct {
		size_t queueidx;
		const char* state;
		const char* statename;
		const char* orderdef;
		size_t actualparams;
		bool enabled;
		bool isinfinite;
		bool issyncpointreached;
		bool istemporder;
	} Order;
	typedef struct {
		const char* id;
		const char* name;
		const char* desc;
	} PeopleDefinitionInfo;
	typedef struct {
		const char* id;
		const char* name;
		const char* desc;
		uint32_t amount;
		uint32_t numtiers;
		bool canhire;
	} PeopleInfo;
	typedef struct {
		const char* id;
		const char* name;
		const char* shortname;
		const char* description;
		const char* icon;
	} RaceInfo;
	typedef struct {
		const char* name;
		int32_t skilllevel;
		uint32_t amount;
	} RoleTierData;
	typedef struct {
		UniverseID context;
		const char* group;
		UniverseID component;
	} ShieldGroup;
	typedef struct {
		const char* max;
		const char* current;
	} SoftwareSlot;
	typedef struct {
		const char* macro;
		const char* ware;
		const char* productionmethodid;
	} UIBlueprint;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
		const char* PropertyType;
		float ForwardThrustFactor;
		float StrafeThrustFactor;
		float RotationThrustFactor;
		float BoostThrustFactor;
		float BoostDurationFactor;
		float BoostAttackTimeFactor;
		float BoostReleaseTimeFactor;
		float BoostChargeTimeFactor;
		float BoostRechargeTimeFactor;
		float TravelThrustFactor;
		float TravelStartThrustFactor;
		float TravelAttackTimeFactor;
		float TravelReleaseTimeFactor;
		float TravelChargeTimeFactor;
	} UIEngineMod;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
	} UIEquipmentMod;
	typedef struct {
		const char* macro;
		uint32_t amount;
		bool optional;
	} UILoadoutAmmoData;
	typedef struct {
		const char* roleid;
		uint32_t count;
		bool optional;
	} UILoadoutCrewData;
	typedef struct {
		const char* macro;
		const char* path;
		const char* group;
		uint32_t count;
		bool optional;
	} UILoadoutGroupData;
	typedef struct {
		const char* macro;
		const char* path;
		const char* group;
		uint32_t count;
		bool optional;
		UILoadoutWeaponSetting weaponsetting;
	} UILoadoutGroupData2;
	typedef struct {
		const char* macro;
		const char* upgradetypename;
		size_t slot;
		bool optional;
	} UILoadoutMacroData;
	typedef struct {
		const char* macro;
		const char* upgradetypename;
		size_t slot;
		bool optional;
		UILoadoutWeaponSetting weaponsetting;
	} UILoadoutMacroData2;
	typedef struct {
		const char* ware;
	} UILoadoutSoftwareData;
	typedef struct {
		const char* macro;
		bool optional;
	} UILoadoutVirtualMacroData;
	typedef struct {
		uint32_t numweapons;
		uint32_t numturrets;
		uint32_t numshields;
		uint32_t numengines;
		uint32_t numturretgroups;
		uint32_t numshieldgroups;
		uint32_t numammo;
		uint32_t numunits;
		uint32_t numsoftware;
		uint32_t numcrew;
	} UILoadoutCounts2;
	typedef struct {
		UILoadoutMacroData* weapons;
		uint32_t numweapons;
		UILoadoutMacroData* turrets;
		uint32_t numturrets;
		UILoadoutMacroData* shields;
		uint32_t numshields;
		UILoadoutMacroData* engines;
		uint32_t numengines;
		UILoadoutGroupData* turretgroups;
		uint32_t numturretgroups;
		UILoadoutGroupData* shieldgroups;
		uint32_t numshieldgroups;
		UILoadoutAmmoData* ammo;
		uint32_t numammo;
		UILoadoutAmmoData* units;
		uint32_t numunits;
		UILoadoutSoftwareData* software;
		uint32_t numsoftware;
		UILoadoutVirtualMacroData thruster;
	} UILoadout;
	typedef struct {
		UILoadoutMacroData2* weapons;
		uint32_t numweapons;
		UILoadoutMacroData2* turrets;
		uint32_t numturrets;
		UILoadoutMacroData2* shields;
		uint32_t numshields;
		UILoadoutMacroData2* engines;
		uint32_t numengines;
		UILoadoutGroupData2* turretgroups;
		uint32_t numturretgroups;
		UILoadoutGroupData2* shieldgroups;
		uint32_t numshieldgroups;
		UILoadoutAmmoData* ammo;
		uint32_t numammo;
		UILoadoutAmmoData* units;
		uint32_t numunits;
		UILoadoutSoftwareData* software;
		uint32_t numsoftware;
		UILoadoutVirtualMacroData thruster;
		uint32_t numcrew;
		UILoadoutCrewData* crew;
		bool hascrewexperience;
	} UILoadout2;
	typedef struct {
		const char* id;
		const char* name;
		const char* iconid;
		bool deleteable;
	} UILoadoutInfo;
	typedef struct {
		const char* upgradetype;
		size_t slot;
	} UILoadoutSlot;
	typedef struct {
		float HullValue;
		float ShieldValue;
		double ShieldDelay;
		float ShieldRate;
		float GroupedShieldValue;
		double GroupedShieldDelay;
		float GroupedShieldRate;
		float BurstDPS;
		float SustainedDPS;
		float TurretBurstDPS;
		float TurretSustainedDPS;
		float GroupedTurretBurstDPS;
		float GroupedTurretSustainedDPS;
		float ForwardSpeed;
		float BoostSpeed;
		float TravelSpeed;
		float YawSpeed;
		float PitchSpeed;
		float RollSpeed;
		float HorizontalStrafeSpeed;
		float VerticalStrafeSpeed;
		float ForwardAcceleration;
		float HorizontalStrafeAcceleration;
		float VerticalStrafeAcceleration;
		uint32_t NumDocksShipMedium;
		uint32_t NumDocksShipSmall;
		uint32_t ShipCapacityMedium;
		uint32_t ShipCapacitySmall;
		uint32_t CrewCapacity;
		uint32_t ContainerCapacity;
		uint32_t SolidCapacity;
		uint32_t LiquidCapacity;
		uint32_t CondensateCapacity;
		uint32_t UnitCapacity;
		uint32_t MissileCapacity;
		uint32_t CountermeasureCapacity;
		uint32_t DeployableCapacity;
		float RadarRange;
	} UILoadoutStatistics4;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
		uint32_t Amount;
	} UIPaintMod;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
		const char* PropertyType;
		float CapacityFactor;
		float RechargeDelayFactor;
		float RechargeRateFactor;
	} UIShieldMod;
	typedef struct {
		const char* ware;
		const char* macro;
		int amount;
	} UIWareInfo;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
		const char* PropertyType;
		float DamageFactor;
		float CoolingFactor;
		float ReloadFactor;
		float SpeedFactor;
		float LifeTimeFactor;
		float MiningFactor;
		float StickTimeFactor;
		float ChargeTimeFactor;
		float BeamLengthFactor;
		uint32_t AddedAmount;
		float RotationSpeedFactor;
		float SurfaceElementFactor;
	} UIWeaponMod;
	typedef struct {
		const char* macro;
		const char* category;
		uint32_t amount;
	} UnitData;
	typedef struct {
		const char* path;
		const char* group;
	} UpgradeGroup;
	typedef struct {
		UniverseID currentcomponent;
		const char* currentmacro;
		const char* slotsize;
		uint32_t count;
		uint32_t operational;
		uint32_t total;
	} UpgradeGroupInfo;
	typedef struct {
		uint32_t current;
		uint32_t capacity;
		uint32_t optimal;
		uint32_t available;
		uint32_t maxavailable;
		double timeuntilnextupdate;
	} WorkForceInfo;
	typedef struct {
		UniverseID shipid;
		const char* macroname;
		UILoadout loadout;
		uint32_t amount;
	} UIBuildOrderList;
	typedef struct {
		BlacklistTypeID* blacklists;
		uint32_t numblacklists;
		FightRuleTypeID* fightrules;
		uint32_t numfightrules;
	} AddBuildTask5Container;
	BuildTaskID AddBuildTask4(UniverseID containerid, UniverseID defensibleid, const char* macroname, UILoadout2 uiloadout, int64_t price, CrewTransferInfo2 crewtransfer, bool immediate, const char* customname);
	BuildTaskID AddBuildTask5(UniverseID containerid, UniverseID defensibleid, const char* macroname, UILoadout2 uiloadout, int64_t price, CrewTransferInfo2 crewtransfer, bool immediate, const char* customname, AddBuildTask5Container* additionalinfo);
	bool CanApplyKnownLoadout(const char* macroname, const char* loadoutid);
	bool CanBuildLoadout(UniverseID containerid, UniverseID defensibleid, const char* macroname, const char* loadoutid);
	bool CanBuildMissionLoadout(UniverseID containerid, MissionID missionid, const char* uimacroname);
	bool CanContainerEquipShip(UniverseID containerid, UniverseID shipid);
	bool CanContainerSupplyShip(UniverseID containerid, UniverseID shipid);
	bool CanGenerateValidKnownLoadout(const char* macroname);
	bool CanGenerateValidLoadout(UniverseID containerid, const char* macroname);
	bool CanPlayerUseRace(const char* raceid, const char* postid);
	bool CheckGroupedShieldModCompatibility(UniverseID defensibleid, UniverseID contextid, const char* group, const char* wareid);
	bool CheckShipModCompatibility(UniverseID shipid, const char* wareid);
	bool CheckWeaponModCompatibility(UniverseID weaponid, const char* wareid);
	void ClearMapBehaviour(UniverseID holomapid);
	void ClearSelectedMapMacroSlots(UniverseID holomapid);
	const char* ConvertInputString(const char* text, const char* defaultvalue);
	uint32_t CreateOrder(UniverseID controllableid, const char* orderid, bool defaultorder);
	void DismantleEngineMod(UniverseID objectid);
	void DismantleGroupedWeaponMod(UniverseID defensibleid, UniverseID contextid, const char* group);
	void DismantleShieldMod(UniverseID defensibleid, UniverseID contextid, const char* group);
	void DismantleShipMod(UniverseID shipid);
	void DismantleWeaponMod(UniverseID weaponid);
	bool EnableOrder(UniverseID controllableid, size_t idx);
	EquipmentModInfo GetEquipmentModInfo(const char* wareid);
	void GenerateShipKnownLoadout2(UILoadout2* result, const char* macroname, float level);
	void GenerateShipKnownLoadoutCounts2(UILoadoutCounts2* result, const char* macroname, float level);
	void GenerateShipLoadout2(UILoadout2* result, UniverseID containerid, UniverseID shipid, const char* macroname, float level);
	void GenerateShipLoadoutCounts2(UILoadoutCounts2* result, UniverseID containerid, UniverseID shipid, const char* macroname, float level);
	uint32_t GetAllCountermeasures(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllEquipment(EquipmentWareInfo* result, uint32_t resultlen, bool playerblueprint);
	uint32_t GetAllLaserTowers(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllMines(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllMissiles(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllRaces(RaceInfo* result, uint32_t resultlen);
	uint32_t GetAllRoles(PeopleInfo* result, uint32_t resultlen);
	uint32_t GetAllNavBeacons(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllResourceProbes(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllSatellites(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllShipMacros2(const char** result, uint32_t resultlen, bool playerblueprint, bool customgamestart);
	uint32_t GetAllUnits(UnitData* result, uint32_t resultlen, UniverseID defensibleid, bool onlydrones);
	uint32_t GetAvailableEquipment(EquipmentWareInfo* result, uint32_t resultlen, UniverseID containerid, const char* classid);
	uint32_t GetAvailableEquipmentMods(UIEquipmentMod* result, uint32_t resultlen);
	uint32_t GetBlueprints(UIBlueprint* result, uint32_t resultlen, const char* set, const char* category, const char* macroname);
	double GetBuildDuration(UniverseID containerid, UIBuildOrderList order);
	double GetBuildProcessorEstimatedTimeLeft(UniverseID buildprocessorid);
	uint32_t GetBuildResources(UIWareInfo* result, uint32_t resultlen, UniverseID containerid, UniverseID defensibleid, const char* macroname, const char* wareid);
	void GetBuildTaskCrewTransferInfo2(CrewTransferInfo2* result, UniverseID containerid, BuildTaskID id);
	BuildTaskInfo GetBuildTaskInfo(BuildTaskID id);
	uint32_t GetBuildTasks(BuildTaskInfo* result, uint32_t resultlen, UniverseID containerid, UniverseID buildmoduleid, bool isinprogress, bool includeupgrade);
	int64_t GetBuildWarePrice(UniverseID containerid, const char* warename);
	const char* GetComponentClass(UniverseID componentid);
	const char* GetComponentName(UniverseID componentid);
	uint32_t GetContainerBuilderMacros(const char** result, uint32_t resultlen, UniverseID containerid);
	float GetContainerBuildPriceFactor(UniverseID containerid);
	UILoadoutStatistics4 GetCurrentLoadoutStatistics4(UniverseID shipid);
	float GetCustomGameStartFloatProperty(const char* id, const char* propertyid, CustomGameStartFloatPropertyState* state);
	void GetCustomGameStartLoadoutProperty2(UILoadout2* result, const char* id, const char* propertyid);
	void GetCustomGameStartLoadoutPropertyCounts2(UILoadoutCounts2* result, const char* id, const char* propertyid);
	CustomGameStartLoadoutPropertyState GetCustomGameStartLoadoutPropertyState(const char* id, const char* propertyid);
	void GetCustomGameStartPlayerPropertyLoadout(UILoadout2* result, const char* id, const char* propertyid, const char* entryid);
	void GetCustomGameStartPlayerPropertyLoadoutCounts(UILoadoutCounts2* result, const char* id, const char* propertyid, const char* entryid);
	bool GetCustomGameStartPlayerPropertyPerson(CustomGameStartPersonEntry* result, const char* id, const char* propertyid, const char* entryid);
	int64_t GetCustomGameStartShipPeopleValue2(const char* id, const char* macroname, const char* peopledefid, float peoplefillpercentage);
	int64_t GetCustomGameStartShipPersonValue(const char* id, CustomGameStartPersonEntry uivalue);
	bool GetCustomGameStartShipPilot(CustomGameStartPersonEntry* result, const char* id, const char* propertyid);
	const char* GetCustomGameStartStringProperty(const char* id, const char* propertyid, CustomGameStartStringPropertyState* state);
	uint32_t GetDamagedSubComponents(UniverseID* result, uint32_t resultlen, UniverseID objectid);
	uint32_t GetDefaultLoadoutMacros(const char** result, uint32_t resultlen, const char* macroname);
	uint32_t GetDefaultMissileStorageCapacity(const char* macroname);
	uint32_t GetDefaultCountermeasureStorageCapacity(const char* macroname);
	uint32_t GetDefensibleDeployableCapacity(UniverseID defensibleid);
	uint32_t GetDockedShips(UniverseID* result, uint32_t resultlen, UniverseID dockingbayorcontainerid, const char* factionid);
	const char* GetEquipmentModPropertyName(const char* wareid);
	bool GetInstalledEngineMod(UniverseID objectid, UIEngineMod* enginemod);
	bool GetInstalledPaintMod(UniverseID objectid, UIPaintMod* paintmod);
	bool GetInstalledShieldMod(UniverseID defensibleid, UniverseID contextid, const char* group, UIShieldMod* shieldmod);
	bool GetInstalledWeaponMod(UniverseID weaponid, UIWeaponMod* weaponmod);
	uint32_t GetInventoryPaintMods(UIPaintMod* result, uint32_t resultlen);
	uint32_t GetLibraryEntryAliases(const char** result, uint32_t resultlen, const char* librarytypeid, const char* id);
	bool GetLicenceInfo(LicenceInfo* result, const char* factionid, const char* licenceid);
	void GetLoadout2(UILoadout2* result, UniverseID defensibleid, const char* macroname, const char* loadoutid);
	uint32_t GetLoadoutCounts2(UILoadoutCounts2* result, UniverseID defensibleid, const char* macroname, const char* loadoutid);
	uint32_t GetLoadoutInvalidPatches(InvalidPatchInfo* result, uint32_t resultlen, UniverseID defensibleid, const char* macroname, const char* loadoutid);
	uint32_t GetLoadoutsInfo(UILoadoutInfo* result, uint32_t resultlen, UniverseID componentid, const char* macroname);
	UILoadoutStatistics4 GetLoadoutStatistics4(UniverseID shipid, const char* macroname, UILoadout uiloadout);
	const char* GetMacroClass(const char* macroname);
	uint32_t GetMacroDeployableCapacity(const char* macroname);
	uint32_t GetMacroMissileCapacity(const char* macroname);
	UILoadoutStatistics4 GetMaxLoadoutStatistics4(UniverseID shipid, const char* macroname);
	uint32_t GetMissileCargo(UIWareInfo* result, uint32_t resultlen, UniverseID containerid);
	uint32_t GetMissingBuildResources(UIWareInfo* result, uint32_t resultlen);
	uint32_t GetMissingLoadoutResources(UIWareInfo* result, uint32_t resultlen);
	void GetMissionLoadout(UILoadout2* result, MissionID missionid, const char* uimacroname);
	void GetMissionLoadoutCounts(UILoadoutCounts2* result, MissionID missionid, const char* uimacroname);
	uint32_t GetNumAllCountermeasures(UniverseID defensibleid);
	uint32_t GetNumAllEquipment(bool playerblueprint);
	uint32_t GetNumAllLaserTowers(UniverseID defensibleid);
	uint32_t GetNumAllMines(UniverseID defensibleid);
	uint32_t GetNumAllMissiles(UniverseID defensibleid);
	uint32_t GetNumAllRoles(void);
	uint32_t GetNumAllNavBeacons(UniverseID defensibleid);
	uint32_t GetNumAllResourceProbes(UniverseID defensibleid);
	uint32_t GetNumAllSatellites(UniverseID defensibleid);
	uint32_t GetNumAllShipMacros2(bool playerblueprint, bool customgamestart);
	uint32_t GetNumAllUnits(UniverseID defensibleid, bool onlydrones);
	uint32_t GetNumAvailableEquipment(UniverseID containerid, const char* classid);
	uint32_t GetNumAvailableEquipmentMods();
	uint32_t GetNumBlacklistTypes(void);
	uint32_t GetNumBuildResources(UniverseID containerid, UniverseID defensibleid, const char* macroname, const char* wareid);
	CrewTransferInfoCounts GetNumBuildTaskCrewTransferInfo(UniverseID containerid, BuildTaskID id);
	uint32_t GetNumBuildTasks(UniverseID containerid, UniverseID buildmoduleid, bool isinprogress, bool includeupgrade);
	uint32_t GetNumContainerBuilderMacros(UniverseID containerid);
	uint32_t GetNumDefaultLoadoutMacros(const char* macroname);
	uint32_t GetNumDockedShips(UniverseID dockingbayorcontainerid, const char* factionid);
	uint32_t GetNumFightRuleTypes(void);
	uint32_t GetNumInventoryPaintMods(void);
	uint32_t GetNumLibraryEntryAliases(const char* librarytypeid, const char* id);
	uint32_t GetNumLoadoutsInfo(UniverseID componentid, const char* macroname);
	uint32_t GetNumMissileCargo(UniverseID containerid);
	uint32_t GetNumMissingBuildResources2(UniverseID containerid, UIBuildOrderList* orders, uint32_t numorders, bool playercase);
	uint32_t GetNumMissingLoadoutResources2(UniverseID containerid, UIBuildOrderList* orders, uint32_t numorders, bool playercase);
	uint32_t GetNumPlayerPeopleDefinitions(void);
	uint32_t GetNumRepairResources2(UniverseID containerid, UniverseID defensibleid, UniverseID componenttorepairid);
	uint32_t GetNumRequestedMissionShips(void);
	uint32_t GetNumShieldGroups(UniverseID defensibleid);
	uint32_t GetNumSkills(void);
	uint32_t GetNumSlotCompatibilities(UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, const char* upgradetypename, size_t slot);
	uint32_t GetNumSoftwarePredecessors(const char* softwarename);
	uint32_t GetNumSoftwareSlots(UniverseID controllableid, const char* macroname);
	uint32_t GetNumSubComponents(UniverseID containerid);
	uint32_t GetNumSuitableBuildProcessors(UniverseID containerid, UniverseID objectid, const char* macroname);
	uint32_t GetNumUnitCargo(UniverseID containerid, bool onlydrones);
	uint32_t GetNumUpgradeGroupCompatibilities(UniverseID destructibleid, const char* macroname, UniverseID contextid, const char* path, const char* group, const char* upgradetypename);
	uint32_t GetNumUpgradeGroups(UniverseID destructibleid, const char* macroname);
	size_t GetNumUpgradeSlots(UniverseID destructibleid, const char* macroname, const char* upgradetypename);
	uint32_t GetNumUsedLimitedShips(void);
	size_t GetNumVirtualUpgradeSlots(UniverseID objectid, const char* macroname, const char* upgradetypename);
	const char* GetObjectIDCode(UniverseID objectid);
	bool GetPaintThemeMod(const char* themeid, const char* factionid, UIPaintMod* paintmod);
	uint32_t GetPeople2(PeopleInfo* result, uint32_t resultlen, UniverseID controllableid, bool includearriving);
	uint32_t GetPeopleCapacity(UniverseID controllableid, const char* macroname, bool includecrew);
	bool GetPickedMapMacroSlot(UniverseID holomapid, UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, UILoadoutSlot* result);
	UniverseID GetPlayerOccupiedShipID(void);
	const char* GetPlayerPaintTheme(void);
	bool GetPlayerPaintThemeMod(UniverseID objectid, const char* macroname, UIPaintMod* paintmod);
	uint32_t GetPlayerPeopleDefinitions(PeopleDefinitionInfo* result, uint32_t resultlen);
	uint32_t GetPurchasableCargo(UniverseID containerid, const char*);
	int64_t GetRepairPrice(UniverseID componenttorepairid, UniverseID containerid);
	uint32_t GetRepairResources2(UIWareInfo* result, uint32_t resultlen, UniverseID containerid, UniverseID defensibleid, UniverseID componenttorepairid);
	uint32_t GetRequestedMissionShips(MissionShipDeliveryInfo* result, uint32_t resultlen);
	uint32_t GetRoleTierNPCs(NPCSeed* result, uint32_t resultlen, UniverseID controllableid, const char* role, int32_t skilllevel);
	uint32_t GetRoleTiers(RoleTierData* result, uint32_t resultlen, UniverseID controllableid, const char* role);
	bool GetShieldGroup(ShieldGroup* result, UniverseID defensibleid, UniverseID destructibleid);
	uint32_t GetShieldGroups(ShieldGroup* result, uint32_t resultlen, UniverseID defensibleid);
	int64_t GetShipValue(const char* macroname, UILoadout2 uiloadout);
	uint32_t GetSkills(SkillInfo* result, uint32_t resultlen);
	uint32_t GetSlotCompatibilities(EquipmentCompatibilityInfo* result, uint32_t resultlen, UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, const char* upgradetypename, size_t slot);
	const char* GetSlotSize(UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, const char* upgradetypename, size_t slot);
	const char* GetSoftwareMaxCompatibleVersion(UniverseID controllableid, const char* macroname, const char* softwarename);
	uint32_t GetSoftwarePredecessors(const char** result, uint32_t resultlen, const char* softwarename);
	uint32_t GetSoftwareSlots(SoftwareSlot* result, uint32_t resultlen, UniverseID controllableid, const char* macroname);
	uint32_t GetUnitCargo(UIWareInfo* result, uint32_t resultlen, UniverseID containerid, bool onlydrones);
	uint32_t GetUpgradeGroupCompatibilities(EquipmentCompatibilityInfo* result, uint32_t resultlen, UniverseID destructibleid, const char* macroname, UniverseID contextid, const char* path, const char* group, const char* upgradetypename);
	UpgradeGroupInfo GetUpgradeGroupInfo(UniverseID destructibleid, const char* macroname, const char* path, const char* group, const char* upgradetypename);
	UpgradeGroupInfo GetUpgradeGroupInfo2(UniverseID destructibleid, const char* macroname, UniverseID contextid, const char* path, const char* group, const char* upgradetypename);
	uint32_t GetUpgradeGroups(UpgradeGroup* result, uint32_t resultlen, UniverseID destructibleid, const char* macroname);
	const char* GetUpgradeSlotCurrentMacro(UniverseID objectid, UniverseID moduleid, const char* upgradetypename, size_t slot);
	UniverseID GetUpgradeSlotCurrentComponent(UniverseID destructibleid, const char* upgradetypename, size_t slot);
	UpgradeGroup GetUpgradeSlotGroup(UniverseID destructibleid, const char* macroname, const char* upgradetypename, size_t slot);
	uint32_t GetUsedLimitedShips(UIMacroCount* result, uint32_t resultlen);
	const char* GetVirtualUpgradeSlotCurrentMacro(UniverseID defensibleid, const char* upgradetypename, size_t slot);
	WorkForceInfo GetWorkForceInfo(UniverseID containerid, const char* raceid);
	bool HasDefaultLoadout2(const char* macroname, bool allowloadoutoverride);
	bool HasResearched(const char* wareid);
	bool HasSuitableBuildModule(UniverseID containerid, UniverseID defensibleid, const char* macroname);
	bool IsNextStartAnimationSkipped(bool reset);
	bool InstallEngineMod(UniverseID objectid, const char* wareid);
	bool InstallGroupedWeaponMod(UniverseID defensibleid, UniverseID contextid, const char* group, const char* wareid);
	bool InstallPaintMod(UniverseID objectid, const char* wareid, bool useinventory);
	bool InstallShieldMod(UniverseID defensibleid, UniverseID contextid, const char* group, const char* wareid);
	bool InstallShipMod(UniverseID shipid, const char* wareid);
	bool InstallWeaponMod(UniverseID weaponid, const char* wareid);
	bool IsAmmoMacroCompatible(const char* weaponmacroname, const char* ammomacroname);
	bool IsDeployableMacroCompatible(UniverseID containerid, const char* macroname, const char* deployablemacroname);
	bool IsLoadoutCompatible(const char* macroname, const char* loadoutid);
	bool IsLoadoutValid(UniverseID defensibleid, const char* macroname, const char* loadoutid, uint32_t* numinvalidpatches);
	bool IsSlotMandatory(UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, const char* upgradetypename, size_t slot);
	bool IsSoftwareDefault(UniverseID controllableid, const char* macroname, const char* softwarename);
	bool IsUnitMacroCompatible(UniverseID containerid, const char* macroname, const char* unitmacroname);
	bool IsUpgradeMacroCompatible(UniverseID objectid, UniverseID moduleid, const char* macroname, bool ismodule, const char* upgradetypename, size_t slot, const char* upgrademacroname);
	bool IsVirtualUpgradeMacroCompatible(UniverseID defensibleid, const char* macroname, const char* upgradetypename, size_t slot, const char* upgrademacroname);
	bool RemoveLoadout(const char* source, const char* macroname, const char* localid);
	void SaveLoadout2(const char* macroname, UILoadout2 uiloadout, const char* source, const char* id, bool overwrite, const char* name, const char* desc);
	void SetBuildTaskTransferredMoney(BuildTaskID id, int64_t value);
	void SetCustomGameStartFloatProperty(const char* id, const char* propertyid, float uivalue);
	const char* SetCustomGameStartPlayerPropertyMacroAndLoadout2(const char* id, const char* propertyid, const char* entryid, const char* commanderid, const char* macroname, UILoadout2 uiloadout);
	void SetCustomGameStartPlayerPropertyPeople(const char* id, const char* propertyid, const char* entryid, const char* peopledefid);
	void SetCustomGameStartPlayerPropertyPeopleFillPercentage2(const char* id, const char* propertyid, const char* entryid, float fillpercentage);
	void SetCustomGameStartPlayerPropertyPerson(const char* id, const char* propertyid, const char* entryid, CustomGameStartPersonEntry uivalue);
	void SetCustomGameStartShipAndLoadoutProperty2(const char* id, const char* shippropertyid, const char* loadoutpropertyid, const char* macroname, UILoadout2 uiloadout);
	void SetCustomGameStartShipPilot(const char* id, const char* propertyid, CustomGameStartPersonEntry uivalue);
	void SetCustomGameStartStringProperty(const char* id, const char* propertyid, const char* uivalue);
	void SetMapPaintMod(UniverseID holomapid, const char* wareid);
	void SetMapPicking(UniverseID holomapid, bool enable);
	void SetPaintModLocked(UniverseID objectid, bool value);
	void SetSelectedMapMacroSlot(UniverseID holomapid, UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, const char* upgradetypename, size_t slot);
	void ShowObjectConfigurationMap2(UniverseID holomapid, UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, UILoadout uiloadout, size_t cp_idx);
	void StartPanMap(UniverseID holomapid);
	void StartRotateMap(UniverseID holomapid);
	bool StopPanMap(UniverseID holomapid);
	bool StopRotateMap(UniverseID holomapid);
	void UpdateObjectConfigurationMap(UniverseID holomapid, UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, UILoadout uiloadout);
]]

local utf8 = require("utf8")

local menu = {
	name = "ShipConfigurationMenu",
	currentIdx = 0,
	expandedModSlots = {},
	expandedUpgrades = {},
	captainSelected = true,
	undoStack = {},
	undoIndex = 1,
	showStats = true,
	customgamestartpeopledef = "",
	equipmentfilter_races = {},
	equipmentfilter_races_y = 0,
	equipmentsearch_editboxrow = 0,
	allownonplayerblueprints = false,
}

local config = {
	mainLayer = 5,
	infoLayer = 4,
	contextLayer = 2,
	classorder = { "ship_xl", "ship_l", "ship_m", "ship_s", "ship_xs" },
	leftBar = {
		{ name = ReadText(1001, 1103),	icon = "shipbuildst_engine",		mode = "engine",		iscapship = false },
		{ name = ReadText(1001, 8520),	icon = "shipbuildst_enginegroups",	mode = "enginegroup",	iscapship = true },
		{ name = ReadText(1001, 8001),	icon = "shipbuildst_thruster",		mode = "thruster" },
		{ name = ReadText(1001, 1317),	icon = "shipbuildst_shield",		mode = "shield" },
		{ name = ReadText(1001, 2663),	icon = "shipbuildst_weapon",		mode = "weapon" },
		{ name = ReadText(1001, 1319),	icon = "shipbuildst_turret",		mode = "turret",		iscapship = false },
		{ name = ReadText(1001, 7901),	icon = "shipbuildst_turretgroups",	mode = "turretgroup",	iscapship = true },
		{ name = ReadText(1001, 87),	icon = "shipbuildst_software",		mode = "software" },
		{ spacing = true,																			comparison = false },
		{ name = ReadText(1001, 8003),	icon = "shipbuildst_consumable",	mode = "consumables",	comparison = false },
		{ name = ReadText(1001, 80),	icon = "shipbuildst_crew",			mode = "crew",			comparison = false },
		{ spacing = true,																			customgamestart = false,	comparison = false,		hascontainer = true },
		{ name = ReadText(1001, 3000),	icon = "shipbuildst_repair",		mode = "repair",		customgamestart = false,	comparison = false,		hascontainer = true },
		{ spacing = true,																			comparison = false,			hascontainer = true },
		{ name = ReadText(1001, 8549),	icon = "tlt_optionsmenu",			mode = "settings",		comparison = false,			hascontainer = true },
	},
	leftBarMods = {
		{ name = ReadText(1001, 8038),	icon = "shipbuildst_chassis",		mode = "shipmods",		upgrademode = "ship",	modclass = "ship" },
		{ name = ReadText(1001, 6600),	icon = "shipbuildst_weapon",		mode = "weaponmods",	upgrademode = "weapon",	modclass = "weapon" },
		{ name = ReadText(1001, 8004),	icon = "shipbuildst_turret",		mode = "turretmods",	upgrademode = "turret",	modclass = "weapon" },
		{ name = ReadText(1001, 8515),	icon = "shipbuildst_shield",		mode = "shieldmods",	upgrademode = "shield",	modclass = "shield" },
		{ name = ReadText(1001, 8028),	icon = "shipbuildst_engine",		mode = "enginemods",	upgrademode = "engine",	modclass = "engine" },
		{ name = ReadText(1001, 8510),	icon = "shipbuildst_paint",			mode = "paintmods",		upgrademode = "paint",	modclass = "paint" },
	},
	dropDownTextProperties = {
		halign = "center",
		font = Helper.standardFont,
		fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize),
		color = Color["text_normal"],
		x = 0,
		y = 0
	},
	stateKeys = {
		{ "object", "UniverseID" },
		{ "macro" },
		{ "class" },
		{ "upgradetypeMode" },
		{ "currentSlot" },
		{ "upgradeplan" },
		{ "crew" },
		{ "editingshoppinglist" },
		{ "loadoutName" },
		{ "captainSelected", "bool" },
		{ "validLicence", "bool" },
		{ "validLoadoutPossible", "bool" },
		{ "shoppinglist" },
	},
	dropdownRatios = {
		class = 0.7,
		ship = 1.3,
	},
	stats = {
		{ id = "HullValue",					name = ReadText(1001, 8048),	unit = ReadText(1001, 118),	type = "float",		accuracy = 0 },
		{ id = "ShieldValue",				name = ReadText(1001, 8049),	unit = ReadText(1001, 118),	type = "float",		accuracy = 0 },
		{ id = "ShieldRate",				name = "   " .. ReadText(1001, 8553),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0 },
		{ id = "ShieldDelay",				name = "   " .. ReadText(1001, 8554),	unit = ReadText(1001, 100),	type = "double",	accuracy = 2,	inverted = true },
		{ id = "GroupedShieldValue",		name = ReadText(1001, 8533),	unit = ReadText(1001, 118),	type = "float",		accuracy = 0,	mouseovertext = ReadText(1026, 8018) },
		{ id = "GroupedShieldRate",			name = "   " .. ReadText(1001, 8553),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0 },
		{ id = "GroupedShieldDelay",		name = "   " .. ReadText(1001, 8554),	unit = ReadText(1001, 100),	type = "double",	accuracy = 2,	inverted = true },
		{ id = "RadarRange",				name = ReadText(1001, 8068),	unit = ReadText(1001, 108),	type = "float",		accuracy = 0 },
		{ id = "BurstDPS",					name = ReadText(1001, 8073),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0 },
		{ id = "SustainedDPS",				name = ReadText(1001, 8074),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0 },
		{ id = "TurretSustainedDPS",		name = ReadText(1001, 8532),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0,	mouseovertext = ReadText(1026, 8017),	capshipid = "GroupedTurretSustainedDPS" },
		{ id = "" },
		{ id = "CrewCapacity",				name = ReadText(1001, 8057),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "UnitCapacity",				name = ReadText(1001, 8061),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "MissileCapacity",			name = ReadText(1001, 8062),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "DeployableCapacity",		name = ReadText(1001, 8064),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "CountermeasureCapacity",	name = ReadText(1001, 8063),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "" },
		{ id = "" },
		-- new column
		{ id = "ForwardSpeed",				name = ReadText(1001, 8051),	unit = ReadText(1001, 113),	type = "float",		accuracy = 0 },
		{ id = "ForwardAcceleration",		name = ReadText(1001, 8069),	unit = ReadText(1001, 111),	type = "float",		accuracy = 0 },
		{ id = "BoostSpeed",				name = ReadText(1001, 8052),	unit = ReadText(1001, 113),	type = "float",		accuracy = 0 },
		{ id = "TravelSpeed",				name = ReadText(1001, 8053),	unit = ReadText(1001, 113),	type = "float",		accuracy = 0 },
		{ id = "HorizontalStrafeSpeed",		name = ReadText(1001, 8559),	unit = ReadText(1001, 113),	type = "float",		accuracy = 1 },
		{ id = "HorizontalStrafeAcceleration",	name = ReadText(1001, 8560),	unit = ReadText(1001, 111),	type = "float",		accuracy = 1 },
		{ id = "YawSpeed",					name = ReadText(1001, 8054),	unit = ReadText(1001, 117),	type = "float",		accuracy = 1 },
		{ id = "PitchSpeed",				name = ReadText(1001, 8055),	unit = ReadText(1001, 117),	type = "float",		accuracy = 1 },
		{ id = "RollSpeed",					name = ReadText(1001, 8056),	unit = ReadText(1001, 117),	type = "float",		accuracy = 1 },
		{ id = "" },
		{ id = "ContainerCapacity",			name = ReadText(1001, 8058),	unit = ReadText(1001, 110),	type = "UINT",		accuracy = 0 },
		{ id = "SolidCapacity",				name = ReadText(1001, 8059),	unit = ReadText(1001, 110),	type = "UINT",		accuracy = 0 },
		{ id = "LiquidCapacity",			name = ReadText(1001, 8060),	unit = ReadText(1001, 110),	type = "UINT",		accuracy = 0 },
		{ id = "CondensateCapacity",		name = ReadText(20109, 9801),	unit = ReadText(1001, 110),	type = "UINT",		accuracy = 0 },
		{ id = "" },
		{ id = "NumDocksShipMedium",		name = ReadText(1001, 8524),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "NumDocksShipSmall",			name = ReadText(1001, 8525),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "ShipCapacityMedium",		name = ReadText(1001, 8526),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "ShipCapacitySmall",			name = ReadText(1001, 8527),	unit = "",					type = "UINT",		accuracy = 0 },
	},
	scaleSize = 2,
	deployableOrder = {
		["satellite"]		= 1,
		["navbeacon"]		= 2,
		["resourceprobe"]	= 3,
		["lasertower"]		= 4,
		["mine"]			= 5,
		[""]				= 6,
	},
	maxStatusRowCount = 9,
	comparisonShipLibraries = { "shiptypes_xl", "shiptypes_l", "shiptypes_m", "shiptypes_s" },
	comparisonEquipmentLibraries = {
		{ library = "weapons_lasers",			type = "weapon" },
		{ library = "weapons_missilelaunchers",	type = "weapon" },
		{ library = "weapons_turrets",			type = "turret" },
		{ library = "weapons_missileturrets",	type = "turret" },
		{ library = "shieldgentypes",			type = "shield" },
		{ library = "enginetypes",				type = "engine" },
		{ library = "thrustertypes",			type = "thruster" },
	},
	maxSlotRows = 50,
	undoSteps = 100,
	maxSidePanelWidth = 800,
	maxCenterPanelWidth = 1600,
	compatibilityFontSize = 5,
	equipmentfilter_races_width = 300,
	persistentdataversion = 1,
}

__CORE_DETAILMONITOR_SHIPBUILD = __CORE_DETAILMONITOR_SHIPBUILD or {
	version = config.persistentdataversion,
	["showStats"] = true,
	["showStatsPaintMod"] = false,
}

-- kuertee start:
local callbacks = {}
-- kuertee end

local function init()
	Menus = Menus or {}
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	menu.shoppinglist = {}

	if __CORE_DETAILMONITOR_SHIPBUILD.version < config.persistentdataversion then
		menu.upgradeSettingsVersion()
	end

	-- kuertee start:
	menu.init_kuertee()
	-- kuertee end
end

-- kuertee start:
function menu.init_kuertee ()
	menu.loadModLuas()
	-- DebugError("uix load success: " .. tostring(debug.getinfo(1).source))
end
-- kuertee end

function menu.cleanup()
	menu.isReadOnly = nil
	menu.container = nil
	menu.containerowner = nil
	menu.isplayerowned = nil
	menu.object = nil
	menu.objectgroup = nil
	menu.macro = nil
	menu.class = nil
	menu.upgradewares = {}
	menu.groups = {}
	menu.slots = {}
	menu.ammo = {}
	menu.software = {}
	menu.upgradeplan = {}
	menu.selectableships = {}
	menu.selectableshipsbyclass = {}
	menu.shoppinglist = {}
	menu.shoppinglisttotal = 0
	menu.total = nil
	menu.crewtotal = nil
	menu.activatemap = nil
	menu.editingshoppinglist = nil
	menu.updateMoney = nil
	menu.equipmentsearchtext = {}
	menu.loadoutName = ""
	menu.loadout = nil
	menu.inventory = {}
	menu.modwares = {}
	menu.captainSelected = true
	menu.initialLoadoutStatistics = {}
	menu.currentIdx = 0
	menu.immediate = nil
	menu.installedPaintMod = nil
	menu.selectedPaintMod = nil
	menu.validLicence = nil
	menu.tasks = {}
	menu.contextMode = nil
	menu.validLoadoutPossible = nil
	menu.customshipname = nil
	menu.useloadoutname = nil
	menu.playershipname = nil
	menu.warningShown = nil
	menu.customgamestartpeopledef = ""
	menu.customgamestartpeoplefillpercentage = nil
	menu.customgamestartpilot = {}
	menu.allownonplayerblueprints = false
	menu.clearUndoStack()

	menu.equipmentfilter_races = {}
	menu.equipmentfilter_races_y = 0
	menu.equipmentsearch_editboxrow = 0

	menu.repairplan = {}
	menu.damagedcomponents = {}
	menu.repairslots = {}
	menu.totalrepairprice = nil

	if menu.holomap ~= 0 then
		C.RemoveHoloMap()
		menu.holomap = 0
	end

	menu.frameworkData = {}
	menu.slotData = {}
	menu.planData = {}
	menu.statsData = {}
	menu.titleData = {}
	menu.mapData = {}

	menu.picking = true
	menu.pickstate = nil

	menu.leftbartable = nil
	menu.slottable = nil
	menu.plantable = nil
	menu.titlebartable = nil
	menu.map = nil

	menu.topRows = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	if menu.bindingRegistered then
		UnregisterAddonBindings("ego_detailmonitor", "undo")
		menu.bindingRegistered = nil
	end

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback ()
		end
	end
	-- kuertee end: callback
end

-- button scripts

function menu.isModSlotExpanded(type, slot)
	return menu.expandedModSlots[type .. slot]
end

function menu.expandModSlot(type, slot, row)
	if menu.expandedModSlots[type .. slot] then
		menu.expandedModSlots[type .. slot] = nil
	else
		menu.expandedModSlots[type .. slot] = true
	end

	menu.currentSlot = slot
	menu.selectedRows.slots = row
	menu.refreshMenu()
end

function menu.isUpgradeExpanded(idx, ware, category)
	if ware then
		return menu.expandedUpgrades[idx .. ware .. category]
	end
	return false
end

function menu.expandUpgrade(idx, ware, category, row)
	if menu.expandedUpgrades[idx .. ware .. category] then
		menu.expandedUpgrades[idx .. ware .. category] = nil
	else
		menu.expandedUpgrades[idx .. ware .. category] = true
	end

	menu.topRows.plan = GetTopRow(menu.plantable)
	menu.selectedRows.plan = row
	menu.refreshMenu()
end

function menu.buttonSelectSlot(slot, row, col)
	if menu.currentSlot ~= slot then
		menu.currentSlot = slot
	end

	menu.selectMapMacroSlot()

	menu.topRows.slots = GetTopRow(menu.slottable)
	menu.selectedRows.slots = row
	menu.selectedCols.slots = col
	menu.refreshMenu()
end

function menu.buttonSelectUpgradeMacro(type, slot, macro, row, col, keepcontext, skipvolatilecheck)
	local oldcontextmode = Helper.tableCopy(menu.contextMode)
	if not keepcontext then
		menu.closeContextMenu()
	end

	local upgradetype = Helper.findUpgradeType(type)

	if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
		if macro ~= menu.upgradeplan[type][slot].macro then
			local isvolatile = false
			local currentmacro = menu.upgradeplan[type][slot].macro
			if currentmacro ~= "" then
				local j = menu.findUpgradeMacro(type, currentmacro)
				if j then
					local upgradeware = menu.upgradewares[type][j]
					isvolatile = GetWareData(upgradeware.ware, "volatile")
				end
			end

			if (not skipvolatilecheck) and isvolatile then
				menu.contextData = { mode = "removevolatile", type = type, slot = slot, macro = macro, row = row, col = col }
				menu.displayContextFrame("userquestion", Helper.scaleX(400), (Helper.viewWidth - Helper.scaleX(400)) / 2, Helper.viewHeight / 2)
			else
				if upgradetype.mergeslots then
					for i, slotdata in ipairs(menu.slots[type]) do
						if menu.mode == "upgrade" then
							if slotdata.component then
								menu.removeRepairedComponent(menu.object, slotdata.component)
							end
						end
						menu.upgradeplan[type][i] = { macro = macro, ammomacro = "", weaponmode = "" }
					end
				else
					if menu.mode == "upgrade" then
						if menu.slots[type][slot].component then
							menu.removeRepairedComponent(menu.object, menu.slots[type][slot].component)
						end
					end
					menu.upgradeplan[type][slot] = { macro = macro, ammomacro = "", weaponmode = "" }
				end

				menu.addUndoStep()

				menu.selectedRows.slots = row
				menu.selectedCols.slots = col
				menu.refreshMenu()
			end
		end
	end

	if menu.holomap and (menu.holomap ~= 0) then
		Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.UpdateObjectConfigurationMap(menu.holomap, menu.object, 0, menu.macro, false, loadout) end)
	end

	if keepcontext then
		menu.topRows.context = GetTopRow(menu.contexttable)
		menu.selectedRows.context = keepcontext
		menu.displayContextFrame("slot", oldcontextmode.width, oldcontextmode.x, oldcontextmode.y)
	end
end

function menu.buttonDiscardShoppingListAndEditGroup(group, shipid)
	for i = #menu.shoppinglist, 1, -1 do
		local entry = menu.shoppinglist[i]
		for _, ship in ipairs(menu.shipgroups[group].ships) do
			if ship.ship == entry.object then
				table.remove(menu.shoppinglist, i)
				break
			end
		end
	end
	menu.closeContextMenu()
	menu.dropdownShip(_, shipid)
end

function menu.checkboxSelectCaptain(row)
	menu.captainSelected = true

	menu.addUndoStep()

	menu.selectedRows.slots = row
	menu.refreshMenu()
end

function menu.checkboxSelectSoftware(type, slot, software, row, keepcontext)
	local oldcontextmode = Helper.tableCopy(menu.contextMode)
	if not keepcontext then
		menu.closeContextMenu()
	end

	local upgradetype = Helper.findUpgradeType(type)

	if software ~= menu.upgradeplan[type][slot] then
		AddUITriggeredEvent(menu.name, "software_added", software)
		menu.upgradeplan[type][slot] = software
	else
		AddUITriggeredEvent(menu.name, "software_removed", software)
		if menu.software[type][slot].defaultsoftware ~= 0 then
			menu.upgradeplan[type][slot] = menu.software[type][slot].possiblesoftware[menu.software[type][slot].defaultsoftware]
		else
			menu.upgradeplan[type][slot] = ""
		end
	end

	menu.selectedRows.slots = row
	menu.refreshMenu()

	if keepcontext then
		menu.topRows.context = GetTopRow(menu.contexttable)
		menu.selectedRows.context = keepcontext
		menu.displayContextFrame("slot", oldcontextmode.width, oldcontextmode.x, oldcontextmode.y)
	end
end

function menu.checkboxLoadoutName(_, checked)
	menu.useloadoutname = not menu.useloadoutname
	menu.playershipname = nil
	menu.setCustomShipName()
end

function menu.setCustomShipName()
	if menu.useloadoutname then
		menu.customshipname = menu.getCustomShipName()
	else
		menu.customshipname = menu.playershipname or ""
	end
	if menu.customShipNameEditBox then
		local name = ""
		if menu.object ~= 0 then
			name = ffi.string(C.GetComponentName(menu.object))
		else
			name = GetMacroData(menu.macro, "name")
		end
		C.SetEditBoxText(menu.customShipNameEditBox.id, (menu.customshipname ~= "") and menu.customshipname or name)
	end
end

function menu.getUpgradeTypeText(upgradetype)
	if upgradetype == "turrets" then
		return ReadText(1001, 1319)
	elseif upgradetype == "engines" then
		return ReadText(1001, 1103)
	end

	return ""
end

function menu.getCustomShipName()
	local macroname = ""
	if menu.object ~= 0 then
		macroname = GetMacroData(GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro"), "basename")
	else
		macroname = GetMacroData(menu.macro, "basename")
	end

	return macroname .. " (" .. menu.loadoutName .. ")"
end

function menu.buttonSelectRepair(row, col, objectstring, keepcontext)
	menu.repairplan[objectstring] = menu.repairplan[objectstring] or {}
	if menu.objectgroup then
		for i, ship in ipairs(menu.objectgroup.ships) do
			for j = #menu.objectgroup.shipdata[i].damagedcomponents, 1, -1 do
				if tostring(ship.ship) == objectstring then
					local componentstring = tostring(menu.objectgroup.shipdata[i].damagedcomponents[j])
					if menu.repairplan[objectstring][componentstring] then
						menu.repairplan[objectstring][componentstring] = nil
					else
						menu.repairplan[objectstring][componentstring] = true
					end
				end
			end
		end
	else
		for i = #menu.damagedcomponents, 1, -1 do
			local componentstring = tostring(menu.damagedcomponents[i])
			if menu.repairplan[objectstring][componentstring] then
				menu.repairplan[objectstring][componentstring] = nil
			else
				menu.repairplan[objectstring][componentstring] = true
			end
		end
	end

	menu.addUndoStep()

	menu.selectedRows.slots = row
	menu.selectedCols.slots = col
	menu.refreshMenu()
end

function menu.removeRepairedComponent(object, component)
	local objectstring = tostring(object)
	local componentstring = tostring(component)

	if menu.repairplan[objectstring] then
		menu.repairplan[objectstring][componentstring] = nil
	end
end

function menu.buttonSelectGroupUpgrade(type, group, macro, row, col, keepcontext)
	local oldcontextmode = Helper.tableCopy(menu.contextMode)
	if not keepcontext then
		menu.closeContextMenu()
	end

	local upgradetype = Helper.findUpgradeType(type)

	if (upgradetype.supertype == "group") then
		if macro ~= menu.upgradeplan[type][group].macro then
			for i, slotdata in ipairs(menu.slots[upgradetype.grouptype]) do
				local groupinfo = C.GetUpgradeSlotGroup(menu.object, menu.macro, upgradetype.grouptype, i)
				if upgradetype.mergeslots or ((groupinfo.path == menu.upgradeplan[type][group].path) and (groupinfo.group == menu.upgradeplan[type][group].group)) then
					if menu.mode == "upgrade" then
						if slotdata.component then
							menu.removeRepairedComponent(menu.object, slotdata.component)
						end
					end
				end
			end

			-- handle already installed equipment
			local haslicence = menu.checkLicence(macro)
			if (macro == menu.groups[group][upgradetype.grouptype].currentmacro) and (not haslicence) then
				menu.upgradeplan[type][group].count = math.min(menu.upgradeplan[type][group].count, menu.groups[group][upgradetype.grouptype].count)
			end

			menu.upgradeplan[type][group].macro = macro
			menu.upgradeplan[type][group].ammomacro = ""
			menu.upgradeplan[type][group].weaponmode = ""
			if (macro ~= "") and (menu.upgradeplan[type][group].count == 0) then
				menu.upgradeplan[type][group].count = 1
			elseif (macro == "") and (menu.upgradeplan[type][group].count ~= 0) then
				menu.upgradeplan[type][group].count = 0
			end

			if upgradetype.pseudogroup then
				for i, slotdata in ipairs(menu.slots[upgradetype.grouptype]) do
					local groupinfo = C.GetUpgradeSlotGroup(menu.object, menu.macro, upgradetype.grouptype, i)
					if upgradetype.mergeslots or ((groupinfo.path == menu.upgradeplan[type][group].path) and (groupinfo.group == menu.upgradeplan[type][group].group)) then
						menu.upgradeplan[upgradetype.grouptype][i] = { macro = macro, ammomacro = "", weaponmode = "" }
					end
				end
			end

			menu.addUndoStep()

			menu.selectedRows.slots = row
			menu.selectedCols.slots = col
			menu.refreshMenu()
		end
	end

	if menu.holomap and (menu.holomap ~= 0) then
		Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.UpdateObjectConfigurationMap(menu.holomap, menu.object, 0, menu.macro, false, loadout) end)
	end

	if keepcontext then
		menu.topRows.context = GetTopRow(menu.contexttable)
		menu.selectedRows.context = keepcontext
		menu.displayContextFrame("slot", oldcontextmode.width, oldcontextmode.x, oldcontextmode.y)
	end
end

function menu.buttonTitleSave()
	if menu.contextMode and next(menu.contextMode) and (menu.contextMode.mode == "saveLoadout") then
		menu.closeContextMenu()
	else
		menu.displayContextFrame("saveLoadout", menu.titleData.dropdownWidth + menu.titleData.height + Helper.borderSize, menu.titleData.offsetX + 2 * (menu.titleData.dropdownWidth + Helper.borderSize), menu.titleData.offsetY + menu.titleData.height + Helper.borderSize)
	end
end

function menu.buttonSave(overwrite)
	local loadoutid
	if overwrite then
		loadoutid = menu.loadout
	end

	Helper.closeDropDownOptions(menu.titlebartable, 1, 1)
	Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
	if menu.mode ~= "modify" then
		Helper.closeDropDownOptions(menu.titlebartable, 1, 3)
	end
	local macro = (menu.macro ~= "") and menu.macro or GetComponentData(ConvertStringToLuaID(tostring(menu.object)), "macro")
	if macro ~= nil then
		for i, entry in ipairs(menu.crew.roles) do
			menu.upgradeplan.crew[entry.id] = entry.wanted
		end

		Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.SaveLoadout2(macro, loadout, "local", loadoutid or "player", loadoutid ~= nil, menu.loadoutName, "") end, nil, "UILoadout2")
		menu.getPresetLoadouts()
	end
	menu.closeContextMenu()
	menu.displayMenu()
end

function menu.buttonDismantleMod(type, component, context, group)
	local fficurrentloadoutstats = C.GetCurrentLoadoutStatistics4(menu.object)
	menu.initialLoadoutStatistics = Helper.convertLoadoutStats(fficurrentloadoutstats)

	if (type == "turret") and group then
		C.DismantleGroupedWeaponMod(component, context, group)
	elseif (type == "weapon") or (type == "turret") then
		C.DismantleWeaponMod(component)
	elseif type == "engine" then
		C.DismantleEngineMod(component)
	elseif type == "shield" then
		C.DismantleShieldMod(component, context, group)
	elseif type == "ship" then
		C.DismantleShipMod(component)
	end
	menu.prepareModWares()
	menu.refreshMenu()
end

function menu.buttonInstallMod(type, component, ware, price, context, group, dismantle)
	if menu.isplayerowned or (GetPlayerMoney() >= price * menu.moddingdiscounts.totalfactor) then
		local fficurrentloadoutstats = C.GetCurrentLoadoutStatistics4(menu.object)
		menu.initialLoadoutStatistics = Helper.convertLoadoutStats(fficurrentloadoutstats)

		if (type == "turret") and group then
			C.DismantleGroupedWeaponMod(component, context, group)
		elseif (type == "weapon") or (type == "turret") then
			C.DismantleWeaponMod(component)
		elseif type == "engine" then
			C.DismantleEngineMod(component)
		elseif type == "shield" then
			C.DismantleShieldMod(component, context, group)
		elseif type == "ship" then
			C.DismantleShipMod(component)
		end

		if not menu.isplayerowned then
			TransferPlayerMoneyTo(price * menu.moddingdiscounts.totalfactor, menu.container)
		end

		if (type == "turret") and group then
			C.InstallGroupedWeaponMod(component, context, group, ware)
		elseif (type == "weapon") or (type == "turret") then
			C.InstallWeaponMod(component, ware)
		elseif type == "engine" then
			C.InstallEngineMod(component, ware)
		elseif type == "shield" then
			C.InstallShieldMod(component, context, group, ware)
		elseif type == "ship" then
			C.InstallShipMod(component, ware)
		end
		AddUITriggeredEvent(menu.name, "modinstalled", { ConvertStringToLuaID(tostring(component)), ware })
		menu.prepareModWares()
		menu.refreshMenu()
	end
end

function menu.buttonContextEncyclopedia(selectedUpgrade)
	local upgradetype = Helper.findUpgradeType(selectedUpgrade.type)

	if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") or (upgradetype.supertype == "group") then
		local library = GetMacroData(selectedUpgrade.macro, "infolibrary")
		Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, upgradetype.emode, library, selectedUpgrade.macro })
		menu.cleanup()
	elseif upgradetype.supertype == "software" then
		Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, upgradetype.emode, "software", selectedUpgrade.software })
		menu.cleanup()
	elseif upgradetype.supertype == "ammo" then
		local library = GetMacroData(selectedUpgrade.macro, "infolibrary")
		if upgradetype.emode then
			local emode = upgradetype.emode
			if library == "mines" then
				emode = "Weapons"
			end
			Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, emode, library, selectedUpgrade.macro })
			menu.cleanup()
		end
	end
end

function menu.buttonEditBlacklist()
	Helper.closeMenuAndOpenNewMenu(menu, "PlayerInfoMenu", { 0, 0, "globalorders" })
	menu.cleanup()
end

function menu.buttonEditFightRule()
	Helper.closeMenuAndOpenNewMenu(menu, "PlayerInfoMenu", { 0, 0, "globalorders" })
	menu.cleanup()
end

function menu.buttonInteract(selectedData, button, row, col, posx, posy)
	menu.selectedUpgrade = selectedData
	local x, y = GetLocalMousePosition()
	if x == nil then
		-- gamepad case
		x = posx
		y = -posy
	end
	if menu.mode ~= "customgamestart" then
		menu.displayContextFrame("equipment", Helper.scaleX(200), x + Helper.viewWidth / 2, Helper.viewHeight / 2 - y)
	end
end

function menu.buttonShowStats()
	local statskeyword = "showStats"
	if (menu.mode == "modify") and (menu.upgradetypeMode == "paintmods") then
		statskeyword = "showStatsPaintMod"
	end
	__CORE_DETAILMONITOR_SHIPBUILD[statskeyword] = not __CORE_DETAILMONITOR_SHIPBUILD[statskeyword]
	menu.refreshMenu()
end

function menu.slidercellSelectAmount(type, slot, macro, row, value)
	menu.closeContextMenu()

	local upgradetype = Helper.findUpgradeType(type)

	if (upgradetype.supertype == "ammo") then
		AddUITriggeredEvent(menu.name, "ammo_changed", value)
		menu.upgradeplan[type][macro] = value
		menu.selectedRows.slots = row
	end
	menu.addUndoStep()
end

function menu.slidercellSelectCrewAmount(slot, tier, row, istier, value)
	menu.noupdate = true

	local oldwanted = istier and menu.crew.roles[slot].tiers[tier].wanted or menu.crew.roles[slot].wanted

	local change = value - oldwanted
	if istier then
		menu.crew.roles[slot].wanted = menu.crew.roles[slot].wanted + change
	else
		menu.crew.roles[slot].wanted = value
	end
	if change > 0 then
		AddUITriggeredEvent(menu.name, "crew_added", change)
		-- adding crew
		-- first use npcs from the unassigned pool
		if #menu.crew.unassigned > 0 then
			if #menu.crew.unassigned >= change then
				-- first reassign npcs from the correct role to the correct tier
				for i = #menu.crew.unassigned, 1, -1 do
					if menu.crew.unassigned[i].role == menu.crew.roles[slot].id then
						menu.crew.roles[slot].tiers[menu.crew.unassigned[i].tier].wanted = menu.crew.roles[slot].tiers[menu.crew.unassigned[i].tier].wanted + 1
						table.insert(menu.crew.roles[slot].tiers[menu.crew.unassigned[i].tier].currentnpcs, menu.crew.unassigned[i].npc)
						table.insert(menu.crew.transferdetails, { npc = menu.crew.unassigned[i].npc, newrole = menu.crew.roles[slot].id, price = 0 })
						table.remove(menu.crew.unassigned, i)
						change = change - 1
						if change == 0 then
							break
						end
					end
				end
				if change > 0 then
					-- if that wasn't enough, use all unassigned npcs
					for i = #menu.crew.unassigned, 1, -1 do
						menu.crew.roles[slot].tiers[tier].wanted = menu.crew.roles[slot].tiers[tier].wanted + 1
						table.insert(menu.crew.roles[slot].tiers[tier].currentnpcs, menu.crew.unassigned[i].npc)
						table.insert(menu.crew.transferdetails, { npc = menu.crew.unassigned[i].npc, newrole = menu.crew.roles[slot].id, price = 0 })
						table.remove(menu.crew.unassigned, i)
						change = change - 1
						if change == 0 then
							break
						end
					end
				end
			else
				change = change - #menu.crew.unassigned
				for _, entry in ipairs(menu.crew.unassigned) do
					local npctier = tier
					if entry.role == menu.crew.roles[slot].id then
						npctier = entry.tier
					end
					menu.crew.roles[slot].tiers[npctier].wanted = menu.crew.roles[slot].tiers[npctier].wanted + 1
					table.insert(menu.crew.roles[slot].tiers[npctier].currentnpcs, entry.npc)
					table.insert(menu.crew.transferdetails, { npc = entry.npc, newrole = menu.crew.roles[slot].id, price = 0 })
				end
				menu.crew.unassigned = {}
			end
		end
		-- if any are left add newly hired npcs
		if change > 0 then
			menu.crew.hired = menu.crew.hired + change
			menu.crew.roles[slot].tiers[tier].wanted = menu.crew.roles[slot].tiers[tier].wanted + change
			local found = false
			for i, entry in ipairs(menu.crew.hireddetails) do
				if entry.newrole == menu.crew.roles[slot].id then
					menu.crew.hireddetails[i].amount = menu.crew.hireddetails[i].amount + change
					found = true
					break
				end
			end
			if not found then
				table.insert(menu.crew.hireddetails, { newrole = menu.crew.roles[slot].id, amount = change, price = menu.crew.price })
			end
		end
	else
		AddUITriggeredEvent(menu.name, "crew_removed", -change)
		-- removing crew
		-- first remove newly hired crew
		for i, entry in ipairs(menu.crew.hireddetails) do
			if entry.newrole == menu.crew.roles[slot].id then
				if entry.amount >= -change then
					menu.crew.hireddetails[i].amount = menu.crew.hireddetails[i].amount + change
					menu.crew.roles[slot].tiers[tier].wanted = menu.crew.roles[slot].tiers[tier].wanted + change
					if menu.crew.hireddetails[i].amount == 0 then
						table.remove(menu.crew.hireddetails, i)
					end
					menu.crew.hired = menu.crew.hired + change
					change = 0
				else
					menu.crew.hired = menu.crew.hired - entry.amount
					change = change + entry.amount
					menu.crew.roles[slot].tiers[tier].wanted = menu.crew.roles[slot].tiers[tier].wanted - entry.amount
					table.remove(menu.crew.hireddetails, i)
				end
				break
			end
		end
		-- if any are left move them to unassigned
		if change < 0 then
			for i = 1, -change do
				local npc, npctier
				if #menu.crew.roles[slot].tiers[tier].currentnpcs > 0 then
					npc = table.remove(menu.crew.roles[slot].tiers[tier].currentnpcs)
					npctier = tier
					menu.crew.roles[slot].tiers[tier].wanted = menu.crew.roles[slot].tiers[tier].wanted - 1
				else
					for j = 1, #menu.crew.roles[slot].tiers do
						if #menu.crew.roles[slot].tiers[j].currentnpcs > 0 then
							npc = table.remove(menu.crew.roles[slot].tiers[j].currentnpcs)
							npctier = j
							menu.crew.roles[slot].tiers[j].wanted = menu.crew.roles[slot].tiers[j].wanted - 1
							break
						end
					end
				end
				if npc then
					table.insert(menu.crew.unassigned, { npc = npc, role = menu.crew.roles[slot].id, tier = npctier })
				else
					DebugError("Could not find npc to remove. [Florian]")
				end
			end
		end
	end
	menu.addUndoStep()

	menu.selectedRows.slots = row
end

function menu.slidercellSelectGroupAmount(type, group, row, keepcontext, value)
	local oldcontextmode = Helper.tableCopy(menu.contextMode)
	if not keepcontext then
		menu.closeContextMenu()
	end

	local upgradetype = Helper.findUpgradeType(type)

	if (upgradetype.supertype == "group") then
		if value ~= menu.upgradeplan[type][group].count then
			menu.upgradeplan[type][group].count = value

			menu.addUndoStep()

			menu.selectedRows.slots = row
		end
	end

	if menu.holomap and (menu.holomap ~= 0) then
		Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.UpdateObjectConfigurationMap(menu.holomap, menu.object, 0, menu.macro, false, loadout) end)
	end

	if keepcontext then
		menu.topRows.context = GetTopRow(menu.contexttable)
		menu.selectedRows.context = keepcontext
		menu.displayContextFrame("slot", oldcontextmode.width, oldcontextmode.x, oldcontextmode.y)
	end
end

function menu.onSliderCellConfirm()
	menu.refreshMenu()
	menu.noupdate = nil
end

function menu.checkCommanderRepairOrders(shipidstring)
	local commander = GetCommander(ConvertStringTo64Bit(shipidstring))
	if commander then
		local commanderidstring = tostring(ConvertIDTo64Bit(commander))
		if menu.repairplan[commanderidstring] then
			return true
		else
			return menu.checkCommanderRepairOrders(commanderidstring)
		end
	end

	return false
end

function menu.getLastUnprocessedSubordinate(shipidstring, list_processed)
	local ship = ConvertStringToLuaID(tostring(shipidstring))
	local subordinates = GetSubordinates(ship)
	local subordinate = nil

	for _, locsubordinate in pairs(subordinates) do
		local skip = nil
		for _, eval in pairs(list_processed) do
			if tostring(locsubordinate) == tostring(eval) then
				skip = true
				break
			end
		end
		if not skip then
			if locsubordinate then
				local locsubordinatestring = tostring(ffi.new("UniverseID", ConvertStringTo64Bit(tostring(locsubordinate))))
				local result = menu.getLastUnprocessedSubordinate(locsubordinatestring, list_processed)
				subordinate = result[1]
				if not subordinate then
					subordinate = locsubordinate
				end
			end
		else
			skip = nil
		end
	end

	--print("returning " .. tostring(subordinate))
	return {subordinate, list_processed}
end

function menu.processRepairsFor(shipidstring, orderindex)
	local ship = ConvertStringTo64Bit(shipidstring)
	local subordinates = GetSubordinates(ConvertStringToLuaID(tostring(shipidstring)))
	local subordinateorders = {}
	local list_processed = {}

	while #subordinates > 0 do
		local result = menu.getLastUnprocessedSubordinate(shipidstring, list_processed)
		local subordinate = result[1]
		list_processed = result[2]

		if subordinate then
			table.insert(list_processed, subordinate)
			for i = #subordinates, 1, -1 do
				if tostring(subordinate) == tostring(subordinates[i]) then
					table.remove(subordinates, i)
					break
				end
			end
			local subordinateidstring = tostring(ffi.new("UniverseID", ConvertStringTo64Bit(tostring(subordinate))))
			local param2 = nil
			local param3 = {}
			if menu.repairplan[subordinateidstring] then
				for componentidstring, _ in pairs(menu.repairplan[subordinateidstring]) do
					if componentidstring ~= "processed" then
						if componentidstring == subordinateidstring then
							param2 = 100
						else
							table.insert(param3, ConvertStringToLuaID(componentidstring))
						end
					end
				end
				subordinateorders[subordinate] = { ConvertStringToLuaID(tostring(menu.container)), param2, param3, false, 0 }
				menu.repairplan[subordinateidstring]["processed"] = true
			end
		else
			break
		end
	end

	local shipluaid = ConvertStringToLuaID(tostring(shipidstring))

	-- param 1 == destination (component)
	SetOrderParam(shipluaid, orderindex, 1, nil, ConvertStringToLuaID(tostring(menu.container)))

	for componentidstring, _ in pairs(menu.repairplan[shipidstring]) do
		if componentidstring ~= "processed" then
			if componentidstring == shipidstring then
				SetOrderParam(shipluaid, orderindex, 2, nil, 100)
			else
				-- param 3 == damagedcomponents (list)
				SetOrderParam(shipluaid, orderindex, 3, nil, ConvertStringToLuaID(componentidstring))
			end
		end
	end

	-- param 4 == repairall (bool)
	SetOrderParam(shipluaid, orderindex, 4, nil, false)

	-- param 5 == acceptedcost (money)
	SetOrderParam(shipluaid, orderindex, 5, nil, menu.totalrepairprice)

	-- param 6 == urgent (bool); by default, repairs ordered by the player are always urgent
	SetOrderParam(shipluaid, orderindex, 6, nil, true)

	-- param 7 == blacklist_stations (list)

	-- param 8 == subordinaterepairorders (table)
	SetOrderParam(shipluaid, orderindex, 8, nil, subordinateorders)

	-- param 9 == subordinateorders (list) (used for undocking subordinates)

	-- param 10 == debugchance (int)
	--SetOrderParam(shipluaid, orderindex, 10, nil, 100)

	menu.repairplan[shipidstring]["processed"] = true

	if not C.EnableOrder(ship, orderindex) then
		print("ERROR: Order to initiate repairs for " .. ffi.string(C.GetComponentName(ship)) .. " was not enabled.")
	end
end

function menu.buttonConfirm()
	local playermoney = GetPlayerMoney()
	if menu.isplayerowned or ((playermoney - menu.shoppinglisttotal + menu.shoppinglistrefund) >= 0) then
		if (menu.mode == "purchase") or (menu.mode == "upgrade") then
			for i, entry in ipairs(menu.shoppinglist) do
				if i ~= menu.editingshoppinglist then
					local haspaid
					if not menu.isplayerowned then
						-- Pay upfront, receive money when build finishes
						if (entry.price + entry.crewprice) > 0 then
							TransferPlayerMoneyTo(entry.amount * (entry.price + entry.crewprice), menu.container)
							haspaid = entry.price + entry.crewprice
						end
					end

					if entry.objectgroup then
						local groupentry = menu.shipgroups[entry.objectgroup]
						for i, ship in ipairs(groupentry.ships) do
							menu.repairandupgrade(entry, ship.ship, "", entry.groupstates[i].hasupgrades, haspaid, entry.groupstates[i].price, entry.groupstates[i].crewprice)
						end
					else
						menu.repairandupgrade(entry, entry.object, entry.macro, entry.hasupgrades, haspaid)
					end
				end
			end
		elseif menu.mode == "modify" then
			-- TODO
		elseif menu.mode == "customgamestart" then
			for i, entry in ipairs(menu.crew.roles) do
				menu.upgradeplan.crew[entry.id] = entry.wanted
			end
			if menu.modeparam.playerpropertyid then
				local entryid = Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.SetCustomGameStartPlayerPropertyMacroAndLoadout2(menu.modeparam.gamestartid, menu.modeparam.shipproperty, menu.modeparam.playerpropertyid, menu.modeparam.propertycommander, menu.macro, loadout) end, nil, "UILoadout2")
				C.SetCustomGameStartPlayerPropertyPeople(menu.modeparam.gamestartid, menu.modeparam.shipproperty, entryid, menu.customgamestartpeopledef)
				C.SetCustomGameStartPlayerPropertyPeopleFillPercentage2(menu.modeparam.gamestartid, menu.modeparam.shipproperty, entryid, menu.customgamestartpeoplefillpercentage)

				local numskills = C.GetNumSkills()
				local buf = ffi.new("CustomGameStartPersonEntry")
				buf.race = Helper.ffiNewString(menu.customgamestartpilot.race or "")
				buf.tags = Helper.ffiNewString(menu.customgamestartpilot.tags or "")
				local skillbuf = ffi.new("SkillInfo[?]", numskills)
				numskills = C.GetSkills(skillbuf, numskills)
				buf.numskills = numskills
				buf.skills = Helper.ffiNewHelper("SkillInfo[?]", buf.numskills)
				for i = 0, numskills - 1 do
					local id = ffi.string(skillbuf[i].id)
					buf.skills[i].id = Helper.ffiNewString(id)
					buf.skills[i].value = menu.customgamestartpilot.skills and menu.customgamestartpilot.skills[id] or 0
				end
				C.SetCustomGameStartPlayerPropertyPerson(menu.modeparam.gamestartid, menu.modeparam.shipproperty, entryid, buf)
			else
				Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.SetCustomGameStartShipAndLoadoutProperty2(menu.modeparam.gamestartid, menu.modeparam.shipproperty, menu.modeparam.shiploadoutproperty, menu.macro, loadout) end, nil, "UILoadout2")
				C.SetCustomGameStartStringProperty(menu.modeparam.gamestartid, menu.modeparam.shippeopleproperty, menu.customgamestartpeopledef)
				C.SetCustomGameStartFloatProperty(menu.modeparam.gamestartid, menu.modeparam.shippeoplefillpercentageproperty, menu.customgamestartpeoplefillpercentage)

				if menu.modeparam.shippilotproperty then
					local numskills = C.GetNumSkills()
					local buf = ffi.new("CustomGameStartPersonEntry")
					buf.race = Helper.ffiNewString(menu.customgamestartpilot.race or "")
					buf.tags = Helper.ffiNewString(menu.customgamestartpilot.tags or "")
					local skillbuf = ffi.new("SkillInfo[?]", numskills)
					numskills = C.GetSkills(skillbuf, numskills)
					buf.numskills = numskills
					buf.skills = Helper.ffiNewHelper("SkillInfo[?]", buf.numskills)
					for i = 0, numskills - 1 do
						local id = ffi.string(skillbuf[i].id)
						buf.skills[i].id = Helper.ffiNewString(id)
						buf.skills[i].value = menu.customgamestartpilot.skills and menu.customgamestartpilot.skills[id] or 0
					end
					C.SetCustomGameStartShipPilot(menu.modeparam.gamestartid, menu.modeparam.shippilotproperty, buf)
				end
			end
		elseif menu.mode == "comparison" then
			Helper.addShipComparison(menu.modeparam[1], menu.macro, menu.upgradeplan)
		end

		menu.closeMenu("back")
	else
		menu.displayMenu()
	end
end

function menu.buttonSelectPaintMod(entry, row, col)
	menu.selectedPaintMod = entry
	C.SetMapPaintMod(menu.holomap, entry.ware)

	menu.selectedRows.slots = row
	menu.selectedCols.slots = col
	menu.refreshMenu()
end

function menu.buttonInstallPaintMod()
	if menu.modeparam[1] then
		for _, ship in pairs(menu.modeparam[2]) do
			local change = false
			local paintmod = ffi.new("UIPaintMod")
			if C.GetInstalledPaintMod(ship, paintmod) then
				if menu.selectedPaintMod.ware ~= ffi.string(paintmod.Ware) then
					change = true
				end
			else
				change = true
			end
			if change then
				C.InstallPaintMod(ship, menu.selectedPaintMod.ware, not menu.selectedPaintMod.isdefault)
				AddUITriggeredEvent(menu.name, "paintmodinstalled", { ConvertStringToLuaID(tostring(ship)), menu.selectedPaintMod.ware })
			end
		end
	else
		C.InstallPaintMod(menu.object, menu.selectedPaintMod.ware, not menu.selectedPaintMod.isdefault)
		AddUITriggeredEvent(menu.name, "paintmodinstalled", { ConvertStringToLuaID(tostring(menu.object)), menu.selectedPaintMod.ware })
	end

	menu.selectedRows.slots = Helper.currentTableRow[menu.slottable]
	menu.selectedCols.slots = Helper.currentTableCol[menu.slottable]

	menu.mapstate = ffi.new("HoloMapState")
	C.GetMapState(menu.holomap, menu.mapstate)
	menu.prepareModWares()
	menu.getDataAndDisplay(nil, nil, nil, nil, true)
end

function menu.dropdownShipClass(_, class)
	AddUITriggeredEvent(menu.name, "shipclass_selected", class)
	if class ~= menu.class then
		menu.class = class or ""
		if menu.usemacro then
			menu.validLicence = false
			menu.macro = ""
		elseif (menu.mode == "upgrade") or (menu.mode == "modify") then
			local entry = menu.selectableshipsbyclass[class][1]
			if type(entry) == "table" then
				if entry.group then
					menu.objectgroup = menu.shipgroups[entry.group]
					menu.object = menu.objectgroup.ships[1].ship
				elseif entry.grouped ~= nil then
					menu.objectgroup = nil
					menu.object = entry.ship.ship
				else
					menu.objectgroup = nil
					menu.object = entry.ship
				end
			else
				menu.objectgroup = nil
				menu.object = entry
			end

			menu.damagedcomponents = menu.determineNeededRepairs(menu.object)
			menu.validLoadoutPossible = (not menu.isReadOnly) and menu.container and C.CanGenerateValidLoadout(menu.container, GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro"))

			if menu.mode == "upgrade" then
				local aipilot = GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "assignedaipilot")
				if aipilot then
					menu.captainSelected = true
				else
					menu.captainSelected = false
				end
			elseif menu.mode == "modify" then
				local fficurrentloadoutstats = C.GetCurrentLoadoutStatistics4(menu.object)
				menu.initialLoadoutStatistics = Helper.convertLoadoutStats(fficurrentloadoutstats)
				menu.selectedPaintMod = nil
				menu.prepareModWares()
			end
		end
		menu.customshipname = ""
		menu.useloadoutname = false
		menu.loadoutName = ""
		menu.playershipname = nil
		menu.clearUndoStack()
		menu.getDataAndDisplay()
	end
end

function menu.dropdownShip(_, shipid)
	if menu.usemacro then
		AddUITriggeredEvent(menu.name, "shipmacro_selected", shipid)
		local oldmacro = menu.macro
		menu.macro = shipid or ""
		if menu.macro ~= oldmacro then
			menu.hasDefaultLoadout = false
			menu.defaultLoadoutMacros = {}
			if menu.macro ~= "" then
				menu.hasDefaultLoadout = C.HasDefaultLoadout2(menu.macro, true)
				if menu.hasDefaultLoadout then
					local n = C.GetNumDefaultLoadoutMacros(menu.macro)
					local buf = ffi.new("const char*[?]", n)
					n = C.GetDefaultLoadoutMacros(buf, n, menu.macro)
					for i = 0, n - 1 do
						menu.defaultLoadoutMacros[ffi.string(buf[i])] = true
					end
				end
			end

			menu.setdefaulttable = true
			menu.currentSlot = nil
			menu.captainSelected = (menu.mode == "customgamestart") or (menu.mode == "comparison")
			menu.validLicence = menu.checkLicence(menu.macro, true)
			if menu.mode == "customgamestart" then
				menu.validLoadoutPossible = true
			elseif menu.mode == "comparison" then
				menu.validLoadoutPossible = C.CanGenerateValidKnownLoadout(menu.macro)
			else
				menu.validLoadoutPossible = (not menu.isReadOnly) and menu.container and C.CanGenerateValidLoadout(menu.container, menu.macro)
			end
			menu.customshipname = ""
			menu.useloadoutname = false
			menu.loadoutName = ""
			menu.playershipname = nil
			menu.clearUndoStack()
			menu.getDataAndDisplay()
		end
	elseif (menu.mode == "upgrade") or (menu.mode == "modify") then
		AddUITriggeredEvent(menu.name, "ship_selected", shipid)
		local oldobject = menu.object
		local oldobjectgroup = menu.objectgroup and menu.objectgroup.idx or 0

		local i
		if menu.mode == "upgrade" then
			i = menu.findMacroIdx(menu.shipgroups, shipid)
		end
		if i then
			for idx, entry in ipairs(menu.shoppinglist) do
				for _, ship in ipairs(menu.shipgroups[i].ships) do
					if ship.ship == entry.object then
						menu.contextData = { mode = "replacesingleshoppinglistentry", group = i, shipid = shipid }
						menu.displayContextFrame("userquestion", Helper.scaleX(400), (Helper.viewWidth - Helper.scaleX(400)) / 2, Helper.viewHeight / 2)
						return
					end
				end
			end

			menu.objectgroup = menu.shipgroups[i]
			menu.object = menu.objectgroup.ships[1].ship
		else
			menu.objectgroup = nil
			menu.object = ffi.new("UniverseID", ConvertStringTo64Bit(shipid))
		end
		menu.damagedcomponents = menu.determineNeededRepairs(menu.object)
		menu.validLoadoutPossible = (not menu.isReadOnly) and menu.container and C.CanGenerateValidLoadout(menu.container, GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro"))

		if (menu.object ~= oldobject) or ((menu.objectgroup and menu.objectgroup.idx or 0) ~= oldobjectgroup) then
			menu.setdefaulttable = true
			if menu.editingshoppinglist then
				table.remove(menu.shoppinglist, menu.editingshoppinglist)
			end

			menu.hasDefaultLoadout = false
			menu.defaultLoadoutMacros = {}
			if menu.object ~= 0 then
				local macro = GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro")
				menu.hasDefaultLoadout = C.HasDefaultLoadout2(macro, true)
				if menu.hasDefaultLoadout then
					local n = C.GetNumDefaultLoadoutMacros(macro)
					local buf = ffi.new("const char*[?]", n)
					n = C.GetDefaultLoadoutMacros(buf, n, macro)
					for i = 0, n - 1 do
						menu.defaultLoadoutMacros[ffi.string(buf[i])] = true
					end
				end
			end

			if menu.mode == "upgrade" then
				local aipilot = GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "assignedaipilot")
				if aipilot then
					menu.captainSelected = true
				else
					menu.captainSelected = false
				end
			elseif menu.mode == "modify" then
				local fficurrentloadoutstats = C.GetCurrentLoadoutStatistics4(menu.object)
				menu.initialLoadoutStatistics = Helper.convertLoadoutStats(fficurrentloadoutstats)
				menu.selectedPaintMod = nil
				menu.prepareModWares()
			end

			local found = false
			for idx, entry in ipairs(menu.shoppinglist) do
				if menu.object == entry.object then
					found = true

					menu.editingshoppinglist = idx
					menu.object = entry.object
					menu.damagedcomponents = menu.determineNeededRepairs(menu.object)
					menu.macro = entry.macro
					menu.validLoadoutPossible = (not menu.isReadOnly) and menu.container and C.CanGenerateValidLoadout(menu.container, GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro"))
					menu.clearUndoStack()
					menu.getDataAndDisplay(entry.upgradeplan, entry.crew, true, true)
					break
				elseif menu.objectgroup and (menu.objectgroup.idx == entry.objectgroup) then
					found = true

					menu.editingshoppinglist = idx
					menu.clearUndoStack()
					menu.getDataAndDisplay(entry.upgradeplan, entry.crew, true, true)
					break
				end
			end

			if not found then
				menu.editingshoppinglist = nil

				menu.currentSlot = nil
				menu.customshipname = ""
				menu.useloadoutname = false
				menu.loadoutName = ""
				menu.playershipname = nil
				menu.clearUndoStack()
				menu.getDataAndDisplay(nil, nil, nil, true)
			end
		end
	end
end

function menu.dropdownLoadout(_, loadoutid)
	if loadoutid ~= nil then
		menu.loadout = loadoutid
		local preset, mission
		for _, loadout in ipairs(menu.loadouts) do
			if loadout.id == menu.loadout then
				menu.loadoutName = loadout.name
				menu.setCustomShipName()
				if loadout.preset then
					preset = loadout.preset
					menu.loadout = nil
				elseif loadout.mission then
					menu.loadoutName = string.match(menu.loadoutName, "\27#.*#\27%[.*%] (.*)\27X")
					mission = loadout.mission
					menu.loadout = nil
				end
				break
			end
		end
		local loadout, crew
		if preset then
			if menu.mode == "customgamestart" then
				loadout = Helper.getLoadoutHelper2(C.GenerateShipLoadout2, C.GenerateShipLoadoutCounts2, "UILoadout2", 0, menu.object, menu.macro, preset)
			elseif menu.mode == "comparison" then
				loadout = Helper.getLoadoutHelper2(C.GenerateShipKnownLoadout2, C.GenerateShipKnownLoadoutCounts2, "UILoadout2", menu.macro, preset)
			else
				loadout = Helper.getLoadoutHelper2(C.GenerateShipLoadout2, C.GenerateShipLoadoutCounts2, "UILoadout2", menu.container, menu.object, menu.macro, preset)
			end
			if menu.usemacro then
				if menu.mode ~= "customgamestart" then
					local intendedcrew = preset * menu.crew.capacity
					local intendedcrewperrole = math.floor(intendedcrew / #menu.crew.roles)

					crew = {
						roles = {},
						unassigned = {},
						hired = 0,
						hireddetails = {},
						fired = {},
					}

					for i, entry in ipairs(menu.crew.roles) do
						crew.roles[i] = { tiers = { [1] = {} } }
						crew.roles[i].wanted = intendedcrewperrole
						crew.roles[i].tiers[1].wanted = intendedcrewperrole

						crew.hired = crew.hired + intendedcrewperrole
						table.insert(crew.hireddetails, { newrole = entry.id, amount = intendedcrewperrole, price = menu.crew.price })
					end
				else
					if preset >= 0.9 then
						menu.customgamestartpeopledef = "player_argon_elite_freighter_crew"
					elseif preset >= 0.4 then
						menu.customgamestartpeopledef = "player_argon_veteran_freighter_crew"
					elseif preset > 0 then
						menu.customgamestartpeopledef = "player_argon_regular_freighter_crew"
					else
						menu.customgamestartpeopledef = ""
					end
					menu.customgamestartpeoplefillpercentage = preset * 100
				end
			end
		elseif mission then
			loadout = Helper.getLoadoutHelper2(C.GetMissionLoadout, C.GetMissionLoadoutCounts, "UILoadout2", mission.id, mission.macro)
		else
			loadout = Helper.getLoadoutHelper2(C.GetLoadout2, C.GetLoadoutCounts2, "UILoadout2", menu.object, menu.macro, loadoutid)
		end
		local upgradeplan = Helper.convertLoadout(menu.object, menu.macro, loadout, menu.software, "UILoadout2")
		if menu.usemacro then
			menu.captainSelected = true
		end
		menu.getDataAndDisplay(upgradeplan, crew)
	end
end

function menu.dropdownLoadoutRemoved(_, loadoutid)
	local macro = (menu.macro ~= "") and menu.macro or GetComponentData(ConvertStringToLuaID(tostring(menu.object)), "macro")
	C.RemoveLoadout("local", macro, loadoutid)
	if loadoutid == menu.loadout then
		menu.loadout = nil
		menu.loadoutName = ""
	end
	for i, loadout in ipairs(menu.loadouts) do
		if loadout.id == loadoutid then
			table.remove(menu.loadouts, i)
			break
		end
	end
end

function menu.dropdownChangePurchaseAmount(idx, amountstring)
	local entry = menu.shoppinglist[idx]
	entry.amount = tonumber(amountstring)
	menu.refreshMenu()
	AddUITriggeredEvent(menu.name, "shipconfig_purchaseamount", entry.amount)
end

function menu.onDropDownActivated()
	menu.closeContextMenu()
end

function menu.buttonAddPurchase(hasupgrades, hasrepairs)
	menu.closeContextMenu()

	local objectgroup
	local object = menu.object
	local groupstates = {}
	if menu.objectgroup then
		objectgroup = menu.objectgroup.idx
		object = nil
		groupstates = menu.objectgroup.states
	end

	table.insert(menu.shoppinglist, { objectgroup = objectgroup, groupstates = groupstates, object = object, macro = menu.macro, hasupgrades = hasupgrades, upgradeplan = menu.upgradeplan, crew = menu.crew, settings = menu.settings, amount = 1, price = menu.total, crewprice = menu.crewtotal, duration = menu.duration, warnings = menu.warnings, customshipname = menu.customshipname, useloadoutname = menu.useloadoutname, loadoutName = menu.loadoutName, playershipname = menu.playershipname })
	menu.object = 0
	menu.objectgroup = nil
	menu.damagedcomponents = {}
	menu.macro = ""
	menu.customshipname = ""
	menu.useloadoutname = false
	menu.loadoutName = ""
	menu.playershipname = nil
	menu.clearUndoStack()
	menu.getDataAndDisplay()
end

function menu.buttonConfirmPurchaseEdit(hasupgrades, hasrepairs)
	menu.closeContextMenu()

	if (not hasupgrades) and (not hasrepairs) then
		table.remove(menu.shoppinglist, menu.editingshoppinglist)
	else
		if menu.objectgroup then
			menu.shoppinglist[menu.editingshoppinglist].objectgroup = menu.objectgroup.idx
			menu.shoppinglist[menu.editingshoppinglist].groupstates = menu.objectgroup.states
		else
			menu.shoppinglist[menu.editingshoppinglist].object = menu.object
		end
		menu.shoppinglist[menu.editingshoppinglist].macro = menu.macro
		menu.shoppinglist[menu.editingshoppinglist].hasupgrades = hasupgrades
		menu.shoppinglist[menu.editingshoppinglist].upgradeplan = menu.upgradeplan
		menu.shoppinglist[menu.editingshoppinglist].settings = menu.settings
		menu.shoppinglist[menu.editingshoppinglist].crew = menu.crew
		menu.shoppinglist[menu.editingshoppinglist].price = menu.total
		menu.shoppinglist[menu.editingshoppinglist].crewprice = menu.crewtotal
		menu.shoppinglist[menu.editingshoppinglist].duration = menu.duration
		menu.shoppinglist[menu.editingshoppinglist].warnings = menu.warnings
		menu.shoppinglist[menu.editingshoppinglist].customshipname = menu.customshipname
		menu.shoppinglist[menu.editingshoppinglist].useloadoutname = menu.useloadoutname
		menu.shoppinglist[menu.editingshoppinglist].loadoutName = menu.loadoutName
		menu.shoppinglist[menu.editingshoppinglist].playershipname = menu.playershipname
	end

	menu.object = 0
	menu.objectgroup = nil
	menu.damagedcomponents = {}
	menu.macro = ""
	menu.customshipname = ""
	menu.useloadoutname = false
	menu.loadoutName = ""
	menu.playershipname = nil
	menu.editingshoppinglist = nil
	menu.clearUndoStack()
	menu.getDataAndDisplay()
end

function menu.buttonEditPurchase(idx)
	menu.closeContextMenu()

	local entry = menu.shoppinglist[idx]
	menu.editingshoppinglist = idx
	if entry.objectgroup then
		menu.objectgroup = menu.shipgroups[entry.objectgroup]
		menu.object = menu.objectgroup.ships[1].ship
	else
		menu.objectgroup = nil
		menu.object = entry.object
	end
	if (menu.mode == "upgrade") or (menu.mode == "modify") then
		menu.damagedcomponents = menu.determineNeededRepairs(menu.object)
	end
	menu.macro = entry.macro
	if menu.object ~= 0 then
		menu.class = ffi.string(C.GetComponentClass(menu.object))
	elseif menu.macro ~= "" then
		menu.class = ffi.string(C.GetMacroClass(menu.macro))
	end
	menu.customshipname = entry.customshipname
	menu.useloadoutname = entry.useloadoutname
	menu.loadoutName = entry.loadoutName
	menu.playershipname = entry.playershipname
	menu.captainSelected = true
	menu.validLoadoutPossible = (not menu.isReadOnly) and menu.container and C.CanGenerateValidLoadout(menu.container, (menu.object ~= 0) and GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro") or menu.macro)
	menu.clearUndoStack()
	menu.getDataAndDisplay(entry.upgradeplan, entry.crew, true, true, nil, entry.settings)
end

function menu.buttonRemovePurchase(idx)
	table.remove(menu.shoppinglist, idx)
	menu.refreshMenu()
end

function menu.buttonLeftBar(mode, row, overrideMode, overrideSlot)
	local isreopencontextframe, contextmodemode, contextmodewidth, contextmodex, contextmodey
	if menu.contextMode then
		if menu.contextMode.mode == "equipmentfilter" then
			if menu.upgradetypeMode ~= "crew" and menu.upgradetypeMode ~= "repair" and menu.upgradetypeMode ~= "settings" then
				isreopencontextframe = true
			end
		end
		if isreopencontextframe then
			contextmodemode = menu.contextMode.mode
			contextmodewidth = menu.contextMode.width
			contextmodex = menu.contextMode.x
			contextmodey = menu.contextMode.y
		end
	end
	menu.closeContextMenu()

	menu.prevUpgradetypeMode = menu.upgradetypeMode
	if (overrideMode ~= nil) and (menu.upgradetypeMode == overrideMode) and (menu.currentSlot == overrideSlot) then
		menu.upgradetypeMode = nil
	else
		AddUITriggeredEvent(menu.name, mode, menu.upgradetypeMode == mode and "off" or "on")
		if menu.upgradetypeMode == mode then
			PlaySound("ui_negative_back")
			menu.upgradetypeMode = nil
		else
			menu.setdefaulttable = true
			PlaySound("ui_positive_select")
			menu.upgradetypeMode = overrideMode or mode
		end
	end
	menu.currentSlot = overrideSlot or 1

	if menu.upgradetypeMode then
		menu.selectMapMacroSlot()
	else
		C.ClearSelectedMapMacroSlots(menu.holomap)
	end

	menu.displayMenu(true)
	if isreopencontextframe then
		if contextmodemode == "equipmentfilter" then
			contextmodey = menu.equipmentfilter_races_y
		end
		menu.displayContextFrame(contextmodemode, contextmodewidth, contextmodex, contextmodey, true)
	end
end

function menu.deactivateUpgradeMode()
	menu.prevUpgradetypeMode = menu.upgradetypeMode
	PlaySound("ui_negative_back")
	menu.upgradetypeMode = nil
	menu.currentSlot = 1
	C.ClearSelectedMapMacroSlots(menu.holomap)
	menu.displayMenu()
end

function menu.buttonModCategory(category, row, col)
	if category ~= menu.modCategory then
		menu.modCategory = category

		menu.topRows.slots = GetTopRow(menu.slottable)
		menu.displayMenu()
	end
end

function menu.getModQuality(category)
	for i, entry in ipairs(Helper.modQualities) do
		if entry.category == category then
			return i
		end
	end
end

function menu.buttonResetCrew()
	menu.crew.fired = {}
	menu.crew.hired = 0
	menu.crew.hireddetails = {}
	menu.crew.transferdetails = {}
	menu.crew.unassigned = {}
	for i, entry in ipairs(menu.crew.roles) do
		menu.crew.roles[i].wanted = entry.total
		for j, tier in ipairs(entry.tiers) do
			for _, npc in ipairs(menu.crew.roles[i].tiers[j].npcs) do
				table.insert(menu.crew.roles[i].tiers[j].currentnpcs, npc)
			end
			menu.crew.roles[i].tiers[j].wanted = tier.total
		end
	end

	menu.addUndoStep()

	menu.refreshMenu()
end

function menu.buttonFireCrew()
	for _, entry in ipairs(menu.crew.unassigned) do
		table.insert(menu.crew.fired, { npc = entry.npc, price = menu.crew.price })
	end
	menu.crew.unassigned = {}

	menu.addUndoStep()

	menu.refreshMenu()
end

-- editbox scripts
function menu.editboxSearchUpdateText(_, text, textchanged)
	if textchanged then
		table.insert(menu.equipmentsearchtext, { text = text })
	end

	menu.refreshMenu()
end

function menu.editboxLoadoutNameUpdateText(_, text)
	menu.loadoutName = text
	menu.setCustomShipName()
	menu.loadout = nil
end

function menu.editboxCustomShipName(_, text)
	if text == "" then
		menu.playershipname = nil
	else
		menu.playershipname = text
	end
	menu.useloadoutname = false
	menu.customshipname = text
end

function menu.editboxCustomShipNameDeactivated(_, text, textchanged)
	if text == "" then
		menu.setCustomShipName()
	end
end

-- Menu member functions

function menu.hotkey(action)
	if action == "INPUT_ACTION_ADDON_DETAILMONITOR_UNDO" then
		menu.undoHelper(true)
	elseif action == "INPUT_ACTION_ADDON_DETAILMONITOR_REDO" then
		menu.undoHelper(false)
	end
end

function menu.undoHelper(undo)
	if undo then
		menu.undoIndex = math.min(#menu.undoStack, menu.undoIndex + 1)
	else
		menu.undoIndex = math.max(1, menu.undoIndex - 1)
	end
	menu.captainSelected = menu.undoStack[menu.undoIndex].captainSelected
	menu.repairplan = Helper.tableCopy(menu.undoStack[menu.undoIndex].repairplan, 3)
	menu.getDataAndDisplay(menu.undoStack[menu.undoIndex].upgradeplan, menu.undoStack[menu.undoIndex].crew, nil, nil, true)
end

function menu.addUndoStep(upgradeplan, crew)
	-- making a new branch, remove current redos
	for i = menu.undoIndex - 1, 1, -1 do
		table.remove(menu.undoStack, i)
	end
	-- add current data
	menu.undoIndex = 1
	table.insert(menu.undoStack, 1, { upgradeplan = Helper.tableCopy(upgradeplan or menu.upgradeplan, 3), crew = Helper.tableCopy(crew or menu.crew, 3), captainSelected = menu.captainSelected, repairplan = Helper.tableCopy(menu.repairplan, 3) })
	-- check for stack limit
	while #menu.undoStack > config.undoSteps do
		table.remove(menu.undoStack)
	end
end

function menu.clearUndoStack()
	menu.undoIndex = 1
	menu.undoStack = {}
end

function menu.refreshMenu()
	if not menu.topRows.slots then
		menu.topRows.slots = GetTopRow(menu.slottable)
	end
	if not menu.selectedRows.slots then
		menu.selectedRows.slots = Helper.currentTableRow[menu.slottable]
	end

	menu.displayMenu()
end

function menu.findUpgradeMacro(loctype, macro)
	if type(menu.upgradewares[loctype]) == "table" then
		for i, upgradeware in ipairs(menu.upgradewares[loctype]) do
			if upgradeware.macro == macro then
				return i
			end
		end
	end
end

function menu.determineInitialSlot()
	menu.currentSlot = 1
	if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
		local curslotsizepriority
		for i, group in ipairs(menu.groups) do
			if (menu.upgradetypeMode == "enginegroup") == (group["engine"].total > 0) then
				if group.slotsize and (group.slotsize ~= "") then
					local sizeorder = Helper.slotSizeOrder[group.slotsize] or 0
					if (not curslotsizepriority) or (sizeorder < curslotsizepriority) then
						curslotsizepriority = sizeorder
						menu.currentSlot = i
					end
				end
			end
		end
	end
end

function menu.onShowMenu(state)
	menu.damagedcomponents = {}

	-- layout
	menu.scaleSize = Helper.scaleX(config.scaleSize)
	menu.frameworkData = {
		sidebarWidth = Helper.scaleX(Helper.sidebarWidth),
		offsetX = Helper.frameBorder,
		offsetY = Helper.frameBorder + 20,
		scaleWidth = 3 * menu.scaleSize,
	}
	local reservedSidePanelWidth = math.floor(0.25 * Helper.viewWidth)
	local actualSidePanelWidth = math.min(reservedSidePanelWidth, Helper.scaleX(config.maxSidePanelWidth))
	reservedSidePanelWidth = reservedSidePanelWidth - menu.frameworkData.sidebarWidth - menu.frameworkData.offsetX - 2 * Helper.borderSize
	menu.slotData = {
		width = actualSidePanelWidth - menu.frameworkData.sidebarWidth - menu.frameworkData.offsetX - 2 * Helper.borderSize,
		offsetX = menu.frameworkData.sidebarWidth + menu.frameworkData.scaleWidth + menu.frameworkData.offsetX + 3 * Helper.borderSize,
		offsetY = Helper.frameBorder + Helper.borderSize,
	}
	menu.planData = {
		width = actualSidePanelWidth - menu.frameworkData.sidebarWidth - menu.frameworkData.offsetX - 2 * Helper.borderSize,
		offsetY = Helper.frameBorder + Helper.borderSize,
	}

	local reserverdCenterPanelWidth = Helper.viewWidth - 2 * menu.slotData.offsetX - 2 * reservedSidePanelWidth - 4 * Helper.borderSize
	local actualCenterPanelWidth = math.min(reserverdCenterPanelWidth, Helper.scaleX(config.maxCenterPanelWidth))
	menu.statsData = {
		width =  actualCenterPanelWidth,
		offsetX = menu.slotData.offsetX + reservedSidePanelWidth + 3 * Helper.borderSize + (reserverdCenterPanelWidth - actualCenterPanelWidth) / 2,
		offsetY = Helper.frameBorder,
	}
	menu.titleData = {
		width =  actualCenterPanelWidth,
		height = Helper.scaleY(40),
		offsetX = menu.slotData.offsetX + reservedSidePanelWidth + 3 * Helper.borderSize + (reserverdCenterPanelWidth - actualCenterPanelWidth) / 2,
		offsetY = Helper.frameBorder,
	}
	menu.titleData.dropdownWidth = math.floor((menu.titleData.width - 4 * (menu.titleData.height + Helper.borderSize) - 2 * Helper.borderSize) / 3)
	menu.planData.offsetX = Helper.viewWidth - actualSidePanelWidth - 2 * Helper.borderSize
	menu.mapData = {
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		offsetX = 0,
		offsetY = 0
	}
	menu.subHeaderRowHeight = Helper.scaleY(26)

	menu.headerTextProperties = {
		font = Helper.headerRow1Font,
		fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize),
		x = Helper.scaleX(Helper.headerRow1Offsetx),
		y = math.floor((menu.titleData.height - Helper.scaleY(Helper.headerRow1Height)) / 2 + Helper.scaleY(Helper.headerRow1Offsety)),
		minRowHeight = menu.titleData.height,
		scaling = false,
		cellBGColor = Color["row_background"],
		titleColor = Color["row_title"],
	}

	menu.headerWarningTextProperties = {
		font = Helper.headerRow1Font,
		fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize),
		x = Helper.scaleX(Helper.headerRow1Offsetx),
		y = math.floor((menu.titleData.height - Helper.scaleY(Helper.headerRow1Height)) / 2 + Helper.scaleY(Helper.headerRow1Offsety)),
		minRowHeight = menu.titleData.height,
		scaling = false,
		cellBGColor = Color["row_background"],
		color = function () return menu.warningColor(Color["text_warning"]) end,
		titleColor = Color["text_warning"],
		halign = "center",
	}

	menu.subHeaderTextProperties = {
		font = Helper.headerRow1Font,
		fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize),
		x = Helper.scaleX(Helper.headerRow1Offsetx),
		minRowHeight = menu.subHeaderRowHeight,
		scaling = false,
		cellBGColor = Color["row_background"],
		titleColor = Color["row_title"],
	}

	menu.subHeaderSliderCellTextProperties = {
		font = Helper.headerRow1Font,
		fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize),
		x = Helper.scaleX(Helper.headerRow1Offsetx),
		scaling = false,
	}

	-- parameters
	menu.mode = menu.param[4]
	if menu.param[3] == nil then
		if menu.mode == "upgrade" then
			menu.isReadOnly = true
		end
	else
		menu.container = ConvertIDTo64Bit(menu.param[3])
		menu.containerowner, menu.isplayerowned  = GetComponentData(menu.container, "owner", "isplayerowned")
	end
	menu.modeparam = {}
	if type(menu.param[5]) == "table" then
		if menu.mode == "modify" then
			if menu.param[5][1] == 1 then
				menu.modeparam[1] = true
				menu.modeparam[2] = {}
				for _, ship in pairs(menu.param[5][2]) do
					table.insert(menu.modeparam[2], ConvertIDTo64Bit(ship))
				end
			end
		elseif menu.mode == "customgamestart" then
			menu.modeparam = menu.param[5]
			menu.modeparam.gamestartid							= menu.modeparam[1]
			menu.modeparam.creative								= menu.modeparam[2] ~= 0
			menu.modeparam.shipproperty							= menu.modeparam[3]
			menu.modeparam.shiploadoutproperty					= menu.modeparam[4]
			menu.modeparam.shippeopleproperty					= menu.modeparam[5]
			menu.modeparam.shippeoplefillpercentageproperty		= menu.modeparam[6]
			menu.modeparam.shippilotproperty					= menu.modeparam[7]
			menu.modeparam.paintthemeproperty					= menu.modeparam[8]
			menu.modeparam.playerpropertyid						= menu.modeparam[9]
			menu.modeparam.propertymacro						= menu.modeparam[10]
			menu.modeparam.propertycommander					= menu.modeparam[11]
			menu.modeparam.propertypeopledef					= menu.modeparam[12]
			menu.modeparam.propertypeoplefillpercentage			= menu.modeparam[13]
			menu.modeparam.propertycount						= menu.modeparam[14] or 1
		elseif menu.mode == "comparison" then
			menu.modeparam = menu.param[5]
		else
			for _, ship in pairs(menu.param[5]) do
				table.insert(menu.modeparam, ConvertIDTo64Bit(ship))
			end
		end
	end
	menu.immediate = false
	if menu.param[6] then
		menu.immediate = menu.param[6]
	end
	menu.usemacro = nil
	if (menu.mode == "purchase") or (menu.mode == "customgamestart") or (menu.mode == "comparison") then
		menu.usemacro = true
	end

	if menu.mode == "modify" then
		--menu.frameworkData.offsetY = 2 * (menu.titleData.height + Helper.borderSize) + menu.slotData.offsetY
		menu.titleData.dropdownWidth = math.floor((menu.titleData.width - 3 * (menu.titleData.height + Helper.borderSize) - Helper.borderSize) / 2)
	end

	-- prepare ships
	menu.usedLimitedMacros = {}
	if menu.mode == "purchase" then
		menu.availableshipmacros = {}
		local n = C.GetNumContainerBuilderMacros(menu.container)
		if n > 0 then
			local buf = ffi.new("const char*[?]", n)
			n = C.GetContainerBuilderMacros(buf, n, menu.container)
			for i = 0, n - 1 do
				table.insert(menu.availableshipmacros, ffi.string(buf[i]))
			end
		end

		menu.object = 0
		if not menu.macro then
			menu.macro = ""
		end
		menu.customshipname = ""
		menu.useloadoutname = false
		menu.loadoutName = ""
		menu.playershipname = nil
		menu.class = ""

		menu.availableshipmacrosbyclass = {}
		for _, macro in ipairs(menu.availableshipmacros) do
			local class = ffi.string(C.GetMacroClass(macro))
			if menu.availableshipmacrosbyclass[class] then
				table.insert(menu.availableshipmacrosbyclass[class], macro)
			else
				menu.availableshipmacrosbyclass[class] = { macro }
			end
		end

		local n = C.GetNumUsedLimitedShips()
		if n > 0 then
			local buf = ffi.new("UIMacroCount[?]", n)
			n = C.GetUsedLimitedShips(buf, n)
			for i = 0, n - 1 do
				local macro = ffi.string(buf[i].macro)
				menu.usedLimitedMacros[macro] = buf[i].amount
			end
		end
	elseif menu.mode == "upgrade" then
		menu.selectableships = {}
		if #menu.modeparam > 0 then
			for _, ship in pairs(menu.modeparam) do
				--print("adding " .. ffi.string(C.GetComponentName(ship)) .. " " .. tostring(ship) .. " to list of ships.")
				table.insert(menu.selectableships, ffi.new("UniverseID", ConvertStringTo64Bit(ship)))
			end
		elseif not menu.isReadOnly then
			Helper.ffiVLA(menu.selectableships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, menu.container, "player")
		end

		for i = #menu.selectableships, 1, -1 do
			local hasloop = ffi.new("bool[1]", 0)
			C.GetOrderQueueFirstLoopIdx(menu.selectableships[i], hasloop)

			if (not menu.isReadOnly) and (not C.CanContainerEquipShip(menu.container, menu.selectableships[i])) and (not C.CanContainerSupplyShip(menu.container, menu.selectableships[i])) then
				table.remove(menu.selectableships, i)
			elseif ffi.string(C.GetOwnerDetails(menu.selectableships[i]).factionID) ~= "player" then
				table.remove(menu.selectableships, i)
			elseif menu.selectableships[i] == C.GetPlayerOccupiedShipID() then
				menu.object = menu.selectableships[i]
			elseif (not menu.isReadOnly) and hasloop[0] then
				-- loops on player occupied ship is allowed, so do this check after the player occupied check
				table.remove(menu.selectableships, i)
			end
		end
		for i, ship in ipairs(menu.selectableships) do
			local name = ffi.string(C.GetComponentName(ship))
			local idcode = ffi.string(C.GetObjectIDCode(ship))
			local class = ffi.string(C.GetComponentClass(ship))
			local primarypurpose, icon, macro, hasanymod = GetComponentData(ConvertStringTo64Bit(tostring(ship)), "primarypurpose", "icon", "macro", "hasanymod")
			menu.selectableships[i] = { ship = ship, icon = icon, name = name, objectid = idcode, class = class, purpose = primarypurpose, macro = macro, hasanymod = hasanymod }
		end
		table.sort(menu.selectableships, Helper.sortShipsByClassAndPurpose)

		if not menu.object then
			menu.object = menu.selectableships[1] and menu.selectableships[1].ship
		end
		menu.macro = ""
		menu.customshipname = ""
		menu.useloadoutname = false
		menu.loadoutName = ""
		menu.playershipname = nil

		menu.class = ""
		menu.repairplan = {}
		if menu.object then
			menu.class = ffi.string(C.GetComponentClass(menu.object))
			menu.damagedcomponents = menu.determineNeededRepairs(menu.object)
			menu.validLoadoutPossible = (not menu.isReadOnly) and menu.container and C.CanGenerateValidLoadout(menu.container, GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro"))

			local aipilot = GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "assignedaipilot")
			if aipilot then
				menu.captainSelected = true
			else
				menu.captainSelected = false
			end
		else
			menu.object = 0
		end

		menu.shipgroups = {}
		for _, ship in ipairs(menu.selectableships) do
			local hastask = false
			local n = C.GetNumOrders(ship.ship)
			local buf = ffi.new("Order[?]", n)
			n = C.GetOrders(buf, n, ship.ship)
			for i = 0, n - 1 do
				if ffi.string(buf[i].orderdef) == "Equip" then
					local params = GetOrderParams(ConvertStringTo64Bit(tostring(ship.ship)), tonumber(buf[i].queueidx))
					hastask = params[1].value
					break
				elseif ffi.string(buf[i].orderdef) == "Repair" then
					hastask = true
					break
				end
			end

			if (not ship.hasanymod) and (not hastask) then
				local i = menu.findMacroIdx(menu.shipgroups, ship.macro)
				if i then
					table.insert(menu.shipgroups[i].ships, ship)
				else
					table.insert(menu.shipgroups, { idx = #menu.shipgroups + 1, macro = ship.macro, ships = { ship }, shipdata = {}, states = {} })
				end
			else
				table.insert(menu.shipgroups, { ship = ship })
			end
		end

		menu.selectableshipsbyclass = {}
		for i, entry in ipairs(menu.shipgroups) do
			if entry.ships then
				if #entry.ships > 1 then
					local groupentry = { group = i }
					if menu.selectableshipsbyclass[entry.ships[1].class] then
						table.insert(menu.selectableshipsbyclass[entry.ships[1].class], groupentry)
					else
						menu.selectableshipsbyclass[entry.ships[1].class] = { groupentry }
					end
				end
				for _, ship in ipairs(entry.ships) do
					local shipentry = { ship = ship, grouped = #entry.ships > 1, groupidx = i }
					if menu.selectableshipsbyclass[ship.class] then
						table.insert(menu.selectableshipsbyclass[ship.class], shipentry)
					else
						menu.selectableshipsbyclass[ship.class] = { shipentry }
					end
				end
			else
				if menu.selectableshipsbyclass[entry.ship.class] then
					table.insert(menu.selectableshipsbyclass[entry.ship.class], entry.ship)
				else
					menu.selectableshipsbyclass[entry.ship.class] = { entry.ship }
				end
			end
		end

	elseif menu.mode == "modify" then
		menu.selectableships = {}
		if menu.modeparam[1] then
			for _, ship in pairs(menu.modeparam[2]) do
				--print("adding " .. ffi.string(C.GetComponentName(ship)) .. " " .. tostring(ship) .. " to list of ships.")
				table.insert(menu.selectableships, ship)
			end
			for i = #menu.selectableships, 1, -1 do
				if ffi.string(C.GetOwnerDetails(menu.selectableships[i]).factionID) ~= "player" then
					table.remove(menu.selectableships, i)
				elseif menu.selectableships[i] == C.GetPlayerOccupiedShipID() then
					menu.object = menu.selectableships[i]
				end
			end
		else
			Helper.ffiVLA(menu.selectableships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, menu.container, "player")
			for i = #menu.selectableships, 1, -1 do
				if not C.CanContainerEquipShip(menu.container, menu.selectableships[i]) then
					table.remove(menu.selectableships, i)
				elseif ffi.string(C.GetOwnerDetails(menu.selectableships[i]).factionID) ~= "player" then
					table.remove(menu.selectableships, i)
				elseif menu.selectableships[i] == C.GetPlayerOccupiedShipID() then
					menu.object = menu.selectableships[i]
				end
			end
		end

		table.sort(menu.selectableships, Helper.sortUniverseIDName)

		if not menu.object then
			menu.object = menu.selectableships[1]
		end
		menu.macro = ""

		menu.class = ""
		if menu.object then
			menu.class = ffi.string(C.GetComponentClass(menu.object))
			menu.validLoadoutPossible = (not menu.isReadOnly) and menu.container and C.CanGenerateValidLoadout(menu.container, GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro"))

			local fficurrentloadoutstats = C.GetCurrentLoadoutStatistics4(menu.object)
			menu.initialLoadoutStatistics = Helper.convertLoadoutStats(fficurrentloadoutstats)
		else
			menu.object = 0
		end

		menu.selectableshipsbyclass = {}
		for _, ship in ipairs(menu.selectableships) do
			local class = ffi.string(C.GetComponentClass(ship))
			if menu.selectableshipsbyclass[class] then
				table.insert(menu.selectableshipsbyclass[class], ship)
			else
				menu.selectableshipsbyclass[class] = { ship }
			end
		end

		menu.prepareModWares()
	elseif menu.mode == "customgamestart" then
		menu.object = 0
		local options = ""
		if menu.modeparam.playerpropertyid then
			menu.macro = menu.modeparam.propertymacro or ""
			menu.customgamestartpeopledef = menu.modeparam.propertypeopledef or ""
			menu.customgamestartpeoplefillpercentage = menu.modeparam.propertypeoplefillpercentage or 100
			if menu.customgamestartpeoplefillpercentage == -1 then
				menu.customgamestartpeoplefillpercentage = 100
			end

			menu.customgamestartpilot = {}
			if menu.macro ~= "" then
				local buf = ffi.new("CustomGameStartPersonEntry[1]")
				buf[0].numskills = C.GetNumSkills()
				buf[0].skills = Helper.ffiNewHelper("SkillInfo[?]", buf[0].numskills)
				if C.GetCustomGameStartPlayerPropertyPerson(buf, menu.modeparam.gamestartid, menu.modeparam.shipproperty, menu.modeparam.playerpropertyid) then
					menu.customgamestartpilot.race = ffi.string(buf[0].race)
					menu.customgamestartpilot.tags = ffi.string(buf[0].tags)
					menu.customgamestartpilot.skills = {}
					for i = 0, buf[0].numskills - 1 do
						local skill = ffi.string(buf[0].skills[i].id)
						menu.customgamestartpilot.skills[skill] = buf[0].skills[i].value
					end
				end
			end
		else
			local buf = ffi.new("CustomGameStartStringPropertyState[1]")
			menu.macro = ffi.string(C.GetCustomGameStartStringProperty(menu.modeparam.gamestartid, menu.modeparam.shipproperty, buf))
			options = ffi.string(buf[0].options)
			menu.customgamestartpeopledef = ffi.string(C.GetCustomGameStartStringProperty(menu.modeparam.gamestartid, menu.modeparam.shippeopleproperty, buf))
			local buf = ffi.new("CustomGameStartFloatPropertyState[1]")
			menu.customgamestartpeoplefillpercentage = tonumber(C.GetCustomGameStartFloatProperty(menu.modeparam.gamestartid, menu.modeparam.shippeoplefillpercentageproperty, buf))
			if menu.customgamestartpeoplefillpercentage == -1 then
				menu.customgamestartpeoplefillpercentage = 100
			end

			menu.customgamestartpilot = {}
			if menu.modeparam.shippilotproperty then
				local buf = ffi.new("CustomGameStartPersonEntry[1]")
				buf[0].numskills = C.GetNumSkills()
				buf[0].skills = Helper.ffiNewHelper("SkillInfo[?]", buf[0].numskills)
				if C.GetCustomGameStartShipPilot(buf, menu.modeparam.gamestartid, menu.modeparam.shippilotproperty) then
					menu.customgamestartpilot.race = ffi.string(buf[0].race)
					menu.customgamestartpilot.tags = ffi.string(buf[0].tags)
					menu.customgamestartpilot.skills = {}
					for i = 0, buf[0].numskills - 1 do
						local skill = ffi.string(buf[0].skills[i].id)
						menu.customgamestartpilot.skills[skill] = buf[0].skills[i].value
					end
				end
			end
		end
		menu.class = (menu.macro ~= "") and ffi.string(C.GetMacroClass(menu.macro)) or ""

		menu.availableshipmacros = {}
		if options ~= "" then
			for macro in string.gmatch(options, "[%a_]+") do
				table.insert(menu.availableshipmacros, macro)
			end
		else
			local n = C.GetNumAllShipMacros2(not menu.allownonplayerblueprints, not menu.modeparam.creative)
			if n > 0 then
				local buf = ffi.new("const char*[?]", n)
				n = C.GetAllShipMacros2(buf, n, not menu.allownonplayerblueprints, not menu.modeparam.creative)
				for i = 0, n - 1 do
					table.insert(menu.availableshipmacros, ffi.string(buf[i]))
				end
			end
		end

		menu.availableshipmacrosbyclass = {}
		for _, macro in ipairs(menu.availableshipmacros) do
			local class = ffi.string(C.GetMacroClass(macro))
			if menu.availableshipmacrosbyclass[class] then
				table.insert(menu.availableshipmacrosbyclass[class], macro)
			else
				menu.availableshipmacrosbyclass[class] = { macro }
			end
		end

		local buf = ffi.new("CustomGameStartStringPropertyState[1]")
		local playershipmacro = ffi.string(C.GetCustomGameStartStringProperty(menu.modeparam.gamestartid, "ship", buf))
		local ware = GetMacroData(playershipmacro, "ware")
		local islimited = GetWareData(ware, "islimited")
		if islimited then
			menu.usedLimitedMacros[playershipmacro] = (menu.usedLimitedMacros[playershipmacro] or 0) + 1
		end

		local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.modeparam.gamestartid, "playerproperty")
		if state.numvalues > 0 then
			local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
			local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.modeparam.gamestartid, "playerproperty")
			if n > 0 then
				local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
				for i = 0, n - 1 do
					buf[i].numcargo = counts[i].numcargo
					buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
				end
				n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.modeparam.gamestartid, "playerproperty")
				for i = 0, n - 1 do
					local type = ffi.string(buf[i].type)
					if type == "ship" then
						local macro = ffi.string(buf[i].macroname)
						local ware = GetMacroData(macro, "ware")
						local islimited = GetWareData(ware, "islimited")
						if islimited then
							menu.usedLimitedMacros[macro] = (menu.usedLimitedMacros[macro] or 0) + buf[i].count
						end
					end
				end
			end
		end
		if (menu.macro ~= "") and menu.usedLimitedMacros[menu.macro] then
			menu.usedLimitedMacros[menu.macro] = math.max(0, menu.usedLimitedMacros[menu.macro] - menu.modeparam.propertycount)
		end
	elseif menu.mode == "comparison" then
		menu.object = 0
		menu.macro = Helper.getShipComparisonMacro(menu.modeparam[1]) or ""
		menu.class = ffi.string(C.GetMacroClass(menu.macro))

		menu.availableshipmacros = {}
		for _, library in ipairs(config.comparisonShipLibraries) do
			local data = GetLibrary(library)
			for _, entry in ipairs(data) do
				table.insert(menu.availableshipmacros, entry.id)
			end
		end

		menu.availableshipmacrosbyclass = {}
		for _, macro in ipairs(menu.availableshipmacros) do
			local class = ffi.string(C.GetMacroClass(macro))
			if menu.availableshipmacrosbyclass[class] then
				table.insert(menu.availableshipmacrosbyclass[class], macro)
			else
				menu.availableshipmacrosbyclass[class] = { macro }
			end
		end
	end

	menu.hasDefaultLoadout = false
	menu.defaultLoadoutMacros = {}
	if (menu.object ~= 0) or (menu.macro ~= "") then
		local macro
		if menu.macro ~= "" then
			macro = menu.macro
		else
			macro = GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro")
		end
		menu.hasDefaultLoadout = C.HasDefaultLoadout2(macro, true)
		if menu.hasDefaultLoadout then
			local n = C.GetNumDefaultLoadoutMacros(macro)
			local buf = ffi.new("const char*[?]", n)
			n = C.GetDefaultLoadoutMacros(buf, n, macro)
			for i = 0, n - 1 do
				menu.defaultLoadoutMacros[ffi.string(buf[i])] = true
			end
		end
	end

	menu.equipmentsearchtext = {}
	menu.loadoutName = ""
	if (menu.mode == "purchase") or (menu.mode == "upgrade") or (menu.mode == "customgamestart") or (menu.mode == "comparison") then
		menu.upgradetypeMode = "engine"
	elseif menu.mode == "modify" then
		menu.upgradetypeMode = "shipmods"
	end
	menu.loadouts = {}

	menu.modCategory = "basic"

	menu.topRows = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	local upgradeplan, crew
	if state then
		upgradeplan, crew = menu.onRestoreState(state)
	elseif menu.mode == "customgamestart" then
		menu.software = {}
		for i, upgradetype in ipairs(Helper.upgradetypes) do
			if upgradetype.supertype == "software" then
				menu.software[upgradetype.type] = {}
				if menu.macro ~= "" then
					local n = C.GetNumSoftwareSlots(0, menu.macro)
					local buf = ffi.new("SoftwareSlot[?]", n)
					n = C.GetSoftwareSlots(buf, n, 0, menu.macro)
					for j = 0, n - 1 do
						local entry = {}
						entry.maxsoftware = ffi.string(buf[j].max)
						entry.currentsoftware = ffi.string(buf[j].current)
						table.insert(menu.software[upgradetype.type], entry)
					end
				end
			end
		end

		if menu.modeparam.playerpropertyid then
			if menu.macro ~= "" then
				local loadout = Helper.getLoadoutHelper2(C.GetCustomGameStartPlayerPropertyLoadout, C.GetCustomGameStartPlayerPropertyLoadoutCounts, "UILoadout2", menu.modeparam.gamestartid, menu.modeparam.shipproperty, menu.modeparam.playerpropertyid)
				upgradeplan = Helper.convertLoadout(menu.object, menu.macro, loadout, menu.software, "UILoadout2")
			end
		else
			local loadout = Helper.getLoadoutHelper2(C.GetCustomGameStartLoadoutProperty2, C.GetCustomGameStartLoadoutPropertyCounts2, "UILoadout2", menu.modeparam.gamestartid, menu.modeparam.shiploadoutproperty)
			upgradeplan = Helper.convertLoadout(menu.object, menu.macro, loadout, menu.software, "UILoadout2")
		end
	elseif menu.mode == "comparison" then
		if menu.macro ~= "" then
			menu.software = {}
			for i, upgradetype in ipairs(Helper.upgradetypes) do
				if upgradetype.supertype == "software" then
					menu.software[upgradetype.type] = {}
					local n = C.GetNumSoftwareSlots(0, menu.macro)
					local buf = ffi.new("SoftwareSlot[?]", n)
					n = C.GetSoftwareSlots(buf, n, 0, menu.macro)
					for j = 0, n - 1 do
						local entry = {}
						entry.maxsoftware = ffi.string(buf[j].max)
						entry.currentsoftware = ffi.string(buf[j].current)
						table.insert(menu.software[upgradetype.type], entry)
					end
				end
			end

			upgradeplan = Helper.getShipComparisonUpgradeplan(menu.modeparam[1])
		end
	end

	if menu.container then
		menu.moddingdiscounts = GetComponentData(menu.container, "moddingdiscounts")
		menu.moddingdiscounts.totalfactor = 1
		for _, entry in ipairs(menu.moddingdiscounts) do
			menu.moddingdiscounts.totalfactor = menu.moddingdiscounts.totalfactor - entry.amount / 100
		end

		menu.repairdiscounts = GetComponentData(menu.container, "repairdiscounts")
		menu.repairdiscounts.totalfactor = 1
		for _, entry in ipairs(menu.repairdiscounts) do
			menu.repairdiscounts.totalfactor = menu.repairdiscounts.totalfactor - entry.amount / 100
		end

		menu.hiringdiscounts = GetComponentData(menu.container, "hiringdiscounts")
		menu.hiringdiscounts.totalfactor = 1
		for _, entry in ipairs(menu.hiringdiscounts) do
			menu.hiringdiscounts.totalfactor = menu.hiringdiscounts.totalfactor - entry.amount / 100
		end
	else
		menu.moddingdiscounts = { totalfactor = 1 }
		menu.repairdiscounts  = { totalfactor = 1 }
		menu.hiringdiscounts  = { totalfactor = 1 }
	end

	menu.displayMainFrame()

	AddUITriggeredEvent(menu.name, menu.upgradetypeMode)

	menu.getDataAndDisplay(upgradeplan, crew, nil, true)

	if not menu.bindingRegistered then
		menu.bindingRegistered = true
		RegisterAddonBindings("ego_detailmonitor", "undo")
		Helper.setKeyBinding(menu, menu.hotkey)
	end
end

function menu.onShowMenuSound()
	if not C.IsNextStartAnimationSkipped(false) then
		PlaySound("ui_config_ship_open")
	else
		PlaySound("ui_menu_changed")
	end
end

function menu.displayMainFrame()
	Helper.removeAllWidgetScripts(menu, config.mainLayer)

	menu.mainFrame = Helper.createFrameHandle(menu, {
		layer = config.mainLayer,
		standardButtons = { back = true, close = menu.mode ~= "customgamestart" },
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	})

	-- construction map
	menu.mainFrame:addRenderTarget({width = menu.mapData.width, height = menu.mapData.height, x = menu.mapData.offsetX, y = menu.mapData.offsetY, scaling = false, alpha = 100})

	menu.mainFrame:display()
end

function menu.displayLeftBar(frame)
	local leftBar = config.leftBar
	if menu.mode == "modify" then
		leftBar = config.leftBarMods
	end
	local spacingHeight = menu.frameworkData.sidebarWidth / 4
	local maxSlotWidth = math.floor((menu.slotData.width - 8 * Helper.borderSize) / 9)

	local ftable = frame:addTable(2, { tabOrder = 2, width = menu.frameworkData.sidebarWidth + menu.frameworkData.scaleWidth + Helper.borderSize, height = 0, x = menu.frameworkData.offsetX, y = menu.slotData.offsetY + menu.titleData.height + 2 * Helper.borderSize + maxSlotWidth, scaling = false, reserveScrollBar = false })
	if (menu.upgradetypeMode == nil) and menu.setdefaulttable then
		ftable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	ftable:setColWidth(1, menu.frameworkData.scaleWidth)

	-- Fallback if nothing is selected yet, so if it is a shipyard show the groups, if not do not (so this condition can change when looking at a equipment dock)
	local iscapship = menu.container and GetComponentData(menu.container, "isshipyard") or false
	-- If we have an object or a macro use its size information
	if menu.object ~= 0 then
		iscapship = C.IsComponentClass(menu.object, "ship_l") or C.IsComponentClass(menu.object, "ship_xl")
	elseif menu.macro ~= "" then
		iscapship = IsMacroClass(menu.macro, "ship_l") or IsMacroClass(menu.macro, "ship_xl")
	end

	local found = true
	for _, entry in ipairs(leftBar) do
		local condition = true
		if condition and (entry.iscapship ~= nil) then
			condition = entry.iscapship == iscapship
		end
		if condition and (entry.customgamestart ~= nil) then
			condition = entry.customgamestart == (menu.mode == "customgamestart")
		end
		if condition and (entry.comparison ~= nil) then
			condition = entry.comparison == (menu.mode == "comparison")
		end
		if condition and (entry.hascontainer ~= nil) then
			condition = entry.hascontainer == (menu.container ~= nil)
		end

		if condition then
			if entry.spacing then
				local row = ftable:addRow(false, { fixed = true })
				row[1]:setColSpan(2):createIcon("mapst_seperator_line", { width = menu.frameworkData.sidebarWidth + menu.frameworkData.scaleWidth + Helper.borderSize, height = spacingHeight })
			else
				local active, skip = false, false
				local selected = entry.mode == menu.upgradetypeMode
				local prevSelected = entry.mode == menu.prevUpgradetypeMode
				local missing = false
				local overrideMode, overrideSlot
				local count, total = 0, 0
				local canequip = true
				if (menu.mode == "upgrade") and (not menu.isReadOnly) and (menu.object ~= 0) then
					canequip = C.CanContainerEquipShip(menu.container, menu.object)
				end
				local mouseovertext

				local upgradetype = Helper.findUpgradeType(entry.mode)

				if menu.mode == "modify" then
					local upgradetype = Helper.findUpgradeType(entry.upgrademode)
					if entry.upgrademode == "paint" then
						active = true
					elseif (entry.upgrademode == "ship") or (menu.slots[entry.upgrademode] and ((menu.slots[entry.upgrademode].count > 0) or (#menu.slots[entry.upgrademode] > 0))) then
						active = not menu.modeparam[1]
						if ((entry.upgrademode == "turret") and next(menu.groups)) or (entry.upgrademode == "shield") then
							active = active and (#menu.shieldgroups > 0)
							if #menu.shieldgroups == 0 then
								mouseovertext = ColorText["text_negative"] .. ReadText(1001, 4808) .. "\27X"
							end
						elseif menu.slots[entry.upgrademode] and (menu.slots[entry.upgrademode].count > 0) then
							local found = false
							for _, slot in ipairs(menu.slots[entry.upgrademode]) do
								if slot.currentmacro ~= "" then
									found = true
									break
								end
							end
							active = active and found
							if not found then
								mouseovertext = ColorText["text_negative"] .. ReadText(1001, 4808) .. "\27X"
							end
						end
					else
						mouseovertext = ColorText["text_error"] .. ReadText(1001, 39) .. "\27X"
					end
				elseif entry.mode == "repair" then
					if menu.objectgroup then
						for i, ship in ipairs(menu.objectgroup.ships) do
							if #menu.objectgroup.shipdata[i].damagedcomponents > 0 then
								active = true
								total = total + #menu.objectgroup.shipdata[i].damagedcomponents
								if menu.repairplan and menu.repairplan[tostring(ship.ship)] then
									for componentidstring in pairs(menu.repairplan[tostring(ship.ship)]) do
										count = count + 1
									end
								end
							end
						end
					else
						if #menu.damagedcomponents > 0 then
							active = true
							total = #menu.damagedcomponents
							if menu.repairplan and menu.repairplan[tostring(menu.object)] then
								for componentidstring in pairs(menu.repairplan[tostring(menu.object)]) do
									count = count + 1
								end
							end
						end
					end
				elseif entry.mode == "settings" then
					if (menu.object ~= 0) or (menu.macro ~= "") then
						active = true
					end
				elseif (entry.mode == "enginegroup") or (entry.mode == "turretgroup") then
					skip = not canequip
					if next(menu.groups) then
						active = true
						local curslotsizepriority
						for slot, groupdata in pairs(menu.groups) do
							if groupdata[upgradetype.grouptype] and (groupdata[upgradetype.grouptype].total > 0) then
								if groupdata.slotsize and (groupdata.slotsize ~= "") then
									local sizeorder = Helper.slotSizeOrder[groupdata.slotsize] or 0
									if (not curslotsizepriority) or (sizeorder < curslotsizepriority) then
										curslotsizepriority = sizeorder
										overrideSlot = slot
									end
								end
							end
						end
						for _, upgradetype in ipairs(Helper.upgradetypes) do
							if upgradetype.supertype == "group" then
								for slot, group in pairs(menu.upgradeplan[upgradetype.type]) do
									if (entry.mode == "enginegroup") == (menu.groups[slot]["engine"].total > 0) then
										if (menu.groups[slot][upgradetype.grouptype].total > 0) then
											if upgradetype.mergeslots then
												count = count + ((menu.upgradeplan[upgradetype.type][slot].count > 0) and 1 or 0)
												total = total + 1
											else
												count = count + menu.upgradeplan[upgradetype.type][slot].count
												total = total + menu.groups[slot][upgradetype.grouptype].total
											end
										end
									end
								end
							end
						end
					end
					for _, upgradetype in ipairs(Helper.upgradetypes) do
						if upgradetype.supertype == "group" then
							if upgradetype.allowempty == false then
								if ((upgradetype.grouptype == "engine") and (entry.mode == "enginegroup")) or ((upgradetype.grouptype == "turret") and (entry.mode == "turretgroup")) or ((upgradetype.grouptype ~= "engine") and (upgradetype.grouptype ~= "turret")) then
									for slot, group in pairs(menu.upgradeplan[upgradetype.type]) do
										if (group.macro == "") and (menu.groups[slot][upgradetype.grouptype].total > 0) then
											missing = true
											break
										end
									end
								end
							end
						end
					end
				elseif entry.mode == "software" then
					if menu.software[entry.mode] and (#menu.software[entry.mode] > 0) then
						active = true
						total = #menu.software[entry.mode]
						for slot, ware in ipairs(menu.upgradeplan[entry.mode]) do
							if ware ~= "" then
								count = count + 1
							end
						end
						for slot, slotdata in ipairs(menu.software[upgradetype.type]) do
							if #slotdata.possiblesoftware > 0 then
								if (slotdata.defaultsoftware ~= 0) and (menu.upgradeplan[upgradetype.type][slot] == "") then
									missing = true
									break
								end
							end
						end
					end
				elseif entry.mode == "consumables" then
					for _, upgradetype in ipairs(Helper.upgradetypes) do
						if upgradetype.supertype == "ammo" then
							if next(menu.ammo[upgradetype.type]) then
								local ammocount, capacity = menu.getAmmoUsage(upgradetype.type)
								for macro, amount in pairs(menu.upgradeplan[upgradetype.type]) do
									if (ammocount > 0) or ((capacity > 0) and menu.isAmmoCompatible(upgradetype.type, macro)) then
										active = true
										count = count + ammocount
										total = total + capacity
										break
									end
								end

								if ((ammocount > 0) or (capacity > 0)) and active then
									if ammocount > capacity then
										missing = true
									end
								end
							end
						end
					end
				elseif entry.mode == "crew" then
					if (menu.object ~= 0) or (menu.macro ~= "") then
						active = menu.objectgroup == nil
						if menu.crew.capacity > 0 then
							if active then
								if menu.mode == "customgamestart" then
									count = ((menu.customgamestartpeopledef == "") and 0 or Helper.round(menu.crew.capacity * menu.customgamestartpeoplefillpercentage / 100)) + (menu.modeparam.playerpropertyid and 1 or 0)
									total = menu.crew.capacity + (menu.modeparam.playerpropertyid and 1 or 0)
								else
									count = menu.crew.total + menu.crew.hired - #menu.crew.fired + (menu.captainSelected and 1 or 0)
									total = menu.crew.capacity + 1
								end
							end
							if menu.usemacro and (not menu.captainSelected) then
								missing = true
							end
							if #menu.crew.unassigned > 0 then
								missing = true
							end
						else
							if active then
								if menu.mode == "customgamestart" then
									active = active and (menu.modeparam.playerpropertyid ~= nil)
									count = menu.modeparam.playerpropertyid and 1 or 0
									total = menu.modeparam.playerpropertyid and 1 or 0
								else
									count = menu.captainSelected and 1 or 0
									total = 1
								end
							end
							if menu.usemacro and (not menu.captainSelected) then
								missing = true
							end
						end
					end
				elseif upgradetype and (upgradetype.supertype == "macro") then
					skip = not canequip
					if menu.slots[entry.mode] and (menu.slots[entry.mode].count > 0) then
						active = true
						total = menu.slots[entry.mode].count
						for slot, data in ipairs(menu.upgradeplan[entry.mode]) do
							if data.macro ~= "" then
								count = count + 1
							end
						end
						local curslotsizepriority
						for slot, slotdata in ipairs(menu.slots[entry.mode]) do
							if not slotdata.isgroup then
								if slotdata.slotsize and (slotdata.slotsize ~= "") then
									local sizeorder = Helper.slotSizeOrder[slotdata.slotsize] or 0
									if (not curslotsizepriority) or (sizeorder < curslotsizepriority) then
										curslotsizepriority = sizeorder
										overrideSlot = slot
									end
								end
							end
						end
					else
						-- override engine category to point to group with engines
						if upgradetype.type == "engine" then
							if next(menu.groups) then
								active = true
								overrideMode = "enginegroup"
								for slot, groupdata in pairs(menu.groups) do
									if groupdata[upgradetype.type].total > 0 then
										overrideSlot = slot
										break
									end
								end
							end
						end
					end
					for slot, data in pairs(menu.upgradeplan[upgradetype.type]) do
						if data.macro == "" then
							if (upgradetype.allowempty == false) or C.IsSlotMandatory(menu.object, 0, menu.macro, false, upgradetype.type, slot) then
								missing = true
								break
							end
						end
					end
				else
					skip = not canequip
					if menu.slots[entry.mode] and (#menu.slots[entry.mode] > 0) then
						active = true
						total = #menu.slots[entry.mode]
						for slot, data in ipairs(menu.upgradeplan[entry.mode]) do
							if data.macro ~= "" then
								count = count + 1
							end
						end
					end
					if upgradetype.allowempty == false then
						for slot, data in pairs(menu.upgradeplan[upgradetype.type]) do
							if data.macro == "" then
								missing = true
								break
							end
						end
					end
				end

				if not skip then
					if menu.mode == "purchase" then
						active = active and (menu.validLicence == true)
					end

					-- if nothing selected yet, select this one if active
					if (not found) and active and (menu.upgradetypeMode ~= nil) then
						found = true
						selected = true
						menu.upgradetypeMode = entry.mode
						menu.selectMapMacroSlot()
					end

					-- if selected, but not active, select next active entry
					if selected and (not active) then
						found = false
						selected = false
					end

					local row = ftable:addRow(active, { fixed = true })
					if total > 0 then
						local height = math.floor((menu.frameworkData.sidebarWidth - 2 * menu.scaleSize) * math.min(count, total) / total)
						row[1]:createIcon("solid", { cellBGColor = active and Color["row_background_blue"] or Color["row_background_unselectable"], width = menu.scaleSize, height = height, x = menu.scaleSize, y = (menu.frameworkData.sidebarWidth - height - 2 * menu.scaleSize) / 2 })
					else
						row[1]:createText("", { cellBGColor = active and Color["row_background_blue"] or Color["row_background_unselectable"], x = 0, y = 0 })
					end

					if selected then
						menu.selectedRows.left = row.index
					elseif prevSelected then
						menu.selectedRows.left = row.index
					end
					if mouseovertext then
						mouseovertext = entry.name .. "\n" .. mouseovertext
					else
						mouseovertext = entry.name
					end
					row[2]:createButton({ active = active, height = menu.frameworkData.sidebarWidth, mouseOverText = mouseovertext, bgColor = selected and Color["row_background_selected"] or Color["button_background_default"], helpOverlayID = "shipconfig_leftbar_" .. entry.mode, helpOverlayText = " ", helpOverlayHighlightOnly = true }):setIcon(entry.icon, { color = function () return menu.buttonLeftBarColor(entry.mode, active, missing) end })
					row[2].handlers.onClick = function () return menu.buttonLeftBar(entry.mode, row.index, overrideMode, overrideSlot) end
				elseif selected then
					found = false
				end
			end
		else
			if entry.mode == menu.upgradetypeMode then
				found = false
			end
		end
	end
	ftable:setTopRow(menu.topRows.left)
	ftable:setSelectedRow(menu.selectedRows.left)
	menu.topRows.left = nil
	menu.selectedRows.left = nil
end

function menu.buttonLeftBarColor(mode, active, missing)
	if active then
		if menu.mode ~= "modify" then
			if (mode == "enginegroup") or (mode == "turretgroup") then
				for _, upgradegroup in ipairs(menu.groups) do
					if (upgradegroup["engine"].total > 0) == (mode == "enginegroup") then
						for _, upgradetype2 in ipairs(Helper.upgradetypes) do
							if upgradetype2.supertype == "group" then
								menu.groupedupgrades[upgradetype2.grouptype] = {}
								for _, macro in ipairs(upgradegroup[upgradetype2.grouptype].possiblemacros) do
									if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(mode, macro, menu.equipmentsearchtext) then
										return missing and Color["icon_error"] or Color["icon_normal"]
									end
								end
							end
						end
					end
				end
			elseif mode == "software" then
				if menu.software[mode] then
					for slot, slotdata in ipairs(menu.software[mode]) do
						for i, software in ipairs(slotdata.possiblesoftware) do
							if i >= slotdata.defaultsoftware then
								if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(mode, software, menu.equipmentsearchtext) then
									return missing and Color["icon_error"] or Color["icon_normal"]
								end
							end
						end
					end
				end
			elseif mode == "consumables" then
				for _, upgradetype in ipairs(Helper.upgradetypes) do
					if upgradetype.supertype == "ammo" then
						if next(menu.ammo[upgradetype.type]) then
							local total, capacity = menu.getAmmoUsage(upgradetype.type)
							local display = false
							for macro, _ in pairs(menu.ammo[upgradetype.type]) do
								if (total > 0) or menu.isAmmoCompatible(upgradetype.type, macro) then
									display = true
									break
								end
							end

							if ((total > 0) or (capacity > 0)) and display then
								for macro in pairs(menu.ammo[upgradetype.type]) do
									if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(mode, macro, menu.equipmentsearchtext) then
										return missing and Color["icon_error"] or Color["icon_normal"]
									end
								end
							end
						end
					end
				end
			elseif (mode ~= "crew") and (mode ~= "repair") and (mode ~= "settings") and (mode ~= "paintmods") then
				local upgradetype = Helper.findUpgradeType(mode)
				if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
					local slots = menu.slots[mode]
					for _, slot in ipairs(slots) do
						for _, macro in ipairs(slot.possiblemacros) do
							if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(mode, macro, menu.equipmentsearchtext) then
								return missing and Color["icon_error"] or Color["icon_normal"]
							end
						end
					end
				end
			end
		end
		return missing and Color["icon_error"] or Color["icon_normal"]
	end
	return missing and Color["icon_error_inactive"] or Color["icon_inactive"]
end

function menu.buttonSlotColor(slot, haserror)
	if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
		local upgradegroup = menu.groups[slot]
		if upgradegroup then
			for _, upgradetype2 in ipairs(Helper.upgradetypes) do
				if upgradetype2.supertype == "group" then
					menu.groupedupgrades[upgradetype2.grouptype] = {}
					for _, macro in ipairs(upgradegroup[upgradetype2.grouptype].possiblemacros) do
						if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(menu.upgradetypeMode, macro, menu.equipmentsearchtext) then
							return haserror and Color["icon_error"] or Color["icon_normal"]
						end
					end
				end
			end
		end
	elseif (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") and (menu.upgradetypeMode ~= "repair") and (menu.upgradetypeMode ~= "settings") then
		local upgradetype = Helper.findUpgradeType(menu.upgradetypeMode)
		if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
			local slots = menu.slots[menu.upgradetypeMode]
			if slots[slot] then
				for _, macro in ipairs(slots[slot].possiblemacros) do
					if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(menu.upgradetypeMode, macro, menu.equipmentsearchtext) then
						return haserror and Color["icon_error"] or Color["icon_normal"]
					end
				end
			end
		end
	end
	return haserror and Color["icon_error_inactive"] or Color["icon_inactive"]
end

function menu.getPresetLoadouts()
	menu.loadouts = {}
	if not menu.isReadOnly then
		if (menu.usemacro and (menu.macro ~= "")) or ((menu.mode == "upgrade") and (menu.object ~= 0)) then
			local currentmacro = (menu.macro ~= "") and menu.macro or GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro")
			local n = C.GetNumLoadoutsInfo(menu.object, menu.macro)
			local buf = ffi.new("UILoadoutInfo[?]", n)
			n = C.GetLoadoutsInfo(buf, n, menu.object, menu.macro)
			for i = 0, n - 1 do
				local id = ffi.string(buf[i].id)
				local active = false
				local mouseovertext = ""
				local numinvalidpatches = ffi.new("uint32_t[?]", 1)
				if not C.IsLoadoutValid(menu.object, menu.macro, id, numinvalidpatches) then
					local numpatches = numinvalidpatches[0]
					local patchbuf = ffi.new("InvalidPatchInfo[?]", numpatches)
					numpatches = C.GetLoadoutInvalidPatches(patchbuf, numpatches, menu.object, menu.macro, id)
					mouseovertext = ReadText(1001, 2685) .. ReadText(1001, 120)			-- Missing, old or disabled extensions:
					for j = 0, numpatches - 1 do
						if j > 3 then
							mouseovertext = mouseovertext .. "\n- ..."
							break
						end
						mouseovertext = mouseovertext .. "\n- " .. ffi.string(patchbuf[j].name) .. " (" .. ffi.string(patchbuf[j].id) .. " - " .. ffi.string(patchbuf[j].requiredversion) .. ")"
						if patchbuf[j].state == 2 then
							mouseovertext = mouseovertext .. " " .. ReadText(1001, 2686)
						elseif patchbuf[j].state == 3 then
							mouseovertext = mouseovertext .. " " .. ReadText(1001, 2687)
						elseif patchbuf[j].state == 4 then
							mouseovertext = mouseovertext .. " " .. string.format(ReadText(1001, 2688), ffi.string(patchbuf[j].installedversion))
						end
					end
				elseif not C.IsLoadoutCompatible(currentmacro, id) then
					mouseovertext = ReadText(1026, 8024)
				elseif menu.mode == "customgamestart" then
					active = true
				elseif menu.mode == "comparison" then
					active = C.CanApplyKnownLoadout(menu.macro, id)
					if not active then
						mouseovertext = ReadText(1026, 8015)
					end
				else
					active = C.CanBuildLoadout(menu.container, menu.object, menu.macro, id)
					if not active then
						mouseovertext = ReadText(1026, 8011)
					end
				end
				table.insert(menu.loadouts, { id = id, name = ffi.string(buf[i].name), icon = ffi.string(buf[i].iconid), deleteable = buf[i].deleteable, active = active, mouseovertext = mouseovertext })
			end
		end
		table.sort(menu.loadouts, Helper.sortName)

		local missionloadouts = {}
		if (menu.mode == "purchase") or (menu.mode == "upgrade") then
			if (menu.object ~= 0) or (menu.macro ~= "") then
				local currentmacro = (menu.macro ~= "") and menu.macro or GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro")
				local n = C.GetNumRequestedMissionShips()
				local buf = ffi.new("MissionShipDeliveryInfo[?]", n)
				n = C.GetRequestedMissionShips(buf, n)
				for i = 0, n - 1 do
					local id = buf[i].missionid
					local macro = ffi.string(buf[i].macroname)
					if macro == currentmacro then
						local missiondetails = C.GetMissionIDDetails(id)
						local active = C.CanBuildMissionLoadout(menu.container, id, macro)
						if not active then
							mouseovertext = ReadText(1026, 8011)
						end
						table.insert(missionloadouts, 1, { id = "mission" .. i, name = ColorText["text_mission"] .. "\27[" .. "missiontype_" .. ffi.string(missiondetails.subType) .. "] " .. ffi.string(missiondetails.missionName) .. "\27X", icon = "", deleteable = false, mission = { id = id, macro = macro }, active = active, mouseovertext = mouseovertext })
					end
				end
			end
		end
		table.sort(missionloadouts, Helper.sortName)
		for i, entry in ipairs(missionloadouts) do
			table.insert(menu.loadouts, i, entry)
		end

		local hasanymod = false
		for i, upgradetype in ipairs(Helper.upgradetypes) do
			local slots = (upgradetype.supertype == "group") and menu.upgradeplan[upgradetype.type] or menu.slots[upgradetype.type]
			local first = true
			for slot, macro in pairs(slots or {}) do
				if (upgradetype.supertype == "group") and (not upgradetype.pseudogroup) then
					if menu.groups[slot] and (menu.groups[slot][upgradetype.grouptype].total > 0) then
						local hasmod = menu.checkMod(upgradetype.grouptype, menu.groups[slot][upgradetype.grouptype].currentcomponent, true)
						if hasmod then
							hasanymod = true
							break
						end
					end
				elseif upgradetype.supertype == "macro" then
					if type(slot) == "number" then
						local hasmod = menu.checkMod(upgradetype.type, slots[slot].component)
						if hasmod then
							hasanymod = true
							break
						end
					end
				end
			end
			if hasanymod then
				break
			end
		end

		if not menu.hasDefaultLoadout then
			local text = ColorText["text_warning"] .. (menu.container and string.format(ReadText(1026, 8026), ffi.string(C.GetComponentName(menu.container))) or ReadText(1026, 8027)) .. "\n\n\27X"
			local removingitems = ""
			for i, entry in ipairs(menu.missingUpgrades) do
				removingitems = removingitems .. ((i == 1) and text or "\n") .. "· " .. entry.amount .. ReadText(1001, 42) .. " " .. entry.name
			end

			local mouseovertext = ""
			if hasanymod then
				if mouseovertext ~= "" then
					mouseovertext = mouseovertext .. "\n\n"
				end
				mouseovertext = mouseovertext .. ColorText["text_error"] .. ReadText(1026, 8020) .. "\27X"
			end
			if removingitems ~= "" then
				if mouseovertext ~= "" then
					mouseovertext = mouseovertext .. "\n\n"
				end
				mouseovertext = mouseovertext .. removingitems
			end

			table.insert(menu.loadouts, 1, { id = "empty",	name = ReadText(1001, 7941), icon = "", deleteable = false, preset = 0,		active = menu.validLoadoutPossible and (not hasanymod),	mouseovertext = mouseovertext })
			table.insert(menu.loadouts, 2, { id = "low",	name = ReadText(1001, 7910), icon = "", deleteable = false, preset = 0.1,	active = menu.validLoadoutPossible and (not hasanymod),	mouseovertext = mouseovertext })
			table.insert(menu.loadouts, 3, { id = "medium",	name = ReadText(1001, 7911), icon = "", deleteable = false, preset = 0.5,	active = menu.validLoadoutPossible and (not hasanymod),	mouseovertext = mouseovertext })
			table.insert(menu.loadouts, 4, { id = "high",	name = ReadText(1001, 7912), icon = "", deleteable = false, preset = 1.0,	active = menu.validLoadoutPossible and (not hasanymod),	mouseovertext = mouseovertext })
		else
			table.insert(menu.loadouts, 1, { id = "default",	name = ReadText(1001, 3231), icon = "", deleteable = false,	active = menu.validLoadoutPossible and (not hasanymod),	mouseovertext = hasanymod and (ColorText["text_error"] .. ReadText(1026, 8020)) or "" })
		end
	end
end

function menu.getDataAndDisplay(upgradeplan, crew, newedit, firsttime, noundo, settings)
	-- init upgradeplan
	menu.upgradeplan = {}
	menu.upgradewares = {}
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		menu.upgradeplan[upgradetype.type] = {}
		if upgradetype.supertype ~= "group" then
			menu.upgradewares[upgradetype.type] = {}
		end
	end

	-- assemble possible upgrades (wares, macros, stock)
	if menu.mode == "comparison" then
		for _, libraryentry in ipairs(config.comparisonEquipmentLibraries) do
			local data = GetLibrary(libraryentry.library)
			for _, dataentry in ipairs(data) do
				-- check all aliases due to collision / no-collision compatibilities
				local n = C.GetNumLibraryEntryAliases(libraryentry.library, dataentry.id)
				local buf = ffi.new("const char*[?]", n)
				n = C.GetLibraryEntryAliases(buf, n, libraryentry.library, dataentry.id)
				for j = 0, n - 1 do
					local aliasid = ffi.string(buf[j])
					local entry = {}
					local ware, name = GetMacroData(aliasid, "ware", "name")
					entry.ware = ware
					entry.macro = aliasid
					entry.name = name
					entry.objectamount = 0
					entry.isFromShipyard = true

					if menu.upgradewares[libraryentry.type] then
						table.insert(menu.upgradewares[libraryentry.type], entry)
					else
						menu.upgradewares[libraryentry.type] = { entry }
					end
				end
			end
		end
	else
		local n = 0
		local buf
		if menu.mode == "customgamestart" then
			n = C.GetNumAllEquipment(not menu.allownonplayerblueprints)
			buf = ffi.new("EquipmentWareInfo[?]", n)
			n = C.GetAllEquipment(buf, n, not menu.allownonplayerblueprints)
		elseif (not menu.isReadOnly) and ((menu.mode ~= "modify") or (not menu.modeparam[1])) then
			n = C.GetNumAvailableEquipment(menu.container, "")
			buf = ffi.new("EquipmentWareInfo[?]", n)
			n = C.GetAvailableEquipment(buf, n, menu.container, "")
		end
		if n > 0 then
			for i = 0, n - 1 do
				local type = ffi.string(buf[i].type)
				local entry = {}
				entry.ware = ffi.string(buf[i].ware)
				entry.macro = ffi.string(buf[i].macro)
				if type == "software" then
					entry.name = GetWareData(entry.ware, "name")
				else
					entry.name = GetMacroData(entry.macro, "name")
				end
				entry.objectamount = 0
				entry.isFromShipyard = true
				if (type == "lasertower") or (type == "satellite") or (type == "mine") or (type == "navbeacon") or (type == "resourceprobe") then
					type = "deployable"
				end
				if type == "" then
					DebugError(string.format("Could not find upgrade type for the equipment ware: '%s'. Check the ware tags. [Florian]", entry.ware))
				else
					if menu.upgradewares[type] then
						table.insert(menu.upgradewares[type], entry)
					else
						menu.upgradewares[type] = { entry }
					end
				end
			end
		end
	end

	-- sort
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.supertype ~= "group" then
			table.sort(menu.upgradewares[upgradetype.type], Helper.sortName)
		end
	end

	-- assemble available slots/ammo/software
	menu.groups = {}
	menu.slots = {}
	menu.ammo = { missile = {}, drone = {}, deployable = {}, countermeasure = {}, }
	menu.software = {}
	menu.crew = {
		total = 0,
		capacity = 0,
		unassigned = {},
		roles = {},
		hired = 0,
		hireddetails = {},
		transferdetails = {},
		fired = {},
		ware = "crew",
		availableworkforce = 0,
		maxavailableworkforce = 0,
		availabledockcrew = 0,
		maxavailabledockcrew = 0,
	}
	if settings then
		menu.settings = settings
	else
		menu.settings = {
			blacklists = {},
			fightrules = {},
		}
	end

	if (not menu.isReadOnly) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") and ((menu.mode ~= "modify") or (not menu.modeparam[1])) then
		if C.IsComponentClass(menu.container, "ship") then
			local n = C.GetNumAllRoles()
			local buf = ffi.new("PeopleInfo[?]", n)
			n = C.GetPeople2(buf, n, menu.container, true)
			local numhireable = 0
			for i = 0, n - 1 do
				menu.crew.availabledockcrew = menu.crew.availabledockcrew + buf[i].amount
			end
			menu.crew.maxavailabledockcrew = C.GetPeopleCapacity(menu.container, "", false)
		else
			local workforceinfo = C.GetWorkForceInfo(menu.container, "")
			menu.crew.availableworkforce = workforceinfo.available
			menu.crew.maxavailableworkforce = workforceinfo.maxavailable
		end

		local minprice, maxprice = GetWareData(menu.crew.ware, "minprice", "maxprice")
		menu.crew.price = Helper.round(menu.hiringdiscounts.totalfactor * C.GetContainerBuildPriceFactor(menu.container) * (maxprice - (menu.crew.availableworkforce + menu.crew.availabledockcrew) / (menu.crew.maxavailableworkforce + menu.crew.maxavailabledockcrew) * (maxprice - minprice)))
	end

	menu.defaultpaintmod = {
		name = "",
		quality = 1,
	}
	local buf = ffi.new("UIPaintMod")
	if (menu.object ~= 0) or (menu.macro ~= "") then
		if C.GetPlayerPaintThemeMod(menu.object, menu.macro, buf) then
			menu.defaultpaintmod.name = ffi.string(buf.Name)
			menu.defaultpaintmod.ware = ffi.string(buf.Ware)
			menu.defaultpaintmod.quality = buf.Quality
			menu.defaultpaintmod.isdefault = true
		end
	end

	menu.installedPaintMod = nil
	if menu.object ~= 0 then
		local paintmod = ffi.new("UIPaintMod")
		if C.GetInstalledPaintMod(menu.object, paintmod) then
			menu.installedPaintMod = {}
			menu.installedPaintMod.name = ffi.string(paintmod.Name)
			menu.installedPaintMod.ware = ffi.string(paintmod.Ware)
			menu.installedPaintMod.quality = paintmod.Quality
			menu.installedPaintMod.amount = paintmod.Amount
			menu.installedPaintMod.isdefault = menu.defaultpaintmod.ware == menu.installedPaintMod.ware
		end
	elseif menu.macro ~= "" then
		if menu.mode == "customgamestart" then
			local buf = ffi.new("CustomGameStartStringPropertyState[1]")
			local painttheme = ffi.string(C.GetCustomGameStartStringProperty(menu.modeparam.gamestartid, menu.modeparam.paintthemeproperty, buf))
			local paintmod = ffi.new("UIPaintMod")
			if C.GetPaintThemeMod(painttheme, "player", paintmod) then
				menu.installedPaintMod = {}
				menu.installedPaintMod.name = ffi.string(paintmod.Name)
				menu.installedPaintMod.ware = ffi.string(paintmod.Ware)
				menu.installedPaintMod.quality = paintmod.Quality
				menu.installedPaintMod.amount = paintmod.Amount
				menu.installedPaintMod.isdefault = menu.defaultpaintmod.ware == menu.installedPaintMod.ware
			end
		else
			local paintmod = ffi.new("UIPaintMod")
			if C.GetPlayerPaintThemeMod(menu.object, menu.macro, paintmod) then
				menu.installedPaintMod = {}
				menu.installedPaintMod.name = ffi.string(paintmod.Name)
				menu.installedPaintMod.ware = ffi.string(paintmod.Ware)
				menu.installedPaintMod.quality = paintmod.Quality
				menu.installedPaintMod.amount = paintmod.Amount
				menu.installedPaintMod.isdefault = menu.defaultpaintmod.ware == menu.installedPaintMod.ware
			end
		end
	end

	menu.missingUpgrades = {}

	menu.groups = {}
	if (menu.usemacro and (menu.macro ~= "")) or (((menu.mode == "upgrade") or (menu.mode == "modify")) and (menu.object ~= 0)) then
		menu.setupGroupData(menu.object, menu.macro, menu.groups, true)
	end

	if menu.usemacro then
		if menu.macro ~= "" then
			menu.prepareMacroUpgradeSlots(menu.macro)
			menu.prepareMacroCrewInfo(menu.macro)
		end
	elseif (menu.mode == "upgrade") or (menu.mode == "modify") then
		if menu.object ~= 0 then
			menu.prepareComponentUpgradeSlots(menu.object, menu.slots, menu.ammo, menu.software, true)
			menu.prepareComponentCrewInfo(menu.object)

			menu.checkCurrentBuildTasks()

			if menu.objectgroup then
				for i = 1, #menu.objectgroup.ships do
					menu.objectgroup.shipdata[i] = {
						slots = {},
						groups = {},
						ammo = {},
						software = {},
					}
					menu.prepareComponentUpgradeSlots(menu.objectgroup.ships[i].ship, menu.objectgroup.shipdata[i].slots, menu.objectgroup.shipdata[i].ammo, menu.objectgroup.shipdata[i].software, false)
					menu.setupGroupData(menu.objectgroup.ships[i].ship, "", menu.objectgroup.shipdata[i].groups, false)
					menu.objectgroup.shipdata[i].damagedcomponents = menu.determineNeededRepairs(menu.objectgroup.ships[i].ship)
				end

				-- check for foreign macros (aka not sold by shipyard) - if all ships have the same as menu.object, it's fine. Otherwise the macro has to be deinstalled
				-- This is necessary as otherwise each ship in the group would need to keep track of an individual upgradeplan
				for i, upgradetype in ipairs(Helper.upgradetypes) do
					if upgradetype.supertype == "macro" then
						for j = 1, tonumber(C.GetNumUpgradeSlots(menu.object, "", upgradetype.type)) do
							if menu.upgradeplan[upgradetype.type][j].checkforeignmacro then
								local found = false
								for i = 1, #menu.objectgroup.ships do
									if menu.upgradeplan[upgradetype.type][j].macro ~= menu.objectgroup.shipdata[i].slots[upgradetype.type][j].currentmacro then
										menu.upgradeplan[upgradetype.type][j].macro = ""
										menu.slots[upgradetype.type][j].hasstock = false
										found = true
										break
									end
								end
								if not found then
									menu.upgradeplan[upgradetype.type][j].checkforeignmacro = nil
								end
							end
						end
					elseif upgradetype.supertype == "group" then
						for j, group in pairs(menu.upgradeplan[upgradetype.type]) do
							if group.checkforeignmacro then
								local found = false
								for i = 1, #menu.objectgroup.ships do
									if group.macro ~= menu.objectgroup.shipdata[i].groups[j][upgradetype.grouptype].currentmacro then
										menu.upgradeplan[upgradetype.type][j].macro = ""
										menu.groups[j][upgradetype.grouptype].hasstock = false
										found = true
										break
									end
								end
								if not found then
									menu.upgradeplan[upgradetype.type][j].checkforeignmacro = nil
								end
							end
						end
					end
				end
			end
		end
	end

	table.sort(menu.missingUpgrades, Helper.sortName)

	if menu.mode == "modify" then
		if menu.object ~= 0 then
			menu.shieldgroups = {}
			local shieldsizecounts = {}
			local n = C.GetNumShieldGroups(menu.object)
			local buf = ffi.new("ShieldGroup[?]", n)
			n = C.GetShieldGroups(buf, n, menu.object)
			for i = 0, n - 1 do
				local entry = {}
				entry.context = buf[i].context
				entry.group = ffi.string(buf[i].group)
				entry.component = buf[i].component
				table.insert(menu.shieldgroups, entry)
			end
			table.sort(menu.shieldgroups, function (a, b) return a.group < b.group end)
			for i, entry in ipairs(menu.shieldgroups) do
				if (entry.context == menu.object) and (entry.group == "") then -- mainship
					local groupinfo = C.GetUpgradeGroupInfo2(menu.object, "", entry.context, "", entry.group, "shield")
					menu.shieldgroups[i].slotsize = ffi.string(groupinfo.slotsize)
					menu.shieldgroups[i].count = groupinfo.count
					menu.shieldgroups[i].upgradetype = "shields"
				else
					local groupinfo = C.GetUpgradeGroupInfo2(menu.object, "", entry.context, "", entry.group, "engine")
					if groupinfo.total > 0 then	-- EngineGroup
						menu.shieldgroups[i].slotsize = ffi.string(groupinfo.slotsize)
						menu.shieldgroups[i].upgradetype = "engines"
					else -- TurretGroup
						local groupinfo = C.GetUpgradeGroupInfo2(menu.object, "", entry.context, "", entry.group, "turret")
						menu.shieldgroups[i].slotsize = ffi.string(groupinfo.slotsize)
						menu.shieldgroups[i].upgradetype = "turrets"
					end
				end
				menu.shieldgroups[i].sizecount = 0

				if menu.shieldgroups[i].slotsize ~= "" then
					if shieldsizecounts[menu.shieldgroups[i].upgradetype] then
						if shieldsizecounts[menu.shieldgroups[i].upgradetype][menu.shieldgroups[i].slotsize] then
							shieldsizecounts[menu.shieldgroups[i].upgradetype][menu.shieldgroups[i].slotsize] = shieldsizecounts[menu.shieldgroups[i].upgradetype][menu.shieldgroups[i].slotsize] + 1
						else
							shieldsizecounts[menu.shieldgroups[i].upgradetype][menu.shieldgroups[i].slotsize] = 1
						end
					else
						shieldsizecounts[menu.shieldgroups[i].upgradetype] = {}
						shieldsizecounts[menu.shieldgroups[i].upgradetype][menu.shieldgroups[i].slotsize] = 1
					end
					menu.shieldgroups[i].sizecount = shieldsizecounts[menu.shieldgroups[i].upgradetype][menu.shieldgroups[i].slotsize]
				end
			end
			for i, entry in ipairs(menu.shieldgroups) do
				if (entry.context == menu.object) and (entry.group == "") then
					menu.shieldgroups.hasMainGroup = true
					-- force maingroup to first index
					table.insert(menu.shieldgroups, 1, entry)
					table.remove(menu.shieldgroups, i + 1)
					break
				end
			end
		end

		if menu.installedPaintMod then
			if menu.modwares["paint"] then
				local found = false
				for i, mod in ipairs(menu.modwares["paint"]) do
					if mod.ware == menu.installedPaintMod.ware then
						found = true
						break
					end
				end
				if not found then
					table.insert(menu.modwares["paint"], menu.installedPaintMod)
				end
			else
				menu.modwares["paint"] = { menu.installedPaintMod }
			end
		end
	end

	if menu.currentSlot == nil then
		menu.determineInitialSlot()
	end

	-- assemble possible upgrades per slot
	local objectmakerraces = menu.object ~= 0 and GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "makerraceid") or (menu.macro ~= "" and GetMacroData(menu.macro, "makerraceid") or nil)
	for type, slots in pairs(menu.slots) do
		local upgradetype = Helper.findUpgradeType(type)
		if upgradetype.supertype == "macro" then
			slots.count = #slots
			local sizecounts = {}
			for i, slot in ipairs(slots) do
				if menu.upgradewares[type] then
					for _, upgradeware in ipairs(menu.upgradewares[type]) do
						if menu.checkCompatibility(upgradeware.macro, objectmakerraces) and C.IsUpgradeMacroCompatible(menu.object, 0, menu.macro, false, type, i, upgradeware.macro) then
							if upgradeware.isFromShipyard or (slot.currentmacro == upgradeware.macro) then
								table.insert(slot.possiblemacros, upgradeware.macro)
							end
						elseif slot.currentmacro and (slot.currentmacro == upgradeware.macro) then
							table.insert(slot.possiblemacros, upgradeware.macro)
						end
					end
					table.sort(slot.possiblemacros, Helper.sortMacroRaceAndShortname)
				end

				local groupinfo = C.GetUpgradeSlotGroup(menu.object, menu.macro, type, i)
				if (ffi.string(groupinfo.path) ~= "..") or (ffi.string(groupinfo.group) ~= "") then
					slot.isgroup = true
					slots.count = slots.count - 1
				end
				if not slot.isgroup then
					slot.slotname = i
					slot.slotsize = ffi.string(C.GetSlotSize(menu.object, 0, menu.macro, false, upgradetype.type, i))
					if slot.slotsize ~= "" then
						if sizecounts[slot.slotsize] then
							sizecounts[slot.slotsize] = sizecounts[slot.slotsize] + 1
						else
							sizecounts[slot.slotsize] = 1
						end
						slot.slotname = upgradetype.shorttext[slot.slotsize] .. sizecounts[slot.slotsize]
					end
				end
			end
		elseif upgradetype.supertype == "virtualmacro" then
			for i, slot in ipairs(slots) do
				if menu.upgradewares[type] then
					for _, upgradeware in ipairs(menu.upgradewares[type]) do
						if menu.checkCompatibility(upgradeware.macro, objectmakerraces) and C.IsVirtualUpgradeMacroCompatible(menu.object, menu.macro, type, i, upgradeware.macro) then
							table.insert(slot.possiblemacros, upgradeware.macro)
						end
					end
					table.sort(slot.possiblemacros, Helper.sortMacroRaceAndShortname)
				end
			end
		end
	end

	-- assemble possible upgrades per group
	for i, group in ipairs(menu.groups) do
		for j, upgradetype in ipairs(Helper.upgradetypes) do
			if upgradetype.supertype == "group" then
				local wares = menu.upgradewares[upgradetype.grouptype] or {}
				for _, upgradeware in ipairs(wares) do
					if upgradeware.macro ~= "" then
						if menu.checkCompatibility(upgradeware.macro, objectmakerraces) and C.IsUpgradeGroupMacroCompatible(menu.object, menu.macro, group.path, group.group, upgradetype.grouptype, upgradeware.macro) then
							if upgradeware.isFromShipyard or (group[upgradetype.grouptype].currentmacro == upgradeware.macro) then
								table.insert(menu.groups[i][upgradetype.grouptype].possiblemacros, upgradeware.macro)
							end
						end
					end
				end
				table.sort(menu.groups[i][upgradetype.grouptype].possiblemacros, Helper.sortMacroRaceAndShortname)
			end
		end
	end

	-- assemble possible software per slot
	for type, softwarelist in pairs(menu.software) do
		for j, software in ipairs(softwarelist) do
			software.defaultsoftware = 0
			software.possiblesoftware = {}
			local n = C.GetNumSoftwarePredecessors(software.maxsoftware)
			local buf = ffi.new("const char*[?]", n)
			n = C.GetSoftwarePredecessors(buf, n, software.maxsoftware)
			for i = 0, n - 1 do
				local ware = ffi.string(buf[i])
				if (not menu.isReadOnly) or (ware == software.currentsoftware) then
					table.insert(software.possiblesoftware, ware)
				end
				if C.IsSoftwareDefault(menu.object, menu.macro, ware) then
					software.defaultsoftware = i + 1
					if software.currentsoftware == "" then
						if upgradeplan or (menu.mode ~= "purchase") or (menu.upgradeplan[type][j] ~= "") then
							menu.upgradeplan[type][j] = ware
						end
					end
				end
			end
			if (not menu.isReadOnly) or (software.maxsoftware == software.currentsoftware) then
				table.insert(software.possiblesoftware, software.maxsoftware)
			end
			if C.IsSoftwareDefault(menu.object, menu.macro, software.maxsoftware) then
				software.defaultsoftware = #software.possiblesoftware
				if software.currentsoftware == "" then
					if upgradeplan or (menu.mode ~= "purchase") or (menu.upgradeplan[type][j] ~= "") then
						menu.upgradeplan[type][j] = software.maxsoftware
					end
				end
			end
		end
	end

	-- get preset loadouts
	menu.getPresetLoadouts()

	if upgradeplan then
		for type, upgradelist in pairs(menu.upgradeplan) do
			local upgradetype = Helper.findUpgradeType(type)
			for key, upgrade in pairs(upgradelist) do
				if upgradetype.supertype == "group" then
					local found = false
					for key2, upgrade2 in pairs(upgradeplan[type]) do
						if (upgrade2.path == upgrade.path) and (upgrade2.group == upgrade.group) then
							found = true
							menu.upgradeplan[type][key].macro = upgrade2.macro or ""
							menu.upgradeplan[type][key].count = upgrade2.count or 0
							menu.upgradeplan[type][key].ammomacro = upgrade2.ammomacro or ""
							menu.upgradeplan[type][key].weaponmode = upgrade2.weaponmode or ""
							break
						end
					end
					if not found then
						menu.upgradeplan[type][key].macro = ""
						menu.upgradeplan[type][key].count = 0
					end
				else
					local newvalue
					if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
						newvalue = upgradeplan[type][key] or { macro = "", ammomacro = "", weaponmode = "" }
					elseif (upgradetype.supertype == "software") then
						if not upgradeplan[type][key] then
							if menu.upgradeplan[type][key] ~= "" then
								if menu.software[type][key].defaultsoftware ~= 0 then
									newvalue = menu.software[type][key].possiblesoftware[menu.software[type][key].defaultsoftware]
								else
									newvalue = ""
								end
							else
								newvalue = ""
							end
						else
							newvalue = upgradeplan[type][key]
						end
					elseif (upgradetype.supertype == "ammo") then
						newvalue = 0
					end
					menu.upgradeplan[type][key] = newvalue
				end
			end
			if upgradetype.supertype == "crew" then
				if menu.usemacro then
					menu.crew.hired = 0
					menu.crew.hireddetails = {}
					menu.crew.unassigned = {}
					menu.crew.fired = {}

					for i, entry in ipairs(menu.crew.roles) do
						for roleid, amount in pairs(upgradeplan[type]) do
							if roleid == entry.id then
								menu.crew.roles[i].wanted = amount
								menu.crew.roles[i].tiers[1].wanted = amount

								menu.crew.hired = menu.crew.hired + amount
								table.insert(menu.crew.hireddetails, { newrole = roleid, amount = amount, price = menu.crew.price })
								break
							end
						end
					end
				end
			end
		end
		-- second pass due to ammo commpatibility being based on weapons and turrets
		for type, upgradelist in pairs(menu.upgradeplan) do
			local upgradetype = Helper.findUpgradeType(type)
			for key, upgrade in pairs(upgradelist) do
				if (upgradetype.supertype == "ammo") then
					if menu.isAmmoCompatible(type, key) then
						newvalue = upgradeplan[type][key] or 0
					else
						newvalue = 0
					end
					menu.upgradeplan[type][key] = newvalue
				end
			end
		end
		menu.upgradeplan.hascrewexperience = upgradeplan.hascrewexperience
	end
	if crew then
		menu.crew.hired = crew.hired
		for _, entry in ipairs(crew.fired) do
			table.insert(menu.crew.fired, entry)
		end
		menu.crew.unassigned = crew.unassigned
		for _, entry in ipairs(crew.hireddetails) do
			table.insert(menu.crew.hireddetails, entry)
		end
		for i, entry in ipairs(crew.roles) do
			menu.crew.roles[i].wanted = entry.wanted
			for j, tier in ipairs(entry.tiers) do
				menu.crew.roles[i].tiers[j].wanted = tier.wanted
			end
		end
	end

	if not noundo then
		menu.addUndoStep()
	end

	if menu.holomap and (menu.holomap ~= 0) then
		if (menu.usemacro and (menu.macro ~= "")) or (((menu.mode == "upgrade") or (menu.mode == "modify")) and (menu.object ~= 0)) then
			if (not newedit) and upgradeplan then
				Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.UpdateObjectConfigurationMap(menu.holomap, menu.object, 0, menu.macro, false, loadout) end)
			else
				menu.currentIdx = menu.currentIdx + 1
				Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.ShowObjectConfigurationMap2(menu.holomap, menu.object, 0, menu.macro, false, loadout, 0) end)
			end
			if menu.installedPaintMod then
				C.SetMapPaintMod(menu.holomap, menu.installedPaintMod.ware)
			end
			menu.selectMapMacroSlot()
			if menu.mapstate then
				C.SetMapState(menu.holomap, menu.mapstate)
				menu.mapstate = nil
			end
		else
			C.ClearMapBehaviour(menu.holomap)
		end
	end

	menu.displayMenu(firsttime)
end

function menu.checkCurrentBuildTasks()
	menu.tasks = {}
	local n = C.GetNumOrders(menu.object)
	local buf = ffi.new("Order[?]", n)
	n = C.GetOrders(buf, n, menu.object)
	for i = 0, n - 1 do
		if ffi.string(buf[i].orderdef) == "Equip" then
			local params = GetOrderParams(ConvertStringTo64Bit(tostring(menu.object)), tonumber(buf[i].queueidx))
			menu.tasks[tostring(menu.object)] = params[1].value
			break
		elseif ffi.string(buf[i].orderdef) == "Repair" then
			menu.tasks[tostring(menu.object)] = true
			break
		end
	end
end

function menu.checkCompatibility(macro, objectmakerraces)
	local makerrace = GetMacroData(macro, "makerraceid")
	local allowed = true
	for _, race in ipairs(makerrace) do
		if objectmakerraces then
			local raceallowed = false
			for _, objectrace in ipairs(objectmakerraces) do
				if objectrace == race then
					raceallowed = true
					break
				end
			end
			if raceallowed then
				-- always allow the equipment if the maker race matches the maker race of the object it is for
				allowed = true
				break
			end
		end
		if race == "xenon" then
			allowed = false
		end
		if race == "khaak" then
			allowed = false
		end
		if not allowed then
			break
		end
	end

	if menu.hasDefaultLoadout then
		return menu.defaultLoadoutMacros[macro]
	else
		return (next(makerrace) == nil) or allowed
	end
end

function menu.displayAmmoSlot(ftable, type, macro, total, capacity, first)
	if (menu.upgradeplan[type][macro] and (menu.upgradeplan[type][macro] > 0)) or menu.isAmmoCompatible(type, macro) then
		local planned = menu.upgradeplan[type][macro] or 0
		local name, infolibrary = GetMacroData(macro, "name", "infolibrary")
		AddKnownItem(infolibrary, macro)

		local difference = planned - menu.ammo[type][macro]
		local color = Color["text_normal"]
		if difference < 0 then
			color = Color["text_negative"]
		elseif difference > 0 then
			color = Color["text_positive"]
		end

		local errorcase = total > capacity

		local scale = {
			min            = 0,
			max            = math.max(capacity, planned),
			maxSelect      = errorcase and planned or math.min(capacity, planned + capacity - total),
			start          = planned,
			step           = 1,
			suffix         = "",
			exceedMaxValue = false,
			readOnly       = menu.isReadOnly,
		}

		local price
		local j = menu.findUpgradeMacro(type, macro)
		if j then
			local upgradeware = menu.upgradewares[type][j]
			if (not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
				price = tonumber(C.GetBuildWarePrice(menu.container, upgradeware.ware))
			end

			if (not errorcase) and (not upgradeware.isFromShipyard) then
				if menu.objectgroup then
					local maxamount = math.floor((upgradeware.objectamount - menu.ammo[type][macro]) / #menu.objectgroup.ships)
					scale.maxSelect = math.min(scale.maxSelect, maxamount)
					scale.start = math.min(scale.start, scale.maxSelect)
					menu.upgradeplan[type][macro] = math.min(planned, maxamount)
				else
					scale.maxSelect = math.min(scale.maxSelect, upgradeware.objectamount)
				end
			end
		end

		if not first then
			ftable:addEmptyRow(Helper.standardTextHeight / 2)
		end

		local row = ftable:addRow((type ~= "countermeasure") and { type = type, name = name, macro = macro } or true, { scaling = true, borderBelow = false })
		row[1]:setColSpan(price and 8 or 11):setBackgroundColSpan(11):createBoxText(name)
		if price then
			row[9]:setColSpan(3):createBoxText(ConvertMoneyString(price, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
		end

		local row = ftable:addRow(true, { scaling = true, bgColor = Color["row_background_blue"] })
		row[1]:setColSpan(11):createSliderCell({ width = slidercellWidth, height = Helper.standardTextHeight, valueColor = Color["slider_value"], min = scale.min, max = scale.max, maxSelect = scale.maxSelect, start = scale.start, step = scale.step, suffix = scale.suffix, exceedMaxValue = scale.exceedMaxValue, readOnly = scale.readOnly, helpOverlayID = "shipconfig_ammo_" .. macro, helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 1202), { color = color })
		row[1].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellSelectAmount(type, nil, macro, row.index, ...) end
		row[1].handlers.onRightClick = function (...) return menu.buttonInteract({ type = type, name = name, macro = macro }, ...) end

		return row
	end
end

function menu.displayCrewSlot(ftable, idx, data, buttonWidth, price, first)
	local lastrow
	if data.canhire then
		local color = Color["text_normal"]
		local capacity = menu.crew.capacity
		for _, entry in ipairs(menu.crew.roles) do
			if entry.id ~= data.id then
				capacity = capacity - entry.wanted
			end
		end
		capacity = math.max(0, capacity)

		local scale
		if (menu.mode == "purchase") or (menu.mode == "customgamestart") then
			scale = {
				min            = 0,
				max            = menu.crew.capacity,
				maxSelect      = capacity,
				start          = data.wanted,
				step           = 1,
				suffix         = "",
				exceedMaxValue = false,
				readOnly       = menu.isReadOnly,
			}
		else
			scale = {
				min            = 0,
				max            = menu.crew.capacity,
				maxSelect      = math.min(data.wanted + #menu.crew.unassigned + menu.crew.availableworkforce + menu.crew.availabledockcrew, capacity),
				start          = math.min(data.wanted, capacity),
				step           = 1,
				suffix         = "",
				exceedMaxValue = false,
				readOnly       = menu.isReadOnly,
			}
		end

		if not first then
			ftable:addEmptyRow(Helper.standardTextHeight / 2)
		end

		local row = ftable:addRow(true, { scaling = true, borderBelow = false })
		row[1]:setColSpan(((not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart")) and 8 or 11):setBackgroundColSpan(11):createBoxText(data.name)
		if (not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart") then
			local mouseovertext = ""
			if #menu.hiringdiscounts > 0 then
				if mouseovertext ~= "" then
					mouseovertext = mouseovertext .. "\n\n"
				end
				mouseovertext = mouseovertext .. ReadText(1001, 2819) .. ReadText(1001, 120)
				for _, entry in ipairs(menu.hiringdiscounts) do
					mouseovertext = mouseovertext .. "\n· " .. entry.name .. ReadText(1001, 120) .. " " .. entry.amount .. " %"
				end
			end
			row[9]:setColSpan(3):createBoxText(ConvertMoneyString(price, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right", mouseOverText = mouseovertext })
		end

		local row = ftable:addRow(true, { scaling = true, bgColor = Color["row_background_blue"] })
		row[1]:setColSpan(11):createSliderCell({ width = slidercellWidth, height = Helper.standardTextHeight, valueColor = Color["slider_value"], min = scale.min, max = scale.max, maxSelect = scale.maxSelect, start = scale.start, step = scale.step, suffix = scale.suffix, exceedMaxValue = scale.exceedMaxValue, readOnly = scale.readOnly, helpOverlayID = "shipconfig_crew_" .. data.id, helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 1202), { color = color })
		row[1].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellSelectCrewAmount(idx, 1, row.index, false, ...) end
		lastrow = row

		if menu.mode ~= "purchase" then
			for j, tier in ipairs(data.tiers) do
				if not tier.hidden then
					local scale = {
						min            = 0,
						max            = data.wanted,
						maxSelect      = tier.wanted,
						start          = tier.wanted,
						step           = 1,
						suffix         = "",
						exceedMaxValue = false,
						readOnly       = menu.isReadOnly,
					}

					local row = ftable:addRow(true, { scaling = true, bgColor = Color["row_background_blue"] })
					row[1]:setColSpan(11):createSliderCell({ width = slidercellWidth, height = Helper.standardTextHeight, valueColor = Color["slider_value"], min = scale.min, max = scale.max, maxSelect = scale.maxSelect, start = scale.start, step = scale.step, suffix = scale.suffix, exceedMaxValue = scale.exceedMaxValue, readOnly = scale.readOnly, helpOverlayID = "shipconfig_crew_" .. data.id .. j, helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText("  " .. tier.name, { color = color })
					row[1].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellSelectCrewAmount(idx, j, row.index, true, ...) end
					lastrow = row
				end
			end
		end
	else
		local row = ftable:addRow(false, { scaling = true, bgColor = Color["row_background_blue"] })
		row[1]:setColSpan(11):createText(data.name .. ": " .. data.total)
		lastrow = row
	end

	return lastrow
end

function menu.displaySoftwareSlot(ftable, type, slot, slotdata)
	local plansoftware = menu.upgradeplan[menu.upgradetypeMode][slot]
	local name = GetWareData(slotdata.possiblesoftware[1], "factoryname")

	local row = ftable:addRow(false, { bgColor = Color["row_title_background"] })
	local lastrow = row
	if slotdata.defaultsoftware ~= 0 then
		local color = Color["text_normal"]
		if plansoftware == "" then
			color = Color["text_error"]
		end

		row[1]:setColSpan(7):setBackgroundColSpan(11):createText(name, menu.subHeaderTextProperties)
		row[1].properties.color = color
		row[8]:setColSpan(4):createText(ReadText(1001, 8047), menu.subHeaderTextProperties)
		row[8].properties.color = color
		row[8].properties.halign = "right"
	else
		row[1]:setColSpan(11):createText(name, menu.subHeaderTextProperties)
	end

	for i, software in ipairs(slotdata.possiblesoftware) do
		if i >= slotdata.defaultsoftware then
			if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(menu.upgradetypeMode, software, menu.equipmentsearchtext) then
				local haslicence, icon, overridecolor, mouseovertext = menu.checkLicence(software, nil, true)

				local price
				if (not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
					price = C.GetContainerBuildPriceFactor(menu.container) * GetContainerWarePrice(ConvertStringTo64Bit(tostring(menu.container)), software, false)
				end

				local installcolor = Color["text_normal"]
				if software == slotdata.currentsoftware then
					if software ~= plansoftware then
						installcolor = Color["text_negative"]
					end
				elseif software == plansoftware then
					installcolor = Color["text_positive"]
				end

				local active = not menu.isReadOnly
				if software == plansoftware then
					if i == slotdata.defaultsoftware then
						active = false
					end
				end

				local name = GetWareData(software, "name")
				AddKnownItem("software", software)
				local row = ftable:addRow({ type = type, name = name, software = software }, { scaling = true })
				row[1]:setColSpan(1):createCheckBox(software == plansoftware, { scaling = false, active = active, width = menu.rowHeight, height = menu.rowHeight, helpOverlayID = "shipconfig_software_" .. software, helpOverlayText = " ", helpOverlayHighlightOnly = true })
				row[1].handlers.onClick = function () return menu.checkboxSelectSoftware(type, slot, software, row.index) end
				row[2]:setColSpan(price and 7 or 10):createText(name, { color = installcolor })
				if price then
					row[9]:setColSpan(3):createText(ConvertMoneyString(price, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
				end
				lastrow = row
			end
		end
	end

	return lastrow
end

function menu.checkCurrentSlot(slots, slot)
	local upgradetype = Helper.findUpgradeType(menu.upgradetypeMode)
	if upgradetype then
		if menu.upgradetypeMode == "enginegroup" then
			if (not menu.groups[slot]) or (menu.groups[slot]["engine"].total == 0) then
				for i, upgradegroup in ipairs(menu.groups) do
					if upgradegroup["engine"].total > 0 then
						slot = i
						break
					end
				end
			end
		elseif menu.upgradetypeMode == "turretgroup" then
			if (not menu.groups[slot]) or (menu.groups[slot]["engine"].total > 0) then
				for i, upgradegroup in ipairs(menu.groups) do
					if upgradegroup["engine"].total == 0 then
						slot = i
						break
					end
				end
			end
		elseif (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "software") then
			if not upgradetype.mergeslots then
				if (not slots[slot]) or slots[slot].isgroup then
					for i, slot2 in ipairs(slots) do
						if not slot2.isgroup then
							slot = i
							break
						end
					end
				end
			else
				slot = 1
			end
		end
	end

	return slot
end

function menu.buttonEquipmentFilter(offsety)
	if menu.contextMode and (menu.contextMode.mode == "equipmentfilter") then
		menu.closeContextMenu()
	else
		Helper.closeDropDownOptions(menu.titlebartable, 1, 1)
		Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
		Helper.closeDropDownOptions(menu.titlebartable, 1, 3)
		menu.displayContextFrame("equipmentfilter", Helper.scaleX(config.equipmentfilter_races_width), menu.slotData.offsetX + menu.slotData.width + Helper.borderSize, offsety)
	end
end

function menu.displaySlots(frame, firsttime)
	if menu.upgradetypeMode and ((menu.mode ~= "purchase") or menu.validLicence) then
		local upgradetype = Helper.findUpgradeType(menu.upgradetypeMode)

		local count, rowcount, slidercount = 1, 0, 0
		menu.groupedupgrades = {}

		local slots = {}
		if (menu.upgradetypeMode ~= "enginegroup") and (menu.upgradetypeMode ~= "turretgroup") and (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") and (menu.upgradetypeMode ~= "repair") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
				slots = menu.slots[menu.upgradetypeMode] or {}
			end
		end

		menu.currentSlot = menu.checkCurrentSlot(slots, menu.currentSlot)
		local currentSlotInfo = {}

		if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
			local upgradegroup = menu.groups[menu.currentSlot]
			if upgradegroup then
				for i, upgradetype2 in ipairs(Helper.upgradetypes) do
					local upgradegroupcount = 1
					if upgradetype2.supertype == "group" then
						menu.groupedupgrades[upgradetype2.grouptype] = {}
						for i, macro in ipairs(upgradegroup[upgradetype2.grouptype].possiblemacros) do
							local macroname, makerrace, makerracename = GetMacroData(macro, "name", "makerraceid", "makerracename")
							for race_i, race in ipairs(makerrace) do
								if (not menu.equipmentfilter_races[race]) then
									menu.equipmentfilter_races[race] = { id = race, name = makerracename[race_i] }
								end
								if (not menu.equipmentfilter_races[race].upgradeTypes) then
									menu.equipmentfilter_races[race].upgradeTypes = {}
								end
								if (not menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode]) then
									menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode] = true
								end
							end
							if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(menu.upgradetypeMode, macro, menu.equipmentsearchtext) then
								local group = math.ceil(upgradegroupcount / 3)
								menu.groupedupgrades[upgradetype2.grouptype][group] = menu.groupedupgrades[upgradetype2.grouptype][group] or {}
								table.insert(menu.groupedupgrades[upgradetype2.grouptype][group], { macro = macro, icon = (C.IsIconValid("upgrade_" .. macro) and ("upgrade_" .. macro) or "upgrade_notfound"), name = macroname })
								upgradegroupcount = upgradegroupcount + 1
							end
						end

						if (not menu.isReadOnly) and upgradetype2.allowempty then
							local group = math.ceil(upgradegroupcount / 3)
							menu.groupedupgrades[upgradetype2.grouptype][group] = menu.groupedupgrades[upgradetype2.grouptype][group] or {}
							table.insert(menu.groupedupgrades[upgradetype2.grouptype][group], { macro = "", icon = "upgrade_empty", name = ReadText(1001, 7906), helpOverlayID = "upgrade_empty", helpOverlayText = " ", helpOverlayHighlightOnly = true })
							upgradegroupcount = upgradegroupcount + 1
						end
					end
					if upgradegroupcount > 1 then
						slidercount = slidercount + 1
					end
					rowcount = rowcount + math.ceil((upgradegroupcount - 1) / 3)
				end
			end
		elseif (menu.upgradetypeMode == "repair") then
			if menu.objectgroup then
				for i, ship in ipairs(menu.objectgroup.ships) do
					if #menu.objectgroup.shipdata[i].damagedcomponents > 0 then
						local group = math.ceil(count / 3)
						menu.groupedupgrades[group] = menu.groupedupgrades[group] or {}
						table.insert(menu.groupedupgrades[group], { macro = ship.macro, icon = (C.IsIconValid("ship_" .. ship.macro) and ("ship_" .. ship.macro) or "ship_notfound"), name = ship.name, component = ship.ship })
						count = count + 1
					end
				end
			else
				local component = menu.object
				local group = math.ceil(count / 3)
				local macro = GetComponentData(ConvertStringTo64Bit(tostring(component)), "macro")
				local macroname, makerrace, makerracename = GetMacroData(macro, "name", "makerraceid", "makerracename")
				for race_i, race in ipairs(makerrace) do
					if (not menu.equipmentfilter_races[race]) then
						menu.equipmentfilter_races[race] = { id = race, name = makerracename[race_i] }
					end
					if (not menu.equipmentfilter_races[race].upgradeTypes) then
						menu.equipmentfilter_races[race].upgradeTypes = {}
					end
					if (not menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode]) then
						menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode] = true
					end
				end
				menu.groupedupgrades[group] = menu.groupedupgrades[group] or {}
				table.insert(menu.groupedupgrades[group], { macro = macro, icon = (C.IsIconValid("ship_" .. macro) and ("ship_" .. macro) or "ship_notfound"), name = macroname, component = component })
				count = count + 1
			end
			rowcount = rowcount + math.ceil(count / 3)
		elseif (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			if #slots > 0 then
				if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
					for i, macro in ipairs(slots[menu.currentSlot].possiblemacros) do
						local macroname, makerrace, makerracename = GetMacroData(macro, "name", "makerraceid", "makerracename")
						for race_i, race in ipairs(makerrace) do
							if (not menu.equipmentfilter_races[race]) then
								menu.equipmentfilter_races[race] = { id = race, name = makerracename[race_i] }
							end
							if (not menu.equipmentfilter_races[race].upgradeTypes) then
								menu.equipmentfilter_races[race].upgradeTypes = {}
							end
							if (not menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode]) then
								menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode] = true
							end
						end
						if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(menu.upgradetypeMode, macro, menu.equipmentsearchtext) then
							local group = math.ceil(count / 3)
							menu.groupedupgrades[group] = menu.groupedupgrades[group] or {}
							table.insert(menu.groupedupgrades[group], { macro = macro, icon = (C.IsIconValid("upgrade_" .. macro) and ("upgrade_" .. macro) or "upgrade_notfound"), name = macroname })
							count = count + 1
						end
					end

					if (not menu.isReadOnly) and (upgradetype.allowempty and (not C.IsSlotMandatory(menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot))) then
						local group = math.ceil(count / 3)
						menu.groupedupgrades[group] = menu.groupedupgrades[group] or {}
						table.insert(menu.groupedupgrades[group], { macro = "", icon = "upgrade_empty", name = ReadText(1001, 7906), helpOverlayID = "upgrade_empty", helpOverlayText = " ", helpOverlayHighlightOnly = true })
						count = count + 1
					end
				end
			end
			rowcount = rowcount + math.ceil(count / 3)
		end

		menu.groupedslots = {}
		local groupedslots = {}
		if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
			local groupcount = 1
			for i, upgradegroup in ipairs(menu.groups) do
				if (menu.upgradetypeMode == "enginegroup") == (upgradegroup["engine"].total > 0) then
					local groupname = upgradegroup.groupname
					local slotsize = upgradegroup[upgradetype.grouptype].slotsize
					local compatibilities = upgradegroup[upgradetype.grouptype].compatibilities

					if i == menu.currentSlot then
						currentSlotInfo.slotsize = slotsize
						currentSlotInfo.compatibilities = compatibilities
					end

					table.insert(groupedslots, { i, upgradegroup, groupname, sizecount = i, slotsize = slotsize, compatibilities = compatibilities })
					groupcount = groupcount + 1
				end
			end
		elseif menu.upgradetypeMode == "repair" then
			local slotcount = 1
			menu.repairslots = {}

			if menu.objectgroup then
				local count = 1
				for i, ship in ipairs(menu.objectgroup.ships) do
					if #menu.objectgroup.shipdata[i].damagedcomponents > 0 then
						local group = math.ceil(count / 3)

						menu.repairslots[group] = menu.repairslots[group] or {}
						table.insert(menu.repairslots[group], { i, ship.macro, i, ship.ship })
						count = count + 1
					end
				end
			else
				if #menu.damagedcomponents > 0 then
					local component = menu.object
					local group = math.ceil(slotcount / 3)
					local macro = GetComponentData(ConvertStringTo64Bit(tostring(component)), "macro")
					local slotnum = 1

					menu.repairslots[group] = menu.repairslots[group] or {}
					table.insert(menu.repairslots[group], { slotnum, macro, slotcount, component })
				end
			end
		elseif (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			if not upgradetype.mergeslots then
				for i, slot in ipairs(slots) do
					if not slot.isgroup then
						local slotname = slot.slotname
						local slotsize = slot.slotsize

						local compatibilities
						local n = C.GetNumSlotCompatibilities(menu.object, 0, menu.macro, false, upgradetype.type, i)
						if n > 0 then
							compatibilities = {}
							local buf = ffi.new("EquipmentCompatibilityInfo[?]", n)
							n = C.GetSlotCompatibilities(buf, n, menu.object, 0, menu.macro, false, upgradetype.type, i)
							for j = 0, n - 1 do
								compatibilities[ffi.string(buf[j].tag)] = ffi.string(buf[j].name)
							end
						end

						if i == menu.currentSlot then
							currentSlotInfo.slotsize = slotsize
							currentSlotInfo.compatibilities = compatibilities
						end

						table.insert(groupedslots, { i, slot, slotname, sizecount = i, slotsize = slotsize, compatibilities = compatibilities })
					end
				end
			else
				if upgradetype.supertype == "macro" then
					currentSlotInfo.slotsize = ffi.string(C.GetSlotSize(menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot))

					local n = C.GetNumSlotCompatibilities(menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot)
					if n > 0 then
						currentSlotInfo.compatibilities = {}
						local buf = ffi.new("EquipmentCompatibilityInfo[?]", n)
						n = C.GetSlotCompatibilities(buf, n, menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot)
						for j = 0, n - 1 do
							currentSlotInfo.compatibilities[ffi.string(buf[j].tag)] = ffi.string(buf[j].name)
						end
					end
				end
			end
		end
		table.sort(groupedslots, Helper.sortSlots)

		for i, entry in ipairs(groupedslots) do
			local group = math.ceil(i / 9)
			menu.groupedslots[group] = menu.groupedslots[group] or {}
			table.insert(menu.groupedslots[group], entry)
		end

		menu.rowHeight = math.max(23, Helper.scaleY(Helper.standardTextHeight))
		menu.extraFontSize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)
		local maxSlotWidth = math.floor((menu.slotData.width - 8 * Helper.borderSize) / 9)

		local hasScrollbar = false
		local headerHeight = menu.titleData.height + #menu.groupedslots * (maxSlotWidth + Helper.borderSize) + menu.rowHeight + 2 * Helper.borderSize
		local boxTextHeight = math.ceil(C.GetTextHeight(" \n ", Helper.standardFont, menu.extraFontSize, 0)) + 2 * Helper.borderSize
		--[[ Keep for simpler debugging
			print((Helper.viewHeight - 2 * menu.slotData.offsetY) .. " vs " .. (headerHeight + rowcount * (3 * (maxSlotWidth + Helper.borderSize) + boxTextHeight) + slidercount * (menu.subHeaderRowHeight + Helper.borderSize)))
			print(headerHeight)
			print(boxTextHeight)
			print(rowcount .. " * " .. 3 * (maxSlotWidth + Helper.borderSize))
			print(slidercount .. " * " .. menu.subHeaderRowHeight + Helper.borderSize) --]]
		if (Helper.viewHeight - 2 * menu.slotData.offsetY) < (headerHeight + rowcount * (3 * (maxSlotWidth + Helper.borderSize) + boxTextHeight) + slidercount * (menu.subHeaderRowHeight + Helper.borderSize)) then
			hasScrollbar = true
		end

		local slotWidth = maxSlotWidth - math.floor((hasScrollbar and Helper.scrollbarWidth or 0) / 9)
		local extraPixels = (menu.slotData.width - 8 * Helper.borderSize) % 9
		local slotWidths = { slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth }
		if extraPixels > 0 then
			for i = 1, extraPixels do
				slotWidths[i] = slotWidths[i] + 1
			end
		end
		-- prevent negative column width
		if slotWidths[1] - menu.rowHeight - Helper.borderSize < 1 then
			slotWidths[1] = menu.rowHeight + Helper.borderSize + 1
		end
		local columnWidths = {}
		local maxColumnWidth = 0
		for i = 1, 3 do
			columnWidths[i] = slotWidths[(i - 1) * 3 + 1] + slotWidths[(i - 1) * 3 + 2] + slotWidths[(i - 1) * 3 + 3] + 2 * Helper.borderSize
			maxColumnWidth = math.max(maxColumnWidth, columnWidths[i])
		end
		local slidercellWidth = menu.slotData.width - math.floor(hasScrollbar and Helper.scrollbarWidth or 0)

		local maxVisibleHeight
		local highlightmode = "column"
		if (menu.upgradetypeMode == "consumables") or (menu.upgradetypeMode == "crew") or (menu.upgradetypeMode == "software") or (menu.upgradetypeMode == "settings") then
			highlightmode = "on"
		end
		local ftable = frame:addTable(11, { tabOrder = 1, width = menu.slotData.width, maxVisibleHeight = Helper.viewHeight - 2 * menu.slotData.offsetY, x = menu.slotData.offsetX, y = menu.slotData.offsetY, scaling = false, reserveScrollBar = menu.upgradetypeMode == "consumables", highlightMode = highlightmode, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
		if menu.setdefaulttable then
			ftable.properties.defaultInteractiveObject = true
			menu.setdefaulttable = nil
		end
		ftable:setColWidth(1, menu.rowHeight)
		ftable:setColWidth(2, slotWidths[1] - menu.rowHeight - Helper.borderSize)
		-- exact col widths are unimportant in these menus, keeping them variable and equal helps with scrollbar support
		if (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			for i = 2, 8 do
				ftable:setColWidth(i + 1, slotWidths[i])
			end
		end
		ftable:setColWidth(11, menu.rowHeight)
		ftable:setDefaultColSpan(1, 4)
		ftable:setDefaultColSpan(5, 3)
		ftable:setDefaultColSpan(8, 4)

		local name = menu.getLeftBarEntry(menu.upgradetypeMode).name or ""
		local sizeicon
		if (menu.upgradetypeMode ~= "enginegroup") and (menu.upgradetypeMode ~= "turretgroup") and (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") and (menu.upgradetypeMode ~= "repair") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			if upgradetype.supertype == "macro" and ((menu.object ~= 0) or (menu.macro ~= "")) then
				if currentSlotInfo.slotsize and (currentSlotInfo.slotsize ~= "") then
					name = upgradetype.text[currentSlotInfo.slotsize]
					sizeicon = "be_upgrade_size_" .. currentSlotInfo.slotsize
				end
			elseif upgradetype.supertype == "virtualmacro" then
				if menu.class == "ship_s" then
					name = upgradetype.text["small"]
					sizeicon = "be_upgrade_size_small"
				elseif menu.class == "ship_m" then
					name = upgradetype.text["medium"]
					sizeicon = "be_upgrade_size_medium"
				elseif menu.class == "ship_l" then
					name = upgradetype.text["large"]
					sizeicon = "be_upgrade_size_large"
				elseif menu.class == "ship_xl" then
					name = upgradetype.text["extralarge"]
					sizeicon = "be_upgrade_size_extralarge"
				end
			end
		end

		local color = Color["text_normal"]
		if upgradetype then
			local allowempty = upgradetype.allowempty
			if upgradetype.supertype == "macro" then
				allowempty = allowempty and (not C.IsSlotMandatory(menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot))
			end
			if not allowempty then
				if menu.upgradeplan[upgradetype.type][menu.currentSlot].macro == "" then
					color = Color["text_error"]
				end
			end
		end
		local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(11):createText(name, menu.headerTextProperties)
		row[1].properties.color = color

		for _, group in ipairs(menu.groupedslots) do
			local row = ftable:addRow(true, {  })
			for i = 1, 9 do
				if group[i] then
					local col = (i > 1) and (i + 1) or 1
					local colspan = ((i == 1) or (i == 9)) and 2 or 1

					local color = Color["text_normal"]
					local haserror = false
					local bgcolor = Color["row_title_background"]
					if group[i][1] == menu.currentSlot then
						bgcolor = Color["row_background_selected"]
					end
					local count, total = 0, 0
					if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
						for _, upgradetype2 in ipairs(Helper.upgradetypes) do
							if upgradetype2.supertype == "group" then
								if menu.groups[group[i][1]][upgradetype2.grouptype].total > 0 then
									if upgradetype2.mergeslots then
										count = count + ((menu.upgradeplan[upgradetype2.type][group[i][1]].count > 0) and 1 or 0)
										total = total + 1
									else
										count = count + menu.upgradeplan[upgradetype2.type][group[i][1]].count
										total = total + menu.groups[group[i][1]][upgradetype2.grouptype].total
									end
									if upgradetype2.allowempty == false then
										if menu.upgradeplan[upgradetype2.type][group[i][1]].macro == "" then
											color = Color["text_error"]
											haserror = true
										end
									end
								end
							end
						end
					else
						total = 1
						if menu.upgradeplan[upgradetype.type][group[i][1]].macro == "" then
							if (upgradetype.allowempty == false) or C.IsSlotMandatory(menu.object, 0, menu.macro, false, upgradetype.type, group[i][1]) then
								color = Color["text_error"]
								haserror = true
							end
						else
							count = 1
						end
					end

					local mouseovertext = ""
					if upgradetype then
						mouseovertext = ReadText(1001, 66) .. " " .. group[i][3]
					else
						mouseovertext = ReadText(1001, 8023) .. " " .. group[i][3]
					end

					row[col]:setColSpan(colspan):createButton({ height = slotWidths[i], width = slotWidths[i], bgColor = bgcolor, mouseOverText = mouseovertext, helpOverlayID = "shipconfig_slot_" .. group[i][3], helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_slot_" .. group[i][3] }):setText(group[i][3], { halign = "center", fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), color = function () return menu.buttonSlotColor(group[i][1], haserror) end })
					if total > 0 then
						local width = math.max(1, math.floor(count * (slotWidths[i] - 2 * menu.scaleSize) / total))
						row[col]:setIcon("solid", { width = width + 2 * Helper.configButtonBorderSize, height = menu.scaleSize + 2 * Helper.configButtonBorderSize, x = menu.scaleSize - Helper.configButtonBorderSize, y = slotWidths[i] - 2 * menu.scaleSize - Helper.configButtonBorderSize })
					end
					if group[i].compatibilities then
						local compatibilitytext = ""
						local j = 0
						for _, entry in ipairs(Helper.equipmentCompatibilities) do
							if group[i].compatibilities[entry.tag] then
								compatibilitytext = compatibilitytext .. " " .. Helper.convertColorToText(entry.color) .. "\27[menu_weaponslot]"
								j = j + 1
							end
							if (j > 0) and (j % 4 == 0) then
								compatibilitytext = compatibilitytext .. "\n"
							end
						end
						-- slotwidth is based on Helper.viewWidth but limited, so we need to reflect that here
						local fontsize = math.floor(config.compatibilityFontSize * Helper.viewWidth / 1920)
						local reservedSidePanelWidth = math.floor(0.25 * Helper.viewWidth)
						local actualSidePanelWidth = math.min(reservedSidePanelWidth, Helper.scaleX(config.maxSidePanelWidth))
						fontsize = fontsize * actualSidePanelWidth / reservedSidePanelWidth

						local compatibilityTextHeight = math.ceil(C.GetTextHeight(compatibilitytext, Helper.standardFont, fontsize, 0)) + 2 * Helper.borderSize
						row[col]:setText2(compatibilitytext, { halign = "center", fontsize = fontsize, y = (slotWidths[i] - compatibilityTextHeight) / 2 })
					end
					row[col].handlers.onClick = function () return menu.buttonSelectSlot(group[i][1], row.index, col) end
				end
			end
		end

		if currentSlotInfo.compatibilities then
			local row = ftable:addRow(nil, { fixed = true, scaling = true })
			row[1]:setBackgroundColSpan(11):setColSpan(5):createText(ReadText(1001, 8548) .. ReadText(1001, 120))
			local compatibilitytext = ""
			for _, entry in ipairs(Helper.equipmentCompatibilities) do
				if currentSlotInfo.compatibilities[entry.tag] then
					compatibilitytext = compatibilitytext .. " " .. Helper.convertColorToText(entry.color) .. currentSlotInfo.compatibilities[entry.tag]
				end
			end
			row[6]:setColSpan(6):createText(compatibilitytext, { halign = "right" })
		end

		if next(menu.groupedupgrades) then
			if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
				for i, upgradetype2 in ipairs(Helper.upgradetypes) do
					if upgradetype2.supertype == "group" then
						if menu.groups[menu.currentSlot] and (menu.groups[menu.currentSlot][upgradetype2.grouptype].total > 0) then
							local plandata = menu.upgradeplan[upgradetype2.type][menu.currentSlot]
							local slotsize = menu.groups[menu.currentSlot][upgradetype2.grouptype].slotsize

							local name = upgradetype2.headertext.default
							if slotsize ~= "" then
								name = upgradetype2.headertext[slotsize]
							end

							local row = ftable:addRow(nil, { fixed = true, scaling = true })
							row[1]:setBackgroundColSpan(11):setColSpan(5):createText(name .. ReadText(1001, 120))
							if not upgradetype2.mergeslots then
								row[6]:setColSpan(6):createText(plandata.count .. " / " .. menu.groups[menu.currentSlot][upgradetype2.grouptype].total, { halign = "right" })
							else
								row[6]:setColSpan(6):createText(((plandata.macro == "") and 0 or menu.groups[menu.currentSlot][upgradetype2.grouptype].total) .. " / " .. menu.groups[menu.currentSlot][upgradetype2.grouptype].total, { halign = "right" })
							end
						end
					end
				end
			end
		end

		ftable:addEmptyRow(Helper.standardTextHeight / 2)

		-- local editboxheight = math.max(23, Helper.scaleY(Helper.standardTextHeight))
		local rowy = ftable:getFullHeight()
		local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
		local issearchandfilteractive = menu.upgradetypeMode ~= "crew" and menu.upgradetypeMode ~= "repair" and menu.upgradetypeMode ~= "settings"
		row[1]:setColSpan(10):createEditBox({ active = issearchandfilteractive, defaultText = ReadText(1001, 3250), scaling = true }):setText("", { x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
		row[1].handlers.onEditBoxDeactivated = menu.editboxSearchUpdateText
		menu.equipmentsearch_editboxrow = row.index
		row[11]:createButton({ active = issearchandfilteractive, height = menu.rowHeight }):setIcon("menu_filter")
		menu.equipmentfilter_races_y = menu.slotData.offsetY + rowy + Helper.borderSize
		row[11].handlers.onClick = function () return menu.buttonEquipmentFilter(menu.equipmentfilter_races_y) end

		if #menu.equipmentsearchtext > 0 and issearchandfilteractive then
			table.sort(menu.equipmentsearchtext, function (a, b)
				if a.race == b.race then
					return a.text < b.text
				end
				if (a.race == "generic") or (b.race == "generic") then
					return a.race == "generic"
				end
				return a.text < b.text
			end)
			local row = ftable:addRow((#menu.equipmentsearchtext > 0), { fixed = true })
			local searchindex = 0
			local cols = { 1, 5, 8 }
			for i = 1, math.min(3, #menu.equipmentsearchtext) do
				searchindex = searchindex + 1
				local truncatedString = TruncateText(menu.equipmentsearchtext[i].text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), row[cols[i]]:getWidth() - 3 * Helper.scaleX(10))
				if i < 3 or #menu.equipmentsearchtext <= 3 then
					row[cols[i]]:createButton({ scaling = true, height = Helper.standardTextHeight, mouseOverText = (truncatedString ~= menu.equipmentsearchtext[i].text) and menu.equipmentsearchtext[i].text or "" }):setText(truncatedString, { halign = "center" }):setText2("X", { halign = "right" })
				else
					row[cols[i]]:setColSpan(2):createButton({ scaling = true, height = Helper.standardTextHeight, mouseOverText = (truncatedString ~= menu.equipmentsearchtext[i].text) and menu.equipmentsearchtext[i].text or "" }):setText(truncatedString, { halign = "center" }):setText2("X", { halign = "right" })
				end
				if menu.equipmentsearchtext[i].race then
					row[cols[i]]:setIcon("menu_filter", { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
				end
				row[cols[i]].handlers.onClick = function () return menu.buttonRemoveSearchEntry(i) end
			end
			if #menu.equipmentsearchtext > 3 then
				row[10]:setColSpan(2):createText(string.format("%+d", #menu.equipmentsearchtext - 3), { scaling = true })
			end
		end

		local row = ftable:addEmptyRow(Helper.standardTextHeight / 2)
		row.properties.fixed = true

		if next(menu.groupedupgrades) then
			if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
				for i, upgradetype2 in ipairs(Helper.upgradetypes) do
					if upgradetype2.supertype == "group" then
						if menu.groups[menu.currentSlot] and (menu.groups[menu.currentSlot][upgradetype2.grouptype].total > 0) then
							local hasmod, modicon = menu.checkMod(upgradetype2.grouptype, menu.groups[menu.currentSlot][upgradetype2.grouptype].currentcomponent, true)

							local color = Color["text_normal"]
							if upgradetype2.allowempty == false then
								if menu.upgradeplan[upgradetype2.type][menu.currentSlot].macro == "" then
									color = Color["text_error"]
								end
							end
							local plandata = menu.upgradeplan[upgradetype2.type][menu.currentSlot]

							local row = ftable:addRow(true, { bgColor = upgradetype2.mergeslots and Color["row_background_blue"] or nil })
							local name = upgradetype2.text.default
							local slotsize = menu.groups[menu.currentSlot][upgradetype2.grouptype].slotsize
							if slotsize ~= "" then
								name = upgradetype2.text[slotsize]
								sizeicon = "be_upgrade_size_" .. slotsize
							end

							if plandata.macro ~= "" then
								name = GetMacroData(plandata.macro, "name")
							end

							if not upgradetype2.mergeslots then
								local scale = {
									min       = 0,
									minSelect = (plandata.macro == "") and 0 or 1,
									max       = menu.groups[menu.currentSlot][upgradetype2.grouptype].total,
								}
								scale.maxSelect = (plandata.macro == "") and 0 or scale.max

								-- handle already installed equipment
								if (plandata.macro == menu.groups[menu.currentSlot][upgradetype2.grouptype].currentmacro) then
									local haslicence = menu.checkLicence(plandata.macro)
									if not haslicence then
										scale.maxSelect = math.min(scale.maxSelect, menu.groups[menu.currentSlot][upgradetype2.grouptype].count)
										menu.upgradeplan[upgradetype2.type][menu.currentSlot].count = math.min(scale.maxSelect, menu.upgradeplan[upgradetype2.type][menu.currentSlot].count)
									end
									local j = menu.findUpgradeMacro(upgradetype2.grouptype, plandata.macro)
									if j then
										local upgradeware = menu.upgradewares[upgradetype2.grouptype][j]
										if not upgradeware.isFromShipyard then
											scale.maxSelect = math.min(scale.maxSelect, menu.groups[menu.currentSlot][upgradetype2.grouptype].count)
											menu.upgradeplan[upgradetype2.type][menu.currentSlot].count = math.min(scale.maxSelect, menu.upgradeplan[upgradetype2.type][menu.currentSlot].count)
										end
									end
								end
								scale.start = math.max(scale.minSelect, math.min(scale.maxSelect, plandata.count))

								local mouseovertext = ""
								if hasmod then
									mouseovertext = ColorText["text_error"] .. ReadText(1026, 8009) .. "\27X"
								end

								row[1]:setColSpan(11):createSliderCell({ width = slidercellWidth, height = menu.subHeaderRowHeight, valueColor = Color["slider_value"], min = scale.min, minSelect = scale.minSelect, max = scale.max, maxSelect = scale.maxSelect, start = scale.start, readOnly = hasmod or menu.isReadOnly, mouseOverText = mouseovertext }):setText(name, menu.subHeaderSliderCellTextProperties)
								row[1].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellSelectGroupAmount(upgradetype2.type, menu.currentSlot, row.index, false, ...) end
								row[1].properties.text.color = color
							else
								row[1]:setColSpan(11):createText(name, menu.subHeaderTextProperties)
								row[1].properties.color = color
							end

							if #menu.groupedupgrades[upgradetype2.grouptype] > 0 then
								for _, group in ipairs(menu.groupedupgrades[upgradetype2.grouptype]) do
									local row = ftable:addRow(true, { borderBelow = false })
									local row2 = ftable:addRow(false, {  })
									for i = 1, 3 do
										if group[i] then
											local column = i * 3 - 2
											if i > 1 then
												column = column + 1
											end

											local haslicence, icon, overridecolor, mouseovertext = menu.checkLicence(group[i].macro)
											local extraText = ""
											local untruncatedExtraText = ""

											-- handle already installed equipment
											if (group[i].macro == menu.groups[menu.currentSlot][upgradetype2.grouptype].currentmacro) and (not haslicence) then
												haslicence = true
												mouseovertext = mouseovertext .. "\n" .. ColorText["text_positive"] .. ReadText(1026, 8004)
											end

											local weaponicon, compatibility = GetMacroData(group[i].macro, "ammoicon", "compatibility")
											if weaponicon and (weaponicon ~= "") and C.IsIconValid(weaponicon) then
												weaponicon = "\27[" .. weaponicon .. "]"
											else
												weaponicon = ""
											end
											if compatibility then
												local color = Color["text_normal"]
												for _, entry in ipairs(Helper.equipmentCompatibilities) do
													if entry.tag == compatibility then
														color = entry.color
														break
													end
												end
												weaponicon = Helper.convertColorToText(color) .. "\27[menu_weaponmount]\27X" .. weaponicon
											end
											if hasmod then
												mouseovertext = ColorText["text_error"] .. ReadText(1026, 8009) .. "\27X\n" .. mouseovertext
											end

											local price
											local hasstock = group[i].macro == ""
											local j = menu.findUpgradeMacro(upgradetype2.grouptype, group[i].macro)
											if j then
												local upgradeware = menu.upgradewares[upgradetype2.grouptype][j]

												local isvolatile = GetWareData(upgradeware.ware, "volatile")
												if isvolatile then
													icon = "\27[bse_venture]"
												end

												if (not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") and (not isvolatile) then
													price = tonumber(C.GetBuildWarePrice(menu.container, upgradeware.ware))
													if upgradetype2.mergeslots then
														price = menu.groups[menu.currentSlot][upgradetype2.grouptype].total * price
													end
												end

												hasstock = upgradeware.isFromShipyard or ((menu.groups[menu.currentSlot][upgradetype2.grouptype].currentmacro == group[i].macro) and (menu.groups[menu.currentSlot][upgradetype2.grouptype].hasstock ~= false))
											end

											local amounttext = ""
											if upgradetype2.mergeslots and (menu.groups[menu.currentSlot][upgradetype2.grouptype].total > 1) then
												amounttext = menu.groups[menu.currentSlot][upgradetype2.grouptype].total .. ReadText(1001, 42) .. " "
											end
											if group[i].macro ~= "" then
												local name, shortname, infolibrary = GetMacroData(group[i].macro, "name", "shortname", "infolibrary")
												extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], amounttext .. shortname, amounttext .. name, group[i].macro, price)
												AddKnownItem(infolibrary, group[i].macro)
											else
												extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], amounttext .. group[i].name, nil, nil, price)
											end

											local installicon, installcolor = (group[i].macro ~= "") and (sizeicon or "") or ""
											if not haslicence then
												installcolor = Color["text_inactive"]
											elseif (group[i].macro ~= "") then
												if (group[i].macro == menu.groups[menu.currentSlot][upgradetype2.grouptype].currentmacro) and (group[i].macro ~= plandata.macro) then
													installicon = "be_upgrade_uninstalled"
													installcolor = Color["text_negative"]
												elseif (group[i].macro == plandata.macro) then
													installicon = "be_upgrade_installed"
													installcolor = Color["text_positive"]
													if hasmod then
														weaponicon = weaponicon .. " " .. modicon
													end
													if firsttime then
														menu.selectedRows.slots = row.index
														menu.selectedCols.slots = column
														firsttime = nil
													end
												end
											end

											-- start: mycu call-back
											if callbacks ["displaySlots_on_before_create_button_mouseovertext"] then
												for _, callback in ipairs (callbacks ["displaySlots_on_before_create_button_mouseovertext"]) do
													result = callback (group[i].macro, plandata.macro, mouseovertext)
													if result then
														mouseovertext = result.mouseovertext
													end
												end
											end
											-- end: mycu call-back

											mouseovertext = untruncatedExtraText .. ((mouseovertext ~= "") and ("\n\n" .. mouseovertext) or "")

											local active = ((group[i].macro == plandata.macro) or (not hasmod)) 
											local useable = hasstock and haslicence
											local overlayid
											if group[i].macro == "" then
												overlayid = "shipconfig_upgrade_empty"
											else
												overlayid = "shipconfig_upgrade_" .. group[i].macro
											end
											row[column]:createButton({
												active = active,
												width = columnWidths[i],
												height = maxColumnWidth,
												mouseOverText = mouseovertext,
												bgColor = useable and Color["button_background_default"] or Color["button_background_inactive"],
												highlightColor = useable and Color["button_highlight_bigbutton"] or Color["button_highlight_inactive"],
												helpOverlayID = overlayid,
												helpOverlayText = " ",
												helpOverlayHighlightOnly = true,
											}):setIcon(group[i].icon):setIcon2(installicon, { color = installcolor }):setText(icon, { y = maxColumnWidth / 2 - Helper.scaleY(Helper.standardTextHeight) / 2 - Helper.configButtonBorderSize, halign = "right", color = overridecolor, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) }):setText2(weaponicon, { x = 3, y = -maxColumnWidth / 2 + Helper.scaleY(Helper.standardTextHeight) / 2 + Helper.configButtonBorderSize, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) })
											if useable then
												row[column].handlers.onClick = function () return menu.buttonSelectGroupUpgrade(upgradetype2.type, menu.currentSlot, group[i].macro, row.index, column) end
											end
											if group[i].macro ~= "" then
												row[column].handlers.onRightClick = function (...) return menu.buttonInteract({ type = upgradetype2.type, name = group[i].name, macro = group[i].macro }, ...) end
											end

											row2[column]:createBoxText(extraText, { width = columnWidths[i], fontsize = menu.extraFontSize, color = overridecolor, boxColor = (active and useable) and Color["button_background_default"] or Color["button_background_inactive"], mouseOverText = untruncatedExtraText })
										end
									end
									if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
										maxVisibleHeight = ftable:getFullHeight()
									end
								end
							else
								local row = ftable:addRow(nil, { scaling = true })
								row[1]:setColSpan(11):createText("--- " .. upgradetype2.nonetext.default .. " ---")
							end
						end
					end
				end
			elseif menu.upgradetypeMode == "repair" then
				for k, group in ipairs(menu.groupedupgrades) do
					local row = ftable:addRow(true, { borderBelow = false })
					local row2 = ftable:addRow(false, {  })
					for i = 1, 3 do
						if group[i] then
							local repairslotdata = menu.repairslots[k][i]
							local componentstring = tostring(repairslotdata[4])

							local totalprice = 0
							local mouseovertext = ""
							if menu.objectgroup then
								for j, ship in ipairs(menu.objectgroup.ships) do
									if ship.ship == repairslotdata[4] then
										for k = #menu.objectgroup.shipdata[j].damagedcomponents, 1, -1 do
											local component = menu.objectgroup.shipdata[j].damagedcomponents[k]
											if k ~= #menu.objectgroup.shipdata[j].damagedcomponents then
												mouseovertext = mouseovertext .. "\n"
											end

											local price = tonumber(C.GetRepairPrice(component, menu.container))
											if price then
												totalprice = totalprice + price
											end
											local hull = GetComponentData(ConvertStringTo64Bit(tostring(component)), "hullpercent")
											mouseovertext = mouseovertext .. group[i].name .. " (" .. (100 - hull) .. "% " .. ReadText(1001, 1) .. ")"
										end
										break
									end
								end
							else
								for j = #menu.damagedcomponents, 1, -1 do
									local component = menu.damagedcomponents[j]
									local macro

									if component == menu.object then
										macro = GetComponentData(ConvertStringTo64Bit(tostring(component)), "macro")
									else
										for _, upgradetype in ipairs(Helper.upgradetypes) do
											if upgradetype.supertype == "macro" then
												if menu.slots[upgradetype.type] then
													for k = 1, #menu.slots[upgradetype.type] do
														if menu.slots[upgradetype.type][k].component == component then
															macro = GetComponentData(ConvertStringTo64Bit(tostring(component)), "macro")
															break
														end
													end
												end
											end
										end
									end
									if macro then
										if j ~= #menu.damagedcomponents then
											mouseovertext = mouseovertext .. "\n"
										end

										local price = tonumber(C.GetRepairPrice(component, menu.container))
										if price then
											totalprice = totalprice + price
										end
										local shortname = GetMacroData(macro, "shortname")
										local hull = GetComponentData(ConvertStringTo64Bit(tostring(component)), "hullpercent")
										mouseovertext = mouseovertext .. shortname .. " (" .. (100 - hull) .. "% " .. ReadText(1001, 1) .. ")"
									end
								end
							end

							if #menu.repairdiscounts > 0 then
								if mouseovertext ~= "" then
									mouseovertext = mouseovertext .. "\n\n"
								end
								mouseovertext = mouseovertext .. ReadText(1001, 2819) .. ReadText(1001, 120)
								for _, entry in ipairs(menu.repairdiscounts) do
									mouseovertext = mouseovertext .. "\n· " .. entry.name .. ReadText(1001, 120) .. " " .. entry.amount .. " %"
								end
							end

							local name, shortname
							if menu.objectgroup then
								shortname = group[i].name .. "\n" .. ffi.string(C.GetObjectIDCode(group[i].component))
							else
								name, shortname = GetMacroData(group[i].macro, "name", "shortname")
							end
							local extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], shortname, name, group[i].macro, (totalprice > 0) and totalprice * menu.repairdiscounts.totalfactor or nil, repairslotdata[4])

							local color = Color["button_background_default"]
							-- TODO: handle button colors for queued items here.

							local installicon, installcolor = sizeicon or ""
							menu.repairplan[componentstring] = menu.repairplan[componentstring] or {}
							if menu.repairplan[componentstring][componentstring] then
								installicon = "be_upgrade_installed"
								installcolor = Color["text_positive"]
							end

							mouseovertext = untruncatedExtraText .. ((mouseovertext ~= "") and ("\n\n" .. mouseovertext) or "")

							local column = i * 3 - 2
							if i > 1 then
								column = column + 1
							end
							--print("adding button for component: " .. tostring(componentstring) .. " row: " .. tostring(row.index) .. ", col: " .. tostring(column))
							row[column]:createButton({
								width = columnWidths[i],
								height = maxColumnWidth,
								bgColor = color,
								mouseOverText = mouseovertext,
								highlightColor = Color["button_highlight_bigbutton"],
								helpOverlayID = "shipconfig_repair_" .. group[i].macro,
								helpOverlayText = " ",
								helpOverlayHighlightOnly = true,
								uiTriggerID = "shipconfig_repair",
							}):setIcon(group[i].icon):setIcon2(installicon, { color = installcolor })
							row[column].handlers.onClick = function () return menu.buttonSelectRepair(row.index, column, componentstring) end
							row2[column]:createBoxText(extraText, { width = columnWidths[i], fontsize = menu.extraFontSize, mouseOverText = untruncatedExtraText })
						end
					end
					if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
						maxVisibleHeight = ftable:getFullHeight()
					end
				end
			else
				local plandata = menu.upgradeplan[menu.upgradetypeMode][menu.currentSlot]
				local hasmod, modicon = menu.checkMod(upgradetype.type, slots[menu.currentSlot].component)

				for _, group in ipairs(menu.groupedupgrades) do
					local row = ftable:addRow(true, { borderBelow = false })
					local row2 = ftable:addRow(false, {  })
					for i = 1, 3 do
						if group[i] then
							local column = i * 3 - 2
							if i > 1 then
								column = column + 1
							end

							local haslicence, icon, overridecolor, mouseovertext = menu.checkLicence(group[i].macro, nil, false)
							local extraText = ""
							local untruncatedExtraText = ""

							-- handle already installed equipment
							if (group[i].macro == slots[menu.currentSlot].currentmacro) and (not haslicence) then
								haslicence = true
								mouseovertext = mouseovertext .. "\n" .. ColorText["text_positive"] .. ReadText(1026, 8004)
							end

							local weaponicon, compatibility
							if upgradetype.supertype == "macro" then
								weaponicon, compatibility = GetMacroData(group[i].macro, "ammoicon", "compatibility")
							end
							if weaponicon and (weaponicon ~= "") and C.IsIconValid(weaponicon) then
								weaponicon = "\27[" .. weaponicon .. "]"
							else
								weaponicon = ""
							end
							if compatibility then
								local color = Color["text_normal"]
								for _, entry in ipairs(Helper.equipmentCompatibilities) do
									if entry.tag == compatibility then
										color = entry.color
										break
									end
								end
								weaponicon = Helper.convertColorToText(color) .. "\27[menu_weaponmount]\27X" .. weaponicon
							end
							if hasmod then
								mouseovertext = ColorText["text_error"] .. ReadText(1026, 8009) .. "\27X\n" .. mouseovertext
							end

							local price
							local hasstock = group[i].macro == ""
							local j = menu.findUpgradeMacro(upgradetype.type, group[i].macro)
							if j then
								local upgradeware = menu.upgradewares[upgradetype.type][j]
								if upgradeware.ware ~= nil then
									local isvolatile = GetWareData(upgradeware.ware, "volatile")
									if isvolatile then
										icon = "\27[bse_venture]"
									end

									if (not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") and (not isvolatile) then
										price = tonumber(C.GetBuildWarePrice(menu.container, upgradeware.ware))
										if upgradetype.mergeslots then
											price = #menu.upgradeplan[upgradetype.type] * price
										end
									end

									hasstock = upgradeware.isFromShipyard or ((slots[menu.currentSlot].currentmacro == group[i].macro) and (slots[menu.currentSlot].hasstock ~= false))
								else
									DebugError("Found upgradeware info for '" .. group[i].macro .. "', but no ware is set. Is it not defined?")
								end
							end

							local amounttext = ""
							if upgradetype.mergeslots and (#menu.upgradeplan[upgradetype.type] > 1) then
								amounttext = #menu.upgradeplan[upgradetype.type] .. ReadText(1001, 42) .. " "
							end
							if group[i].macro ~= "" then
								local name, shortname, infolibrary = GetMacroData(group[i].macro, "name", "shortname", "infolibrary")
								extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], amounttext .. shortname, amounttext .. name, group[i].macro, price, nil, upgradetype.type)
								AddKnownItem(infolibrary, group[i].macro)
							else
								extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], amounttext .. group[i].name, nil, nil, price)
							end

							local installicon, installcolor = (group[i].macro ~= "") and (sizeicon or "") or ""
							if not haslicence then
								installcolor = Color["text_inactive"]
							else
								if (group[i].macro ~= "") then
									if (group[i].macro == slots[menu.currentSlot].currentmacro) and (group[i].macro ~= plandata.macro) then
										installicon = "be_upgrade_uninstalled"
										installcolor = Color["text_negative"]
									elseif (group[i].macro == plandata.macro) then
										installicon = "be_upgrade_installed"
										installcolor = Color["text_positive"]
										if hasmod then
											weaponicon = weaponicon .. " " .. modicon
										end
										if firsttime then
											menu.selectedRows.slots = row.index
											menu.selectedCols.slots = column
											firsttime = nil
										end
									end
								end
							end

							-- start: mycu call-back
							if callbacks ["displaySlots_on_before_create_button_mouseovertext"] then
								for _, callback in ipairs (callbacks ["displaySlots_on_before_create_button_mouseovertext"]) do
									result = callback (group[i].macro, plandata.macro, mouseovertext)
									if result then
										mouseovertext = result.mouseovertext
									end
								end
							end
							-- end: mycu call-back

							mouseovertext = untruncatedExtraText .. ((mouseovertext ~= "") and ("\n\n" .. mouseovertext) or "")

							local active = ((group[i].macro == plandata.macro) or (not hasmod))
							local useable = hasstock and haslicence
							local overlayid
							if group[i].macro == "" then
								overlayid = "shipconfig_upgrade_empty"
							else
								overlayid = "shipconfig_upgrade_" .. group[i].macro
							end
							row[column]:createButton({
								active = active,
								width = columnWidths[i],
								height = maxColumnWidth,
								mouseOverText = mouseovertext,
								bgColor = useable and Color["button_background_default"] or Color["button_background_inactive"],
								highlightColor = useable and Color["button_highlight_bigbutton"] or Color["button_highlight_inactive"],
								helpOverlayID = overlayid,
								helpOverlayText = " ",
								helpOverlayHighlightOnly = true,
							}):setIcon(group[i].icon):setIcon2(installicon, { color = installcolor }):setText(icon, { y = maxColumnWidth / 2 - Helper.scaleY(Helper.standardTextHeight) / 2 - Helper.configButtonBorderSize, halign = "right", color = overridecolor, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) }):setText2(weaponicon, { x = 3, y = -maxColumnWidth / 2 + Helper.scaleY(Helper.standardTextHeight) / 2 + Helper.configButtonBorderSize, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) })
							if useable then
								row[column].handlers.onClick = function () return menu.buttonSelectUpgradeMacro(menu.upgradetypeMode, menu.currentSlot, group[i].macro, row.index, column, nil, (menu.mode == "customgamestart") or (menu.mode == "comparison")) end
							end
							if group[i].macro ~= "" then
								row[column].handlers.onRightClick = function (...) return menu.buttonInteract({ type = menu.upgradetypeMode, name = group[i].name, macro = group[i].macro }, ...) end
							end

							row2[column]:createBoxText(extraText, { width = columnWidths[i], fontsize = menu.extraFontSize, color = overridecolor, boxColor = (active and useable) and Color["button_background_default"] or Color["button_background_inactive"], mouseOverText = untruncatedExtraText })
						end
					end
					if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
						maxVisibleHeight = ftable:getFullHeight()
					end
				end
			end
		else
			if menu.upgradetypeMode == "consumables" then
				-- ammo
				local titlefirst = true
				for _, upgradetype in ipairs(Helper.upgradetypes) do
					if upgradetype.supertype == "ammo" then
						if next(menu.ammo[upgradetype.type]) then
							local total, capacity = menu.getAmmoUsage(upgradetype.type)
							local display = false
							for macro, _ in pairs(menu.ammo[upgradetype.type]) do
								if (total > 0) or menu.isAmmoCompatible(upgradetype.type, macro) then
									display = true
									break
								end
							end

							if ((total > 0) or (capacity > 0)) and display then
								if not titlefirst then
									ftable:addEmptyRow(Helper.standardTextHeight / 2)
								end
								titlefirst = false

								local name = upgradetype.type
								if upgradetype.type == "drone" then
									name = ReadText(1001, 8)
								elseif upgradetype.type == "missile" then
									name = ReadText(1001, 1304)
								elseif upgradetype.type == "deployable" then
									name = ReadText(1001, 1332)		-- "Deployables"
								elseif upgradetype.type == "countermeasure" then
									name = ReadText(1001, 8063)		-- "Countermeasures"
								end

								local row = ftable:addRow(false, { bgColor = Color["player_info_background"] })
								row[1]:setColSpan(7):setBackgroundColSpan(10):createText(name, menu.subHeaderTextProperties)
								row[8]:setColSpan(4):createText(total .. "\27X" .. " / " .. capacity, menu.subHeaderTextProperties)
								row[8].properties.halign = "right"
								row[8].properties.color = (total > capacity) and Color["text_error"] or Color["text_normal"]

								local first = true
								local sortedammo = Helper.orderedKeys(menu.ammo[upgradetype.type], menu.sortAmmo)
								for _, macro in ipairs(sortedammo) do
									local macroname, makerrace, makerracename = GetMacroData(macro, "name", "makerraceid", "makerracename")
									for race_i, race in ipairs(makerrace) do
										if (not menu.equipmentfilter_races[race]) then
											menu.equipmentfilter_races[race] = { id = race, name = makerracename[race_i] }
										end
										if (not menu.equipmentfilter_races[race].upgradeTypes) then
											menu.equipmentfilter_races[race].upgradeTypes = {}
										end
										if (not menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode]) then
											menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode] = true
										end
									end
									if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(menu.upgradetypeMode, macro, menu.equipmentsearchtext) then
										local row = menu.displayAmmoSlot(ftable, upgradetype.type, macro, total, capacity, first)
										first = false
										if (maxVisibleHeight == nil) and row and row.index >= config.maxSlotRows then
											maxVisibleHeight = ftable:getFullHeight()
										end
									end
								end
							end
						end
					end
				end
			elseif menu.upgradetypeMode == "crew" then
				-- crew
				if ((menu.mode == "purchase") or (not menu.usemacro)) and (not menu.isReadOnly) then
					-- total hires on the shoppinglist without current ship
					local totalhiring = 0
					for idx, entry in ipairs(menu.shoppinglist) do
						if idx ~= menu.editingshoppinglist then
							totalhiring = totalhiring + entry.amount * entry.crew.hired
						end
					end
					-- amount of current ship
					local shoppinglistamount = 1
					if menu.editingshoppinglist then
						shoppinglistamount = menu.shoppinglist[menu.editingshoppinglist].amount
					end
					-- still available workforce
					local availableworkforce = menu.crew.availableworkforce + menu.crew.availabledockcrew - menu.addedCrewByPlayerBuildTasks - totalhiring - shoppinglistamount * menu.crew.hired
					-- resources for next resource shift
					local resourceinfos = GetWorkForceRaceResources(ConvertStringTo64Bit(tostring(menu.container)))
					local races = {}
					local n = C.GetNumAllRaces()
					local buf = ffi.new("RaceInfo[?]", n)
					n = C.GetAllRaces(buf, n)
					for i = 0, n - 1 do
						local entry = {}
						entry.id = ffi.string(buf[i].id)
						entry.name = ffi.string(buf[i].name)

						table.insert(races, entry)
					end
					local workforceresources = {}
					for _, race in ipairs(races) do
						local workforceinfo = C.GetWorkForceInfo(menu.container, race.id)
						if workforceinfo.capacity > 0 then
							local resourcedata
							for _, resourceinfo in ipairs(resourceinfos) do
								if resourceinfo.race == race.id then
									resourcedata = resourceinfo
								end
							end
							for i, resource in ipairs(resourcedata.resources) do
								local amount = Helper.round(resource.cycle * workforceinfo.current / resourcedata.productamount)
								if workforceresources[resource.ware] then
									workforceresources[resource.ware] = workforceresources[resource.ware] + amount
								else
									workforceresources[resource.ware] = amount
								end
							end
						end
					end
					-- compare with station cargo
					local resourceerror
					local cargo = GetComponentData(ConvertStringTo64Bit(tostring(menu.container)), "cargo")
					for ware, amount in pairs(workforceresources) do
						if (cargo[ware] or 0) < amount then
							resourceerror = ReadText(1001, 8540)
							break
						end
					end

					local errormessage, errorcolor
					local color = Color["text_normal"]
					if availableworkforce < 0 then
						errormessage = C.IsComponentClass(menu.container, "station") and ReadText(1001, 8541) or ReadText(1001, 8545)
						errorcolor = Color["text_error"]
						color = Color["text_error"]
					elseif menu.crew.availableworkforce + menu.crew.availabledockcrew - totalhiring < shoppinglistamount * menu.crew.capacity then
						errormessage = C.IsComponentClass(menu.container, "station") and ReadText(1001, 8538) or ReadText(1001, 8544)
						errorcolor = Color["text_warning"]
						color = Color["text_warning"]
					end

					local row = ftable:addRow(nil, {  })
					row[1]:setColSpan(11):createText(C.IsComponentClass(menu.container, "station") and ReadText(1001, 8542) or ReadText(1001, 8543), menu.subHeaderTextProperties)

					local row = ftable:addRow(false, { scaling = true })
					row[1]:setColSpan(8):createText(string.format(ReadText(1001, 8024), ffi.string(C.GetComponentName(menu.container))), { mouseOverText = menu.isplayerowned and "" or (ReadText(1001, 2808) .. ReadText(1001, 120) .. " " .. ConvertMoneyString(menu.crew.price, false, true, 0, true, false) .. " " .. ReadText(1001, 101)) })
					row[9]:setColSpan(3):createText(math.max(0, availableworkforce), { halign = "right", color = color })

					if menu.mode == "purchase" then
						local row = ftable:addRow(nil, { scaling = true })
						row[1]:setColSpan(11):createText(ReadText(1001, 8539), { wordwrap = true })
					end

					if errormessage then
						local row = ftable:addRow(nil, { scaling = true })
						row[1]:setColSpan(11):createText(errormessage, { wordwrap = true, color = errorcolor })
					end
					if resourceerror then
						local row = ftable:addRow(nil, { scaling = true })
						row[1]:setColSpan(11):createText(resourceerror, { wordwrap = true, color = Color["text_warning"] })
					end

					local row = ftable:addRow(false, { scaling = true })
					row[1]:setColSpan(11):createText("")
				end

				local isbigship = (menu.class == "ship_m") or (menu.class == "ship_l") or (menu.class == "ship_xl")
				if menu.mode == "customgamestart" then
					if menu.modeparam.shippilotproperty or menu.modeparam.playerpropertyid then
						local value = 0
						if next(menu.customgamestartpilot) then
							local skills = {}
							for skill, value in pairs(menu.customgamestartpilot.skills or {}) do
								table.insert(skills, { id = skill, value = value })
							end
							local buf = ffi.new("CustomGameStartPersonEntry")
							buf.race = Helper.ffiNewString(menu.customgamestartpilot.race or "")
							buf.tags = Helper.ffiNewString(menu.customgamestartpilot.tags or "")
							buf.numskills = #skills
							buf.skills = Helper.ffiNewHelper("SkillInfo[?]", buf.numskills)
							for i, entry in ipairs(skills) do
								buf.skills[i - 1].id = Helper.ffiNewString(entry.id)
								buf.skills[i - 1].value = entry.value
							end
							value = tonumber(C.GetCustomGameStartShipPersonValue(menu.modeparam.gamestartid, buf))
						end

						local row = ftable:addRow(nil, {  })
						if menu.modeparam.creative then
							row[1]:setColSpan(11):createText(isbigship and ReadText(1001, 4848) or ReadText(1001, 4847), menu.subHeaderTextProperties)
						else
							row[1]:setColSpan(7):setBackgroundColSpan(11):createText(isbigship and ReadText(1001, 4848) or ReadText(1001, 4847), menu.subHeaderTextProperties)
							row[8]:setColSpan(4):createText(ConvertIntegerString(value, true, 0, true)  .. " " .. ColorText["customgamestart_budget_people"] .. "\27[gamestart_custom_people]", menu.subHeaderTextProperties)
							row[8].properties.halign = "right"
						end

						local raceoptions = {}
						local n = C.GetNumAllRaces()
						local buf = ffi.new("RaceInfo[?]", n)
						n = C.GetAllRaces(buf, n)
						for i = 0, n - 1 do
							local id = ffi.string(buf[i].id)
							local name = ffi.string(buf[i].name)
							if C.CanPlayerUseRace(id, "aipilot") then
								table.insert(raceoptions, { id = id, text = name, icon = "", displayremoveoption = false })
							end
						end
						table.sort(raceoptions, function (a, b) return a.text < b.text end)
						table.insert(raceoptions, 1, { id = "any", text = ReadText(1001, 9930), icon = "", displayremoveoption = false })

						local row = ftable:addRow(true, { scaling = true })
						row[1]:setColSpan(11):createDropDown(raceoptions, { startOption = (menu.customgamestartpilot.race and (menu.customgamestartpilot.race ~= "")) and menu.customgamestartpilot.race or "any", height = Helper.standardTextHeight, x = Helper.standardTextOffsetx })
						row[1].handlers.onDropDownConfirmed = function(_, raceid) if raceid == "any" then menu.customgamestartpilot.race = "" else menu.customgamestartpilot.race = raceid end; menu.refreshMenu() end

						ftable:addEmptyRow(Helper.standardTextHeight / 2)

						local numskills = C.GetNumSkills()
						local buf = ffi.new("SkillInfo[?]", numskills)
						numskills = C.GetSkills(buf, numskills)
						for i = 0, numskills - 1 do
							local id = ffi.string(buf[i].id)

							local row = ftable:addRow(true, { scaling = true })
							row[1]:setColSpan(11):createSliderCell({ height = Helper.standardTextHeight, valueColor = Color["slider_value"], min = 0, max = 15, start = menu.customgamestartpilot.skills and menu.customgamestartpilot.skills[id] or 0, step = 1 }):setText(ReadText(1013, buf[i].textid))
							row[1].handlers.onSliderCellChanged = function(_, newamount) if menu.customgamestartpilot.skills then menu.customgamestartpilot.skills[id] = newamount else menu.customgamestartpilot.skills = { [id] = newamount } end end
						end

						ftable:addEmptyRow()
					end
				end

				if (menu.mode ~= "customgamestart") or (menu.crew.capacity > 0) then
					local row = ftable:addRow(menu.mode ~= "customgamestart", {  })
					row[1]:setColSpan(7):setBackgroundColSpan(9):createText(ReadText(1001, 80), menu.subHeaderTextProperties)
					-- include the +1 for the captain
					if menu.mode ~= "customgamestart" then
						row[8]:setColSpan(3):createText((menu.crew.total + menu.crew.hired - #menu.crew.fired + (menu.captainSelected and 1 or 0)) .. " / " .. (menu.crew.capacity + 1), menu.subHeaderTextProperties)
						row[8].properties.halign = "right"
						row[11]:createButton({ active = (not menu.isReadOnly), mouseOverText = ReadText(1026, 8001), height = menu.rowHeight, y = math.max(0, row:getHeight() - menu.rowHeight) }):setIcon("menu_reset")
						row[11].handlers.onClick = menu.buttonResetCrew
					elseif not menu.modeparam.creative then
						local value = tonumber(C.GetCustomGameStartShipPeopleValue2(menu.modeparam.gamestartid, menu.macro, menu.customgamestartpeopledef, menu.customgamestartpeoplefillpercentage))

						row[8]:setColSpan(4):createText(ConvertIntegerString(value, true, 0, true)  .. " " .. ColorText["customgamestart_budget_people"] .. "\27[gamestart_custom_people]", menu.subHeaderTextProperties)
						row[8].properties.halign = "right"
					else
						row[8]:setColSpan(4):createText(" ", menu.subHeaderTextProperties)
					end
				end

				if menu.mode ~= "customgamestart" then
					local row = ftable:addRow(true, { scaling = true })
					row[1]:setColSpan(1):createCheckBox(menu.captainSelected, { scaling = false, active = (menu.mode == "purchase") and (not menu.captainSelected), width = menu.rowHeight, height = menu.rowHeight, helpOverlayID = "shipconfig_crew_captain", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_crew_captain" })
					row[1].handlers.onClick = function () return menu.checkboxSelectCaptain(row.index) end
					row[2]:setColSpan(7):createText(isbigship and ReadText(1001, 4848) or ReadText(1001, 4847), { color = ((menu.mode ~= "purchase") or menu.captainSelected) and Color["text_normal"] or Color["text_error"] })
					if menu.usemacro then
						row[9]:setColSpan(3):createText(ReadText(1001, 8047), { halign = "right", color = menu.captainSelected and Color["text_normal"] or Color["text_error"] })
					end
				end

				if menu.crew.capacity > 0 then
					if menu.mode == "customgamestart" then
						local peopleoptions = {}
						local n = C.GetNumPlayerPeopleDefinitions()
						local buf = ffi.new("PeopleDefinitionInfo[?]", n)
						n = C.GetPlayerPeopleDefinitions(buf, n)
						for i = 0, n - 1 do
							table.insert(peopleoptions, { id = ffi.string(buf[i].id), text = ffi.string(buf[i].name), icon = "", displayremoveoption = false, mouseovertext = ffi.string(buf[i].desc) })
						end
						table.sort(peopleoptions, function (a, b) return a.text < b.text end)
						table.insert(peopleoptions, 1, { id = "none", text = ReadText(1001, 9931), icon = "", displayremoveoption = false })

						local row = ftable:addRow(true, { scaling = true })
						row[1]:setColSpan(11):createDropDown(peopleoptions, { startOption = (menu.customgamestartpeopledef and (menu.customgamestartpeopledef ~= "")) and menu.customgamestartpeopledef or "none", height = Helper.standardTextHeight, x = Helper.standardTextOffsetx })
						row[1].handlers.onDropDownConfirmed = function(_, peopledefid) if peopledefid == "none" then menu.customgamestartpeopledef = "" else menu.customgamestartpeopledef = peopledefid end; menu.refreshMenu() end

						local row = ftable:addRow(true, { scaling = true })
						row[1]:setColSpan(11):createSliderCell({ height = Helper.standardTextHeight, valueColor = Color["slider_value"], min = 0, max = menu.crew.capacity, start = (menu.customgamestartpeopledef == "") and 0 or Helper.round(menu.crew.capacity * menu.customgamestartpeoplefillpercentage / 100), step = 1, readOnly = menu.customgamestartpeopledef == "" }):setText(ReadText(1001, 47))
						row[1].handlers.onSliderCellChanged = function(_, newamount) menu.customgamestartpeoplefillpercentage = newamount / menu.crew.capacity * 100 end
					else
						local row = ftable:addRow(false, { scaling = true })
						row[1]:setColSpan(11):createText("")

						if (not menu.usemacro) and (not menu.isReadOnly) then
							local color = Color["text_normal"]
							if #menu.crew.unassigned > 0 then
								color = Color["text_error"]
							end

							local row = ftable:addRow(true, { scaling = true })
							row[1]:setColSpan(7):createText(ReadText(1001, 8025))
							row[8]:setColSpan(3):createText(#menu.crew.unassigned, { halign = "right", color = color })
							row[11]:createButton({ active = (not menu.isReadOnly), mouseOverText = ReadText(1026, 8002) }):setIcon("menu_dismiss")
							row[11].handlers.onClick = menu.buttonFireCrew
						end

						local first = true
						for i, entry in ipairs(menu.crew.roles) do
							local row = menu.displayCrewSlot(ftable, i, entry, buttonWidth, menu.crew.price, first)
							first = false
							if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
								maxVisibleHeight = ftable:getFullHeight()
							end
						end
					end
				end
			elseif menu.upgradetypeMode == "software" then
				-- software
				local first = true
				if menu.software[menu.upgradetypeMode] then
					for slot, slotdata in ipairs(menu.software[menu.upgradetypeMode]) do
						if #slotdata.possiblesoftware > 0 then
							if first then
								first = false
							else
								local row = ftable:addRow(false, {  })
								row[1]:setColSpan(11):createText(" ")
							end
							local row = menu.displaySoftwareSlot(ftable, menu.upgradetypeMode, slot, slotdata)
							if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
								maxVisibleHeight = ftable:getFullHeight()
							end
						end
					end
				end
			elseif menu.upgradetypeMode == "settings" then
				-- settings
				-- blacklists
				local row = ftable:addRow(false, { bgColor = Color["player_info_background"] })
				row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 9143), menu.subHeaderTextProperties)

				local blacklists = Helper.getBlackLists()

				local purpose = GetMacroData(menu.macro, "primarypurpose")
				local group = ((purpose == "fight") or (purpose == "auxiliary")) and "military" or "civilian"
				local types = {
					{ type = "sectortravel",	name = ReadText(1001, 9165) },
					{ type = "sectoractivity",	name = ReadText(1001, 9166) },
					{ type = "objectactivity",	name = ReadText(1001, 9167) },
				}
				for i, entry in ipairs(types) do
					row = ftable:addRow(false, { scaling = true })
					row[1]:setColSpan(11):createText(entry.name .. ReadText(1001, 120))

					local blacklistid = menu.settings.blacklists[entry.type] or 0

					local rowdata = "orders_blacklist_" .. entry.type .. "_global"
					local row = ftable:addRow({ rowdata }, { scaling = true })
					row[1]:setColSpan(1):createCheckBox(blacklistid == 0, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
					row[1].handlers.onClick = function(_, checked) menu.settings.blacklists[entry.type] = checked and 0 or -1; menu.refreshMenu() end
					row[2]:setColSpan(10):createText(ReadText(1001, 8367))

					local locresponses = {
						{ id = -1, text = ReadText(1001, 7726), icon = "", displayremoveoption = false },
					}

					local defaultblacklistid = -1
					for _, blacklist in ipairs(blacklists) do
						if blacklist.type == entry.type then
							if blacklist.defaults[group] then
								defaultblacklistid = blacklist.id
							end
							table.insert(locresponses, { id = blacklist.id, text = blacklist.name, icon = "", displayremoveoption = false })
						end
					end
					local row = ftable:addRow("orders_resupply", { scaling = true })
					row[1]:setColSpan(10):createDropDown(locresponses, { startOption = (blacklistid ~= 0) and blacklistid or defaultblacklistid, active = blacklistid ~= 0 })
					row[1].handlers.onDropDownConfirmed = function (_, id) menu.settings.blacklists[entry.type] = tonumber(id) end
					row[11]:createButton({ mouseOverText = ReadText(1026, 8413) }):setIcon("menu_edit")
					row[11].handlers.onClick = menu.buttonEditBlacklist

					ftable:addEmptyRow()
				end

				-- fight rules
				local row = ftable:addRow(false, { bgColor = Color["player_info_background"] })
				row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 7753), menu.subHeaderTextProperties)

				local fightrules = Helper.getFightRules()

				local fightruleid = menu.settings.fightrules["attack"] or 0

				local rowdata = "orders_fightrule_attack_global"
				local row = ftable:addRow({ rowdata }, { scaling = true })
				row[1]:setColSpan(1):createCheckBox(fightruleid == 0, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
				row[1].handlers.onClick = function(_, checked) menu.settings.fightrules["attack"] = checked and 0 or -1; menu.refreshMenu() end
				row[2]:setColSpan(10):createText(ReadText(1001, 8367))

				local locresponses = {
					{ id = -1, text = ReadText(1001, 7726), icon = "", displayremoveoption = false },
				}

				local defaultfightruleid = -1
				for _, fightrule in ipairs(fightrules) do
					if fightrule.defaults["attack"] then
						defaultfightruleid = fightrule.id
					end
					table.insert(locresponses, { id = fightrule.id, text = fightrule.name, icon = "", displayremoveoption = false })
				end
				local row = ftable:addRow("orders_resupply", { scaling = true })
				row[1]:setColSpan(10):createDropDown(locresponses, { startOption = (fightruleid ~= 0) and fightruleid or defaultfightruleid, active = fightruleid ~= 0 })
				row[1].handlers.onDropDownConfirmed = function (_, id) menu.settings.fightrules["attack"] = tonumber(id) end
				row[11]:createButton({ mouseOverText = ReadText(1026, 8414) }):setIcon("menu_edit")
				row[11].handlers.onClick = menu.buttonEditFightRule

				-- missile launchers
				local hasmissilelauncher = false
				for slot, data in pairs(menu.upgradeplan.weapon) do
					if data.macro ~= "" then
						if IsMacroClass(data.macro, "missilelauncher") then
							hasmissilelauncher = true
							break
						end
					end
				end
				if hasmissilelauncher then
					ftable:addEmptyRow()

					local row = ftable:addRow(false, { bgColor = Color["player_info_background"] })
					row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 9030), menu.subHeaderTextProperties)
					for slot, data in pairs(menu.upgradeplan.weapon) do
						if data.macro ~= "" then
							if IsMacroClass(data.macro, "missilelauncher") then
								menu.displayWeaponAmmoSelection(ftable, "weapon", slot, data)
							end
						end
					end
				end
				-- turrets
				local hasindividualturrets = false
				for slot, data in pairs(menu.upgradeplan.turret) do
					if data.macro ~= "" then
						hasindividualturrets = true
						break
					end
				end
				if hasindividualturrets then
					ftable:addEmptyRow()

					local row = ftable:addRow(false, { bgColor = Color["player_info_background"] })
					row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 1319), menu.subHeaderTextProperties)
					for slot, data in pairs(menu.upgradeplan.turret) do
						if data.macro ~= "" then
							menu.displayWeaponModeSelection(ftable, "turret", slot, data)
						end
					end
				end
				-- turret groups
				if next(menu.upgradeplan.turretgroup) then
					ftable:addEmptyRow()

					local row = ftable:addRow(false, { bgColor = Color["player_info_background"] })
					row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 7901), menu.subHeaderTextProperties)
					for slot, groupdata in pairs(menu.upgradeplan.turretgroup) do
						if groupdata.macro ~= "" then
							menu.displayWeaponModeSelection(ftable, "turretgroup", slot, groupdata)
						end
					end
				end
			end
		end

		if maxVisibleHeight ~= nil then
			ftable.properties.maxVisibleHeight = maxVisibleHeight
		end

		ftable:setTopRow(menu.topRows.slots)
		ftable:setSelectedRow(menu.selectedRows.slots)
		ftable:setSelectedCol(menu.selectedCols.slots or 0)
	end

	menu.topRows.slots = nil
	menu.selectedRows.slots = nil
	menu.selectedCols.slots = nil
end

function menu.getExtraText(columnwidth, basetext, fullbasetext, macro, price, component, upgradetype)
	local extraText = ""
	local untruncatedExtraText = ""
	if price then
		extraText = ConvertMoneyString(price, false, true, 3, true) .. " " .. ReadText(1001, 101)
	end
	if macro then
		local makerrace, mk = GetMacroData(macro, "makerrace", "mk")
		local extraText2 = ""
		if component then
			local class = ffi.string(C.GetComponentClass(component))
			if (class == "weapon") or (class == "missilelauncher") then
				if mk > 0 then
					extraText2 = ReadText(20111, 100 * mk + 1)
				end
			end
		end
		if upgradetype == "weapon" then
			if mk > 0 then
				extraText2 = ReadText(20111, 100 * mk + 1)
			end
		end
		for _, racestring in ipairs(makerrace) do
			extraText2 = racestring .. ((extraText2 ~= "") and " - " or "") .. extraText2
		end

		local separator = ((extraText2 ~= "") and (extraText ~= "")) and "\n" or ""
		local untruncatedExtraText2
		if fullbasetext == nil then
			untruncatedExtraText2 = extraText2 .. separator .. extraText
		else
			untruncatedExtraText2 = extraText
		end
		untruncatedExtraText = (fullbasetext or basetext) .. ((untruncatedExtraText2 ~= "") and ("\n" .. untruncatedExtraText2) or "")
		extraText = extraText2 .. separator .. extraText
		local truncatedtext = TruncateText(basetext, Helper.standardFont, menu.extraFontSize, columnwidth - 2 * Helper.borderSize)
		extraText = truncatedtext .. "\n" .. extraText
	else
		untruncatedExtraText = (fullbasetext or basetext) .. ((extraText ~= "") and ("\n" .. extraText) or "")
		if (not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
			extraText = "\n" .. extraText
		end
		local truncatedtext = TruncateText(basetext, Helper.standardFont, menu.extraFontSize, columnwidth - 2 * Helper.borderSize)
		extraText = truncatedtext .. "\n" .. extraText
	end
	return extraText, untruncatedExtraText
end

function menu.displayWeaponAmmoSelection(ftable, upgradetype, slot, data)
	local dropdowndata = {}
	for macro, _ in pairs(menu.ammo["missile"]) do
		if C.IsAmmoMacroCompatible(data.macro, macro) then
			table.insert(dropdowndata, {id = macro, text = GetMacroData(macro, "name"), icon = "", displayremoveoption = false})
		end
	end

	local row = ftable:addRow("ammo_config", { scaling = true })
	local name = GetMacroData(data.macro, "name")
	if upgradetype == "turretgroup" then
		name = menu.groups[slot].groupname .. " - " .. name
	else
		name = menu.slots[upgradetype][slot].slotname .. " - " .. name
	end
	row[1]:setColSpan(6):createText(name)
	row[7]:setColSpan(5):createDropDown(dropdowndata, { startOption = data.ammomacro })
	row[7].handlers.onDropDownConfirmed = function(_, newammomacro) menu.upgradeplan[upgradetype][slot].ammomacro = newammomacro end
end

function menu.displayWeaponModeSelection(ftable, upgradetype, slot, data)
	local row = ftable:addRow("ammo_config", { scaling = true })
	local name = GetMacroData(data.macro, "name")
	if upgradetype == "turretgroup" then
		name = menu.groups[slot].groupname .. " - " .. name
	else
		name = menu.slots[upgradetype][slot].slotname .. " - " .. name
	end
	row[1]:setColSpan(6):createText(name)
	row[7]:setColSpan(5):createDropDown(Helper.getMacroTurretModes(data.macro), { startOption = data.weaponmode })
	row[7].handlers.onDropDownConfirmed = function(_, newturretmode) menu.upgradeplan[upgradetype][slot].weaponmode = newturretmode end
end

function menu.displayModifySlots(frame)
	if menu.upgradetypeMode then
		local slotWidth = math.floor((menu.slotData.width - 8 * Helper.borderSize) / 9)
		local modIconWidth = C.GetTextWidth("\27[" .. Helper.modQualities[3].icon2 .. "]", Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)) + 2 * Helper.scaleX(Helper.standardTextOffsetx)

		local ftable = frame:addTable(8, { tabOrder = 1, width = menu.slotData.width, height = 0, x = menu.slotData.offsetX, y = menu.slotData.offsetY, scaling = false, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
		if menu.setdefaulttable then
			ftable.properties.defaultInteractiveObject = true
			menu.setdefaulttable = nil
		end
		ftable:setColWidth(1, Helper.scaleX(Helper.standardTextHeight))
		ftable:setColWidth(2, slotWidth - Helper.scaleX(Helper.standardTextHeight) - Helper.borderSize)
		ftable:setColWidth(3, slotWidth)
		ftable:setColWidth(4, slotWidth)
		ftable:setColWidth(6, menu.slotData.width * 2 / 9)
		ftable:setColWidth(7, menu.slotData.width * 1 / 9)
		ftable:setColWidth(8, modIconWidth)
		ftable:setDefaultBackgroundColSpan(1, 8)

		local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(8):createText(ReadText(1001, 8031), menu.headerTextProperties)

		local row = ftable:addRow(true, { fixed = true })
		for i, entry in ipairs(Helper.modQualities) do
			local col = i
			if i > 1 then
				col = col + 1
			end

			local bgColor = Color["button_background_default"]
			if entry.category == menu.modCategory then
				bgColor = Color["row_background_selected"]
			end

			row[col]:setColSpan((i == 1) and 2 or 1):createButton({ height = slotWidth, mouseOverText = entry.name, bgColor = bgColor }):setIcon(entry.icon)
			row[col].handlers.onClick = function () return menu.buttonModCategory(entry.category, row.index, col) end
		end
		row[6]:setColSpan(3)

		if menu.object ~= 0 then
			local entry = menu.getLeftBarEntry(menu.upgradetypeMode)
			if next(entry) then
				if entry.upgrademode == "ship" then
					menu.displayModSlot(ftable, entry.upgrademode, entry.modclass, 1)
				elseif entry.upgrademode == "shield" then
					table.sort(menu.shieldgroups, Helper.sortSlots)
					for i, shieldgroupdata in ipairs(menu.shieldgroups) do
						menu.displayModSlot(ftable, entry.upgrademode, entry.modclass, i, shieldgroupdata)
					end
				elseif (entry.upgrademode == "turret") and next(menu.groups) then
					table.sort(menu.shieldgroups, Helper.sortSlots)
					for i, shieldgroupdata in ipairs(menu.shieldgroups) do
						menu.displayModSlot(ftable, entry.upgrademode, entry.modclass, i, shieldgroupdata, true)
					end
				else
					local upgradetype = Helper.findUpgradeType(entry.upgrademode)

					if upgradetype.mergeslots then
						local slotdata = menu.slots[entry.upgrademode][1]
						if slotdata.currentmacro ~= "" then
							menu.displayModSlot(ftable, entry.upgrademode, entry.modclass, 1, slotdata)
						end
					else
						for slot, slotdata in ipairs(menu.slots[entry.upgrademode]) do
							if slotdata.currentmacro ~= "" then
								menu.displayModSlot(ftable, entry.upgrademode, entry.modclass, slot, slotdata)
							end
						end
					end
				end
			end
		end

		ftable:setTopRow(menu.topRows.slots)
		ftable:setSelectedRow(menu.selectedRows.slots)
		ftable:setSelectedCol(menu.selectedCols.slots or 0)
	end
	menu.topRows.slots = nil
	menu.selectedRows.slots = nil
	menu.selectedCols.slots = nil
end

function menu.displayModifyPaintSlots(frame)
	if menu.upgradetypeMode then
		local entry = menu.getLeftBarEntry(menu.upgradetypeMode)
		-- available mods
		local categoryQuality = menu.getModQuality(menu.modCategory)
		if not categoryQuality then
			DebugError(string.format("Could not resolve mod category '%s' to quality level. Check Helper.modQualities [Florian]", menu.modCategory))
			return
		end

		if not menu.selectedPaintMod then
			if menu.modeparam[1] and (#menu.selectableships > 1) then
				menu.selectedPaintMod = menu.defaultpaintmod
			elseif menu.installedPaintMod then
				menu.selectedPaintMod = menu.installedPaintMod
			else
				menu.selectedPaintMod = menu.defaultpaintmod
			end
		end

		local count = 0
		menu.paintmodgroups = {}

		if categoryQuality == 1 then
			if menu.defaultpaintmod then
				count = count + 1
				local group = math.ceil(count / 3)
				if menu.paintmodgroups[group] then
					table.insert(menu.paintmodgroups[group], menu.defaultpaintmod)
				else
					menu.paintmodgroups[group] = { menu.defaultpaintmod }
				end
			end
		end

		if menu.modwares[entry.modclass] then
			for _, entry in ipairs(menu.modwares[entry.modclass]) do
				if (entry.quality == categoryQuality) and ((menu.defaultpaintmod == nil) or (entry.ware ~= menu.defaultpaintmod.ware)) then
					count = count + 1
					local group = math.ceil(count / 3)
					if menu.paintmodgroups[group] then
						table.insert(menu.paintmodgroups[group], entry)
					else
						menu.paintmodgroups[group] = { entry }
					end
				end
			end
		end

		local buttontable = frame:addTable(3, { tabOrder = 9, width = menu.slotData.width, height = 0, x = menu.slotData.offsetX, y = 0, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
		buttontable:setColWidth(1, Helper.standardTextHeight)
		buttontable:setColWidthPercent(3, 40)

		local row = buttontable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(ReadText(1001, 8550), menu.headerTextProperties)

		local row = buttontable:addRow(false, { fixed = true })
		row[1]:setColSpan(3):createText(menu.installedPaintMod and (menu.installedPaintMod.isdefault and ReadText(1001, 8516) or menu.installedPaintMod.name) or "", { color =  menu.installedPaintMod and Helper.modQualities[menu.installedPaintMod.quality].color or Color["text_normal"] })

		local row = buttontable:addRow(true, { fixed = true })
		local islocked = false
		if menu.object ~= 0 then
			islocked = GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "paintmodlocked")
		end
		row[1]:createCheckBox(islocked, { active = true })
		row[1].handlers.onClick = function () return C.SetPaintModLocked(menu.object, not islocked) end
		row[2]:setColSpan(2):createText(ReadText(1001, 8551))

		local row = buttontable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(ReadText(1001, 8514), menu.headerTextProperties)

		local active = menu.selectedPaintMod ~= nil
		local missingcount
		if menu.selectedPaintMod then
			if menu.modeparam[1] then
				missingcount = 0
				for _, ship in pairs(menu.modeparam[2]) do
					local paintmod = ffi.new("UIPaintMod")
					if C.GetInstalledPaintMod(ship, paintmod) then
						if menu.selectedPaintMod.ware ~= ffi.string(paintmod.Ware) then
							missingcount = missingcount + 1
						end
					else
						missingcount = missingcount + 1
					end
				end
				if (missingcount == 0) or ((not menu.selectedPaintMod.isdefault) and (missingcount > menu.selectedPaintMod.amount)) then
					active = false
				end
			else
				active = menu.selectedPaintMod.ware ~= (menu.installedPaintMod and menu.installedPaintMod.ware or "")
			end
		end

		local row = buttontable:addRow(false, { fixed = true })
		row[1]:setColSpan(3):createText(menu.selectedPaintMod and (menu.selectedPaintMod.isdefault and ReadText(1001, 8516) or (((missingcount and (missingcount > 0)) and (missingcount .. ReadText(1001, 42) .. " ") or "") .. menu.selectedPaintMod.name)) or "", { color =  menu.selectedPaintMod and Helper.modQualities[menu.selectedPaintMod.quality].color or Color["text_normal"] })

		local row = buttontable:addRow(true, { fixed = true })
		row[3]:createButton({ active = active }):setText(ReadText(1001, 4803), { halign = "center" })
		row[3].handlers.onClick = menu.buttonInstallPaintMod

		buttontable.properties.y = Helper.viewHeight - buttontable:getFullHeight() - Helper.frameBorder

		menu.extraFontSize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)
		local maxSlotWidth = math.floor((menu.slotData.width - 8 * Helper.borderSize) / 9)
		local boxTextHeight = math.ceil(C.GetTextHeight(" ", Helper.standardFont, menu.extraFontSize, 0)) + 2 * Helper.borderSize
		local headerHeight = menu.titleData.height + (maxSlotWidth + Helper.borderSize) + 2 * Helper.borderSize
		--[[ Keep for simpler debugging
			print((buttontable.properties.y - menu.slotData.offsetY) .. " vs " .. (headerHeight + #menu.paintmodgroups * (3 * (maxSlotWidth + Helper.borderSize) + boxTextHeight)))
			print(headerHeight)
			print(boxTextHeight)
			print(#menu.paintmodgroups .. " * " .. 3 * (maxSlotWidth + Helper.borderSize) + boxTextHeight) --]]
		if (buttontable.properties.y - menu.slotData.offsetY) < (headerHeight + #menu.paintmodgroups * (3 * (maxSlotWidth + Helper.borderSize) + boxTextHeight)) then
			hasScrollbar = true
		end

		local slotWidth = maxSlotWidth - math.floor((hasScrollbar and Helper.scrollbarWidth or 0) / 9)
		local extraPixels = (menu.slotData.width - 8 * Helper.borderSize) % 9
		local slotWidths = { slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth }
		if extraPixels > 0 then
			for i = 1, extraPixels do
				slotWidths[i] = slotWidths[i] + 1
			end
		end
		columnWidths = {}
		maxColumnWidth = 0
		for i = 1, 3 do
			columnWidths[i] = slotWidths[(i - 1) * 3 + 1] + slotWidths[(i - 1) * 3 + 2] + slotWidths[(i - 1) * 3 + 3] + 2 * Helper.borderSize
			maxColumnWidth = math.max(maxColumnWidth, columnWidths[i])
		end

		local ftable = frame:addTable(9, { tabOrder = 1, width = menu.slotData.width, maxVisibleHeight = buttontable.properties.y - menu.slotData.offsetY, x = menu.slotData.offsetX, y = menu.slotData.offsetY, scaling = false, reserveScrollBar = false, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"], highlightMode = "column" })
		if menu.setdefaulttable then
			ftable.properties.defaultInteractiveObject = true
			menu.setdefaulttable = nil
		end
		for i = 1, 8 do
			ftable:setColWidth(i, slotWidths[i])
		end

		local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(9):createText(ReadText(1001, 8031), menu.headerTextProperties)

		local row = ftable:addRow(true, { fixed = true })
		for i, entry in ipairs(Helper.modQualities) do
			local col = i

			local bgColor = Color["button_background_default"]
			if entry.category == menu.modCategory then
				bgColor = Color["row_background_selected"]
			end

			row[col]:createButton({ height = slotWidth, mouseOverText = entry.name, bgColor = bgColor }):setIcon(entry.icon)
			row[col].handlers.onClick = function () return menu.buttonModCategory(entry.category, row.index, col) end
		end

		if menu.object ~= 0 then
			if next(menu.paintmodgroups) then
				for _, group in ipairs(menu.paintmodgroups) do
					local row = ftable:addRow(true, { borderBelow = false })
					local row2 = ftable:addRow(false, {  })
					for i, entry in ipairs(group) do
						local col = i * 3 - 2

						local active, overridecolor = true, nil
						if menu.modeparam[1] then
							local missingcount = 0
							for _, ship in pairs(menu.modeparam[2]) do
								local paintmod = ffi.new("UIPaintMod")
								if C.GetInstalledPaintMod(ship, paintmod) then
									if entry.ware ~= ffi.string(paintmod.Ware) then
										missingcount = missingcount + 1
									end
								else
									missingcount = missingcount + 1
								end
							end
							if (not entry.isdefault) and (missingcount > entry.amount) then
								active = false
								overridecolor = Color["text_error"]
							end
						end

						local installicon, installcolor = "", Color["text_normal"]
						if entry.ware == menu.selectedPaintMod.ware then
							installicon = "be_upgrade_installed"
							installcolor = Color["text_positive"]
						elseif menu.installedPaintMod and (entry.ware == menu.installedPaintMod.ware) then
							installicon = "be_upgrade_uninstalled"
							installcolor = Color["text_negative"]
						end

						row[col]:setColSpan(3):createButton({
							width = columnWidths[i],
							height = maxColumnWidth,
							bgColor = active and Color["button_background_default"] or Color["button_background_inactive"],
							highlightColor = active and Color["button_highlight_default"] or Color["button_highlight_inactive"],
						}):setIcon(entry.ware):setIcon2(installicon, { color = installcolor }):setText((entry.amount and (entry.amount > 0)) and (ReadText(1001, 42) .. " " .. entry.amount) or "", { x = Helper.scaleX(Helper.configButtonBorderSize), y = - maxColumnWidth / 2 + Helper.standardTextHeight / 2 + Helper.configButtonBorderSize, halign = "right", fontsize = Helper.scaleFont(Helper.standardFont, Helper.headerRow1FontSize), color = overridecolor })
						if active then
							row[col].handlers.onClick = function () return menu.buttonSelectPaintMod(entry, row.index, col) end
						end

						local untruncatedExtraText = entry.isdefault and ReadText(1001, 8516) or entry.name
						local extraText = TruncateText(untruncatedExtraText, Helper.standardFont, menu.extraFontSize, columnWidths[i] - 2 * Helper.borderSize)
						row2[col]:setColSpan(3):createBoxText(extraText, { width = columnWidths[i], fontsize = menu.extraFontSize, color = overridecolor, boxColor = active and Color["button_background_default"] or Color["button_background_inactive"], mouseOverText = (extraText ~= untruncatedExtraText) and untruncatedExtraText or "" })
					end
				end
			else
				local row = ftable:addRow(true, { scaling = true })
				row[1]:setColSpan(9):createText("  " .. Helper.modQualities[categoryQuality].paintnonetext, { color = Helper.modQualities[categoryQuality].color })
			end
		end

		ftable:setTopRow(menu.topRows.slots)
		ftable:setSelectedRow(menu.selectedRows.slots)
		ftable:setSelectedCol(menu.selectedCols.slots or 0)

		ftable.properties.nextTable = buttontable.index
		buttontable.properties.prevTable = ftable.index
	end
	menu.topRows.slots = nil
	menu.selectedRows.slots = nil
	menu.selectedCols.slots = nil

end

function menu.displayModSlot(ftable, type, modclass, slot, slotdata, isgroup)
	local upgradetype
	if type ~= "ship" then
		upgradetype = Helper.findUpgradeType(type)
	end

	local isexpanded = menu.isModSlotExpanded(type, slot)
	if (type == "ship") or (upgradetype and upgradetype.mergeslots) then
		isexpanded = true
	end

	local turretcomponent
	local installedmod = {}
	local hasinstalledmod = false
	if type == "engine" then
		hasinstalledmod, installedmod = Helper.getInstalledModInfo(type, menu.object)
	elseif type == "shield" then
		hasinstalledmod, installedmod = Helper.getInstalledModInfo(type, menu.object, slotdata.context, slotdata.group)
	elseif (type == "turret") and isgroup then
		local groupinfo = C.GetUpgradeGroupInfo2(menu.object, "", slotdata.context, "", slotdata.group, "turret")
		turretcomponent = groupinfo.currentcomponent
		if turretcomponent == 0 then
			-- Nothing to mod here
			return
		end
		hasinstalledmod, installedmod = Helper.getInstalledModInfo(type, menu.object, slotdata.context, slotdata.group, isgroup)
	elseif type == "ship" then
		hasinstalledmod, installedmod = Helper.getInstalledModInfo(type, menu.object)
	elseif (type == "weapon") or (type == "turret") then
		hasinstalledmod, installedmod = Helper.getInstalledModInfo(type, slotdata.component)
	end

	local row = ftable:addRow({ slot }, { scaling = true, bgColor = Color["row_background_blue"] })
	if slot == menu.currentSlot then
		menu.selectedRows.slots = row.index
	end
	if (type ~= "ship") and ((not upgradetype) or (not upgradetype.mergeslots)) then
		row[1]:setBackgroundColSpan(1):createButton({ active = true }):setText(isexpanded and "-" or "+", { halign = "center" })
		row[1].handlers.onClick = function() return menu.expandModSlot(type, slot, row.index) end
		row[2]:setBackgroundColSpan(7)
	end
	if type == "ship" then
		if hasinstalledmod then
			row[2]:setColSpan(6)
			row[8]:createText("\27[" .. Helper.modQualities[installedmod.Quality].icon2 .. "]", { halign = "right" })
		else
			row[2]:setColSpan(7)
		end
		row[2]:createText(ffi.string(C.GetComponentName(menu.object)) .. " (" .. ReadText(1001, 8008) .. ReadText(1001, 120) .. " " .. GetMacroData(GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro"), "name") .. ")")
	elseif type == "shield" then
		if (slotdata.context == menu.object) and (slotdata.group == "") then
			if hasinstalledmod then
				row[2]:setColSpan(6)
				row[8]:createText("\27[" .. Helper.modQualities[installedmod.Quality].icon2 .. "]", { halign = "right" })
			else
				row[2]:setColSpan(7)
			end

			local name = upgradetype.text.default
			if slotdata.slotsize ~= "" then
				name = upgradetype.text[slotdata.slotsize]
			end
			row[2]:createText(slotdata.count .. "x " .. name)
		else
			if hasinstalledmod then
				row[6]:setColSpan(2)
				row[8]:createText("\27[" .. Helper.modQualities[installedmod.Quality].icon2 .. "]", { halign = "right" })
			else
				row[6]:setColSpan(3)
			end
			row[2]:setColSpan(4):createText(GetMacroData(GetComponentData(ConvertStringTo64Bit(tostring(slotdata.component)), "macro"), "name"))
			row[6]:createText("[" .. ReadText(1001, 8023) .. " " .. Helper.getSlotSizeText(slotdata.slotsize) .. slotdata.sizecount .. " (" .. menu.getUpgradeTypeText(slotdata.upgradetype) .. ")]")
		end
	elseif (type == "turret") and isgroup then
		if (slotdata.context ~= menu.object) or (slotdata.group ~= "") then
			if hasinstalledmod then
				row[6]:setColSpan(2)
				row[8]:createText("\27[" .. Helper.modQualities[installedmod.Quality].icon2 .. "]", { halign = "right" })
			else
				row[6]:setColSpan(3)
			end
			row[2]:setColSpan(4):createText(GetMacroData(GetComponentData(ConvertStringTo64Bit(tostring(turretcomponent)), "macro"), "name"))
			row[6]:createText("[" .. ReadText(1001, 8023) .. " " .. Helper.getSlotSizeText(slotdata.slotsize) .. slotdata.sizecount .. "]")
		end
	else
		if hasinstalledmod then
			row[6]:setColSpan(2)
			row[8]:createText("\27[" .. Helper.modQualities[installedmod.Quality].icon2 .. "]")
		else
			row[6]:setColSpan(3)
		end

		row[2]:setColSpan(4):createText(GetMacroData(slotdata.currentmacro, "name"))
		if (not uprgadetype) or (not upgradetype.mergeslots) then
			row[6]:createText("[" .. ReadText(1001, 66) .. " " .. slot .. "]", { halign = "right" })
		end
	end

	if isexpanded then
		if hasinstalledmod then
			-- name
			local color = Helper.modQualities[installedmod.Quality].color
			local row = ftable:addRow(true, { scaling = true })
			row[2]:setColSpan(5):createText(installedmod.Name, { color = color })
			row[7]:setColSpan(2):createText(ReadText(1001, 8033), { halign = "right", color = color })
			-- Effects
			local row = ftable:addRow(true, { scaling = true })
			row[2]:setColSpan(7):createText("   " .. ReadText(1001, 8034) .. ReadText(1001, 120))
			-- default property
			for i, property in ipairs(Helper.modProperties[modclass]) do
				if property.key == installedmod.PropertyType then
					if installedmod[property.key] ~= property.basevalue then
						local effectcolor
						if installedmod[property.key] > property.basevalue then
							effectcolor = property.pos_effect and Color["text_positive"] or Color["text_negative"]
						else
							effectcolor = property.pos_effect and Color["text_negative"] or Color["text_positive"]
						end
						local row = ftable:addRow(true, { scaling = true })
						row[2]:setColSpan(5):createText("      " .. property.text, { font = Helper.standardFontBold })
						row[7]:setColSpan(2):createText(property.eval(installedmod[property.key]), { font = Helper.standardFontBold, halign = "right", color = effectcolor })
					end
					break
				end
			end
			-- other properties
			for i, property in ipairs(Helper.modProperties[modclass]) do
				if property.key ~= installedmod.PropertyType then
					if installedmod[property.key] ~= property.basevalue then
						local effectcolor
						if installedmod[property.key] > property.basevalue then
							effectcolor = property.pos_effect and Color["text_positive"] or Color["text_negative"]
						else
							effectcolor = property.pos_effect and Color["text_negative"] or Color["text_positive"]
						end
						local row = ftable:addRow(true, { scaling = true })
						row[2]:setColSpan(5):createText("      " .. property.text)
						row[7]:setColSpan(2):createText(property.eval(installedmod[property.key]), { halign = "right", color = effectcolor })
					end
				end
			end
			-- dismantle
			local row = ftable:addRow(true, { scaling = true })
			row[1]:setColSpan(4)
			row[5]:setColSpan(4):createButton({  }):setText(ReadText(1001, 6601), { halign = "center" })
			if (type == "ship") or (type == "engine") then
				row[5].handlers.onClick = function () return menu.buttonDismantleMod(type, menu.object) end
			elseif (type == "turret") and isgroup then
				row[5].handlers.onClick = function () return menu.buttonDismantleMod(type, menu.object, slotdata.context, slotdata.group) end
			elseif type == "shield" then
				row[5].handlers.onClick = function () return menu.buttonDismantleMod(type, menu.object, slotdata.context, slotdata.group) end
			else
				row[5].handlers.onClick = function () return menu.buttonDismantleMod(type, slotdata.component) end
			end
		else
			local row = ftable:addRow(true, { scaling = true })
			row[2]:setColSpan(7):createText(ReadText(1001, 8032))
		end

		-- available mods
		local categoryQuality = menu.getModQuality(menu.modCategory)
		if not categoryQuality then
			DebugError(string.format("Could not resolve mod category '%s' to quality level. Check Helper.modQualities [Florian]", menu.modCategory))
			return
		end
		local found = false
		if menu.modwares[modclass] then
			for _, entry in ipairs(menu.modwares[modclass]) do
				if entry.quality == categoryQuality then
					if (type == "turret") and isgroup then
						if C.CheckWeaponModCompatibility(turretcomponent, entry.ware) then
							found = true
							menu.displayModBlueprint(ftable, type, slot, slotdata, modclass, entry, hasinstalledmod, installedmod.Ware, isgroup)
						end
					elseif modclass == "weapon" then
						if C.CheckWeaponModCompatibility(slotdata.component, entry.ware) then
							found = true
							menu.displayModBlueprint(ftable, type, slot, slotdata, modclass, entry, hasinstalledmod, installedmod.Ware)
						end
					elseif modclass == "shield" then
						if C.CheckGroupedShieldModCompatibility(menu.object, slotdata.context, slotdata.group, entry.ware) then
							found = true
							menu.displayModBlueprint(ftable, type, slot, slotdata, modclass, entry, hasinstalledmod, installedmod.Ware)
						end
					elseif modclass == "ship" then
						if C.CheckShipModCompatibility(menu.object, entry.ware) then
							found = true
							menu.displayModBlueprint(ftable, type, slot, slotdata, modclass, entry, hasinstalledmod, installedmod.Ware)
						end
					else
						found = true
						menu.displayModBlueprint(ftable, type, slot, slotdata, modclass, entry, hasinstalledmod, installedmod.Ware)
					end
				end
			end
		end
		if not found then
			local row = ftable:addRow(true, { scaling = true })
			row[2]:setColSpan(7):createText(" " .. Helper.modQualities[categoryQuality].nonetext, { color = Helper.modQualities[categoryQuality].color })
		end
	end
end

function menu.displayModBlueprint(ftable, type, slot, slotdata, modclass, moddata, hasinstalledmod, installedmodware, isgroup)
	local isexpanded = menu.isModSlotExpanded(type, slot .. moddata.ware)
	-- mod name
	local propertymodname = ffi.string(C.GetEquipmentModPropertyName(moddata.ware))
	local row = ftable:addRow(true, { scaling = true })
	row[1]:setBackgroundColSpan(1):createButton({ active = true }):setText(isexpanded and "-" or "+", { halign = "center" })
	row[1].handlers.onClick = function() return menu.expandModSlot(type, slot .. moddata.ware, row.index) end
	row[2]:setBackgroundColSpan(6):setColSpan(5):createText(" " .. GetWareData(moddata.ware, "shortname") .. ((propertymodname ~= "") and (" (" .. propertymodname .. ")") or ""), { color = Helper.modQualities[moddata.quality].color })
	row[7]:setColSpan(2):createText(ReadText(1001, 42) .. " " .. moddata.craftableamount, { halign = "right" })

	if isexpanded then
		-- Resources
		for _, resource in ipairs(moddata.resources) do
			local row = ftable:addRow(true, { scaling = true })
			local color = (resource.data.amount < resource.data.needed) and Color["text_inactive"] or Color["text_normal"]
			-- name
			row[2]:setColSpan(5):createText("      " .. resource.data.name, { color = color })
			-- amount
			row[7]:setColSpan(2):createText(resource.data.amount .. " / " .. resource.data.needed, { halign = "right", color = color })
		end
		-- Effects
		local row = ftable:addRow(true, { scaling = true })
		row[2]:setColSpan(7):createText("   " .. ReadText(1001, 8034) .. ReadText(1001, 120))
		-- Property
		local moddef = C.GetEquipmentModInfo(moddata.ware)
		local propertytype = ffi.string(moddef.PropertyType)
		for i, property in ipairs(Helper.modProperties[modclass]) do
			if property.key == propertytype then
				local minvalue = moddef["MinValue" .. property.type]
				local mineffectcolor = Color["text_normal"]
				if minvalue > property.basevalue then
					mineffectcolor = property.pos_effect and Color["text_positive"] or Color["text_negative"]
				elseif minvalue < property.basevalue then
					mineffectcolor = property.pos_effect and Color["text_negative"] or Color["text_positive"]
				end

				local maxvalue = moddef["MaxValue" .. property.type]
				local maxeffectcolor = Color["text_normal"]
				if maxvalue > property.basevalue then
					maxeffectcolor = property.pos_effect and Color["text_positive"] or Color["text_negative"]
				elseif maxvalue < property.basevalue then
					maxeffectcolor = property.pos_effect and Color["text_negative"] or Color["text_positive"]
				end

				local row = ftable:addRow(true, { scaling = true })
				row[2]:setColSpan(4):createText("      " .. property.text, { font = Helper.standardFontBold })
				if property.pos_effect and (minvalue < maxvalue) or (minvalue > maxvalue) then
					row[6]:setColSpan(3):createText(property.eval2(minvalue, mineffectcolor, maxvalue, maxeffectcolor), { font = Helper.standardFontBold, halign = "right" })
				else
					row[6]:setColSpan(3):createText(property.eval2(maxvalue, maxeffectcolor, minvalue, mineffectcolor), { font = Helper.standardFontBold, halign = "right" })
				end
				break
			end
		end
		-- Bonus properties
		if moddef.BonusMax > 0 then
			local mouseovertext = ReadText(1026, 8005) .. ReadText(1001, 120)
			for n = 1, moddef.BonusMax do
				-- n < n_max:
				-- p_n = p^n * (1-p)
				-- n == n_max:
				-- p_n_max = p^n_max
				local probability = ((moddef.BonusChance ^ n) * ((n ~= moddef.BonusMax) and (1 - moddef.BonusChance) or 1))
				mouseovertext = mouseovertext .. "\n" .. string.format("%+d %s%s %4.1f%%", n, ReadText(1001, 6602), ReadText(1001, 120), probability * 100)
			end

			local row = ftable:addRow(true, { scaling = true })
			row[2]:setColSpan(5):createText("      " .. ((moddef.BonusMax == 1) and ReadText(1001, 8039) or string.format(ReadText(1001, 8040), moddef.BonusMax)), { mouseOverText = mouseovertext })
			row[7]:setColSpan(2):createText("???", { halign = "right" })
		end
		-- Install
		local row = ftable:addRow(true, { scaling = true })
		row[1]:setColSpan(4)
		local playermoney = GetPlayerMoney()
		local text = menu.isplayerowned and ReadText(1001, 4803) or string.format(ReadText(1001, 8043) .. " " .. ReadText(1001, 101), ConvertMoneyString(Helper.modQualities[moddata.quality].price * menu.moddingdiscounts.totalfactor, false, true, 0, true, false))
		local active = true
		local mouseovertext = ""
		local dismantle = false

		local hasmoney = menu.isplayerowned or (playermoney >= Helper.modQualities[moddata.quality].price * menu.moddingdiscounts.totalfactor)
		if hasinstalledmod then
			if (moddata.ware == installedmodware) then
				if (moddata.normalcraftableamount > 0) and hasmoney then
					text = menu.isplayerowned and ReadText(1001, 6608) or string.format(ReadText(1001, 6609) .. " " .. ReadText(1001, 101), ConvertMoneyString(Helper.modQualities[moddata.quality].price * menu.moddingdiscounts.totalfactor, false, true, 0, true, false))
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n"
					end
					mouseovertext = mouseovertext .. ReadText(1026, 6601)
					dismantle = true
				end
			else
				active = false
				if mouseovertext ~= "" then
					mouseovertext = mouseovertext .. "\n"
				end
				mouseovertext = mouseovertext .. ReadText(1026, 8006)
			end
		end
		if (not dismantle) and (moddata.craftableamount == 0) then
			active = false
			if mouseovertext ~= "" then
				mouseovertext = mouseovertext .. "\n"
			end
			mouseovertext = mouseovertext .. ReadText(1026, 8007)
		end
		if not hasmoney then
			active = false
			if mouseovertext ~= "" then
				mouseovertext = mouseovertext .. "\n"
			end
			mouseovertext = mouseovertext .. ReadText(1026, 8008)
		end
		if not dismantle then
			if mouseovertext ~= "" then
				mouseovertext = ColorText["text_error"] .. mouseovertext
			end
		end
		row[5]:setColSpan(4):createButton({ active = active, mouseOverText = mouseovertext }):setText(text, { halign = "center" })
		if (type == "ship") or (type == "engine") then
			row[5].handlers.onClick = function () return menu.buttonInstallMod(type, menu.object, moddata.ware, Helper.modQualities[moddata.quality].price, nil, nil, dismantle) end
		elseif (type == "turret") and isgroup then
			row[5].handlers.onClick = function () return menu.buttonInstallMod(type, menu.object, moddata.ware, Helper.modQualities[moddata.quality].price, slotdata.context, slotdata.group, dismantle) end
		elseif type == "shield" then
			row[5].handlers.onClick = function () return menu.buttonInstallMod(type, menu.object, moddata.ware, Helper.modQualities[moddata.quality].price, slotdata.context, slotdata.group, dismantle) end
		else
			row[5].handlers.onClick = function () return menu.buttonInstallMod(type, slotdata.component, moddata.ware, Helper.modQualities[moddata.quality].price, nil, nil, dismantle) end
		end
	end
end

function menu.displayEmptySlots(frame)
	local ftable = frame:addTable(1, { tabOrder = 1, width = menu.slotData.width, height = 0, x = menu.slotData.offsetX, y = menu.slotData.offsetY, scaling = true, reserveScrollBar = false, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })

	local row = ftable:addRow(false, { bgColor = Color["row_title_background"] })
	row[1]:createText(ReadText(1001, 7935), menu.headerTextProperties)

	row = ftable:addRow(false, { scaling = true })
	row[1]:createText(ReadText(1001, 8013))

	menu.topRows.slots = nil
	menu.selectedRows.slots = nil
	menu.selectedCols.slots = nil
end

function menu.checkLicence(macro, rawicon, issoftware, rawmouseovertext)
	local haslicence = true
	local icon
	local overridecolor = Color["text_normal"]
	local mouseovertext = ""
	local limitstring = ""
	if macro ~= "" then
		local ware
		if issoftware then
			ware = macro
		else
			ware = GetMacroData(macro, "ware")
		end
		if ware == nil or ware == "" then
			print("no ware defined for macro '" .. macro .. "'")
		else
			local tradelicence, isblueprintsaleonly, researchprecursors, islimited = GetWareData(ware, "tradelicence", "isblueprintsaleonly", "productionresearchprecursors", "islimited")
			if (not menu.isReadOnly) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
				local alreadyinshoppinglist = false
				for i, entry in ipairs(menu.shoppinglist) do
					if i ~= menu.editingshoppinglist then
						if entry.macro == macro then
							alreadyinshoppinglist = true
						end
					end
				end

				if (not menu.isplayerowned) and isblueprintsaleonly then
					haslicence = false
					icon = "menu_locked"
					mouseovertext = ReadText(1026, 8019)
				elseif researchprecursors and (#researchprecursors > 0) then
					mouseovertext = ReadText(1026, 8023) .. " "
					local first = true
					for _, research in ipairs(researchprecursors) do
						if (not C.HasResearched(research)) or alreadyinshoppinglist then
							haslicence = false
							mouseovertext = mouseovertext .. (first and " " or "\n") .. ColorText["text_error"] .. GetWareData(research, "name") .. "\27X"
						else
							mouseovertext = mouseovertext .. (first and " " or "\n") .. GetWareData(research, "name")
						end
					end
					icon = "gamestart_custom_research"
				else
					if tradelicence ~= "" then
						haslicence = HasLicence("player", tradelicence, menu.containerowner)
						local licenceinfo = ffi.new("LicenceInfo")
						if C.GetLicenceInfo(licenceinfo, menu.containerowner, tradelicence) then
							icon = ffi.string(licenceinfo.icon)
							if icon ~= "" then
								if not rawicon then
									icon = "\27[" .. icon .. "]"
								end
								mouseovertext = (rawmouseovertext and "" or (haslicence and "" or ColorText["text_error"])) .. string.format(ReadText(1026, 8003), ffi.string(licenceinfo.name))
							end
						end
					end
				end
			end
			if islimited and (not menu.isReadOnly) and (menu.mode ~= "comparison") and (not menu.modeparam.creative) then
				local limitamount = Helper.getLimitedWareAmount(ware)
				local shoppinglistamount = 0
				for i, entry in ipairs(menu.shoppinglist) do
					if i ~= menu.editingshoppinglist then
						if entry.macro == macro then
							shoppinglistamount = shoppinglistamount + entry.amount
						end
					end
				end

				local used = (menu.usedLimitedMacros[macro] or 0) + shoppinglistamount
				if used >= limitamount then
					haslicence = false
					icon = "menu_locked"
					mouseovertext = ReadText(1026, 8028)
				end
				limitstring = " (" .. used .. "/" .. limitamount .. ")"
			end
			if not haslicence then
				overridecolor = Color["text_error"]
			end
		end
	end

	return haslicence, icon, overridecolor, mouseovertext, limitstring
end

function menu.checkMod(type, component, isgroup)
	local hasmod, modicon = false, ""
	if component then
		if (type == "turret") and isgroup then
			local shieldgroup = ffi.new("ShieldGroup")
			local found = C.GetShieldGroup(shieldgroup, menu.object, component)
			if found then
				local buf = ffi.new("UIWeaponMod")
				hasmod = C.GetInstalledGroupedWeaponMod(menu.object, shieldgroup.context, shieldgroup.group, buf)
				if hasmod then
					modicon = "\27[" .. Helper.modQualities[buf.Quality].icon2 .. "]"
				end
			end
		elseif (type == "weapon") or (type == "turret") then
			local buf = ffi.new("UIWeaponMod")
			hasmod = C.GetInstalledWeaponMod(component, buf)
			if hasmod then
				modicon = "\27[" .. Helper.modQualities[buf.Quality].icon2 .. "]"
			end
		elseif type == "engine" then
			local buf = ffi.new("UIEngineMod")
			hasmod = C.GetInstalledEngineMod(menu.object, buf)
			if hasmod then
				modicon = "\27[" .. Helper.modQualities[buf.Quality].icon2 .. "]"
			end
		elseif type == "shield" then
			local shieldgroup = ffi.new("ShieldGroup")
			local found = C.GetShieldGroup(shieldgroup, menu.object, component)
			if found then
				local buf = ffi.new("UIShieldMod")
				hasmod = C.GetInstalledShieldMod(menu.object, shieldgroup.context, shieldgroup.group, buf)
				if hasmod then
					modicon = "\27[" .. Helper.modQualities[buf.Quality].icon2 .. "]"
				end
			end
		end
	end

	return hasmod, modicon
end

function menu.checkEquipment(removedEquipment, currentEquipment, newEquipment, repairedEquipment, data, object)
	local canequip = true
	if menu.mode == "upgrade" then
		if not menu.isReadOnly then
			canequip = C.CanContainerEquipShip(menu.container, object or menu.object)
		end
	end
	local hasupgrades, hasrepairs = false, false
	local objectEquipment = {
		removed = {},
		current = {},
		new = {},
		repaired = {},
	}

	local groups   = data and data.groups   or menu.groups
	local slots    = data and data.slots    or menu.slots
	local ammo     = data and data.ammo     or menu.ammo
	local software = data and data.software or menu.software
	-- Equipment
	for i, upgradetype in ipairs(Helper.upgradetypes) do
		local upgradeplanslots = menu.upgradeplan[upgradetype.type]
		local first = true
		for slot, macro in pairs(upgradeplanslots) do
			if first or (not upgradetype.mergeslots) then
				first = false
				if (upgradetype.supertype == "group") and (not upgradetype.pseudogroup) then
					local data = macro
					local oldslotdata = groups[slot][upgradetype.grouptype]

					if canequip then
						if data.macro ~= "" then
							local i = menu.findUpgradeMacro(upgradetype.grouptype, data.macro)
							if not i then
								break
							end
							local upgradeware = menu.upgradewares[upgradetype.grouptype][i]

							if oldslotdata.currentmacro ~= "" then
								local j = menu.findUpgradeMacro(upgradetype.grouptype, oldslotdata.currentmacro)
								if not j then
									break
								end
								local oldupgradeware = menu.upgradewares[upgradetype.grouptype][j]

								if data.macro == oldslotdata.currentmacro then
									if upgradetype.mergeslots then
										menu.insertWare(currentEquipment, objectEquipment.current, upgradetype.grouptype, upgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or data.count))
									else
										if oldslotdata.count < data.count then
											menu.insertWare(currentEquipment, objectEquipment.current, upgradetype.grouptype, upgradeware.ware, oldslotdata.count)
											menu.insertWare(newEquipment, objectEquipment.new, upgradetype.grouptype, upgradeware.ware, data.count - oldslotdata.count, "normal")
											hasupgrades = true
										elseif oldslotdata.count > data.count then
											menu.insertWare(currentEquipment, objectEquipment.current, upgradetype.grouptype, upgradeware.ware, data.count)
											menu.insertWare(removedEquipment, objectEquipment.removed, upgradetype.grouptype, upgradeware.ware, oldslotdata.count - data.count, "normal")
											hasupgrades = true
										else
											menu.insertWare(currentEquipment, objectEquipment.current, upgradetype.grouptype, upgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or data.count))
										end
									end
								else
									menu.insertWare(removedEquipment, objectEquipment.removed, upgradetype.grouptype, oldupgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or oldslotdata.count), "normal")
									menu.insertWare(newEquipment, objectEquipment.new, upgradetype.grouptype, upgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or data.count), "normal")
									hasupgrades = true
								end
							else
								menu.insertWare(newEquipment, objectEquipment.new, upgradetype.grouptype, upgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or data.count), "normal")
								hasupgrades = true
							end
						elseif oldslotdata.currentmacro ~= "" then
							local j = menu.findUpgradeMacro(upgradetype.grouptype, oldslotdata.currentmacro)
							if not j then
								break
							end
							local oldupgradeware = menu.upgradewares[upgradetype.grouptype][j]

							menu.insertWare(removedEquipment, objectEquipment.removed, upgradetype.grouptype, oldupgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or oldslotdata.count), "normal")
							hasupgrades = true
						end
					else
						if oldslotdata.currentmacro ~= "" then
							local j = menu.findUpgradeMacro(upgradetype.grouptype, oldslotdata.currentmacro)
							if not j then
								break
							end
							local oldupgradeware = menu.upgradewares[upgradetype.grouptype][j]

							menu.insertWare(currentEquipment, objectEquipment.current, upgradetype.grouptype, oldupgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or oldslotdata.count), "normal")
						end
					end
				elseif (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
					local data = macro
					local oldslotdata = slots[upgradetype.type][slot]
					if oldslotdata == nil then
						-- for catching a rare bug
						print(upgradetype.type, slot)
						for k, v in pairs(slots[upgradetype.type]) do
							print(k .. ": " .. tostring(v))
						end
					end
					if canequip then
						if data.macro ~= "" then
							local i = menu.findUpgradeMacro(upgradetype.type, data.macro)
							if not i then
								break
							end
							local upgradeware = menu.upgradewares[upgradetype.type][i]

							if oldslotdata.currentmacro ~= "" then
								local j = menu.findUpgradeMacro(upgradetype.type, oldslotdata.currentmacro)
								if not j then
									break
								end
								local oldupgradeware = menu.upgradewares[upgradetype.type][j]

								if data.macro == oldslotdata.currentmacro then
									menu.insertWare(currentEquipment, objectEquipment.current, upgradetype.type, upgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or 1))
								else
									menu.insertWare(removedEquipment, objectEquipment.removed, upgradetype.type, oldupgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or 1), "normal")
									menu.insertWare(newEquipment, objectEquipment.new, upgradetype.type, upgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or 1), "normal")
									hasupgrades = true
								end
							else
								menu.insertWare(newEquipment, objectEquipment.new, upgradetype.type, upgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or 1), "normal")
								hasupgrades = true
							end
						elseif oldslotdata.currentmacro ~= "" then
							local j = menu.findUpgradeMacro(upgradetype.type, oldslotdata.currentmacro)
							if not j then
								break
							end
							local oldupgradeware = menu.upgradewares[upgradetype.type][j]

							menu.insertWare(removedEquipment, objectEquipment.removed, upgradetype.type, oldupgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or 1), "normal")
							hasupgrades = true
						end
					else
						if oldslotdata.currentmacro ~= "" then
							local j = menu.findUpgradeMacro(upgradetype.grouptype, oldslotdata.currentmacro)
							if not j then
								break
							end
							local oldupgradeware = menu.upgradewares[upgradetype.grouptype][j]

							menu.insertWare(currentEquipment, objectEquipment.current, upgradetype.type, oldupgradeware.ware, (upgradetype.mergeslots and #upgradeplanslots or 1), "normal")
						end
					end
				elseif upgradetype.supertype == "ammo" then
					if ammo[upgradetype.type][slot] then
						local current = ammo[upgradetype.type][slot]
						local new = macro
						local macro = slot
						if (current > 0) or (current ~= new) then
							local j = menu.findUpgradeMacro(upgradetype.type, macro)
							if not j then
								break
							end
							local upgradeware = menu.upgradewares[upgradetype.type][j]

							if current < new then
								if current > 0 then
									menu.insertWare(currentEquipment, objectEquipment.current, "consumables", upgradeware.ware, current)
								end
								menu.insertWare(newEquipment, objectEquipment.new, "consumables", upgradeware.ware, new - current, "normal")
								hasupgrades = true
							elseif current > new then
								if new > 0 then
									menu.insertWare(currentEquipment, objectEquipment.current, "consumables", upgradeware.ware, new)
								end
								menu.insertWare(removedEquipment, objectEquipment.removed, "consumables", upgradeware.ware, current - new, "normal")
								hasupgrades = true
							elseif current > 0 then
								menu.insertWare(currentEquipment, objectEquipment.current, "consumables", upgradeware.ware, current)
							end
						end
					end
				elseif upgradetype.supertype == "software" then
					local newware = macro
					local oldware = software[upgradetype.type][slot].currentsoftware
					if oldware ~= newware then
						if oldware ~= "" then
							menu.insertWare(removedEquipment, objectEquipment.removed, upgradetype.supertype, oldware, 1, "software")
							hasupgrades = true
						end
						if newware ~= "" then
							menu.insertWare(newEquipment, objectEquipment.new, upgradetype.supertype, newware, 1, "software")
							hasupgrades = true
						end
					elseif newware ~= "" then
						menu.insertWare(currentEquipment, objectEquipment.current, upgradetype.supertype, newware, 1)
					end
				end
			end
		end
	end

	-- Crew
	if menu.objectgroup == nil then
		if menu.crew.hired > 0 then
			local color = Color["text_positive"]

			menu.insertWare(newEquipment, objectEquipment.new, "crew", menu.crew.ware, menu.crew.hired, "crew")
			hasupgrades = true
			if menu.crew.total - #menu.crew.fired > 0 then
				menu.insertWare(currentEquipment, objectEquipment.current, "crew", menu.crew.ware, menu.crew.total - #menu.crew.fired)
			end
			if #menu.crew.fired > 0 then
				menu.insertWare(removedEquipment, objectEquipment.removed, "crew", menu.crew.ware, #menu.crew.fired, "crew")
				hasupgrades = true
			end
		elseif #menu.crew.fired > 0 then
			menu.insertWare(removedEquipment, objectEquipment.removed, "crew", menu.crew.ware, #menu.crew.fired, "crew")
			hasupgrades = true
			if (menu.crew.total - #menu.crew.fired) > 0 then
				menu.insertWare(currentEquipment, objectEquipment.current, "crew", menu.crew.ware, menu.crew.total - #menu.crew.fired)
			end
		elseif menu.crew.total > 0 then
			menu.insertWare(currentEquipment, objectEquipment.current, "crew", menu.crew.ware, menu.crew.total)
		end
	end

	-- Repair
	local objectidstring = tostring(object or menu.object)
	if menu.repairplan and menu.repairplan[objectidstring] then
		for componentidstring in pairs(menu.repairplan[objectidstring]) do
			if componentidstring ~= "processed" then
				menu.insertComponent(repairedEquipment, objectEquipment.repaired, componentidstring, "normal")
				hasrepairs = true
			end
		end
	end

	local totalprice = 0
	local totalcrewprice = 0
	if not menu.isplayerowned then
		if menu.object == 0 then
			if (not menu.isReadOnly) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
				totalprice = totalprice + tonumber(C.GetBuildWarePrice(menu.container, GetMacroData(menu.macro, "ware") or ""))
			end
		end
		for _, data in pairs(removedEquipment) do
			for _, entry in ipairs(data) do
				if entry.ware == menu.crew.ware then
					totalcrewprice = totalcrewprice - entry.amount * entry.price
				else
					totalprice = totalprice - entry.amount * entry.price
				end
			end
		end
		for _, data in pairs(newEquipment) do
			for _, entry in ipairs(data) do
				if entry.ware == menu.crew.ware then
					totalcrewprice = totalcrewprice + entry.amount * entry.price
				else
					totalprice = totalprice + entry.amount * entry.price
				end
			end
		end
		for _, entry in ipairs(repairedEquipment) do
			totalprice = totalprice + entry.price
		end
	end
	local objectprice = 0
	local objectcrewprice = 0
	if not menu.isplayerowned then
		if menu.object == 0 then
			if (not menu.isReadOnly) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
				objectprice = objectprice + tonumber(C.GetBuildWarePrice(menu.container, GetMacroData(menu.macro, "ware") or ""))
			end
		end
		for _, data in pairs(objectEquipment.removed) do
			for _, entry in ipairs(data) do
				if entry.ware == menu.crew.ware then
					objectcrewprice = objectcrewprice - entry.amount * entry.price
				else
					objectprice = objectprice - entry.amount * entry.price
				end
			end
		end
		for _, data in pairs(objectEquipment.new) do
			for _, entry in ipairs(data) do
				if entry.ware == menu.crew.ware then
					objectcrewprice = objectcrewprice + entry.amount * entry.price
				else
					objectprice = objectprice + entry.amount * entry.price
				end
			end
		end
		for _, entry in ipairs(objectEquipment.repaired) do
			objectprice = objectprice + entry.price
		end
	end

	return RoundTotalTradePrice(totalprice), RoundTotalTradePrice(totalcrewprice), hasupgrades, hasrepairs, RoundTotalTradePrice(objectprice), RoundTotalTradePrice(objectcrewprice)
end

function menu.getAddedPeopleFromBuildTask(container, taskid)
	local result = 0

	local numcrewentries = C.GetNumBuildTaskCrewTransferInfo(container, taskid)
	local crewtransferinfo = ffi.new("CrewTransferInfo2")
	crewtransferinfo.numadded = numcrewentries.numadded
	crewtransferinfo.added = Helper.ffiNewHelper("CrewTransferContainer2[?]", numcrewentries.numadded)
	crewtransferinfo.numremoved = numcrewentries.numremoved
	crewtransferinfo.removed = Helper.ffiNewHelper("CrewTransferContainer2[?]", numcrewentries.numremoved)
	crewtransferinfo.numtransferred = numcrewentries.numtransferred
	crewtransferinfo.transferred = Helper.ffiNewHelper("CrewTransferContainer2[?]", numcrewentries.numtransferred)

	C.GetBuildTaskCrewTransferInfo2(crewtransferinfo, container, taskid)
	for j = 0, crewtransferinfo.numadded - 1 do
		result = result + crewtransferinfo.added[j].amount
	end

	return result
end

function menu.warningColor(normalcolor)
	local color = normalcolor

	local curtime = getElapsedTime()
	if menu.warningShown and (curtime < menu.warningShown + 2) then
		-- number between 0 and 1, duration 1s
		local x = curtime % 1

		normalcolor = normalcolor or Color["text_warning"]
		overridecolor = Color["text_normal"]
		color = {
			r = (1 - x) * overridecolor.r + x * normalcolor.r,
			g = (1 - x) * overridecolor.g + x * normalcolor.g,
			b = (1 - x) * overridecolor.b + x * normalcolor.b,
			a = (1 - x) * overridecolor.a + x * normalcolor.a,
		}
	end
	return color
end

function menu.displayPlan(frame)
	-- errors & warnings
	menu.criticalerrors = {}
	menu.errors = {}
	menu.warnings = {}

	if (menu.mode == "purchase") or (menu.mode == "upgrade") then
		if menu.container and ((menu.object ~= 0) or (menu.macro ~= "")) then
			if not C.HasSuitableBuildModule(menu.container, menu.object, menu.macro) then
				menu.errors[4] = menu.objectgroup and ReadText(1001, 8572) or ReadText(1001, 8563)
			end
		end
	end

	if (menu.mode == "purchase") and (menu.macro ~= "") then
		if not menu.validLicence then
			local haslicence, icon, overridecolor, mouseovertext = menu.checkLicence(menu.macro, true, nil, true)
			menu.errors[2] = mouseovertext
		end
		if not menu.validLoadoutPossible then
			menu.criticalerrors[5] = ReadText(1001, 8528)
		end
	end

	if (menu.mode == "customgamestart") and (menu.macro ~= "") and (not menu.modeparam.creative) then
		local haslicence, icon, overridecolor, mouseovertext = menu.checkLicence(menu.macro, true, nil, true)
		if not haslicence then
			menu.criticalerrors[6] = mouseovertext
		end
	end

	if ((menu.mode == "upgrade") or (menu.mode == "modify")) and (menu.object ~= 0) then
		if menu.tasks[tostring(menu.object)] then
			menu.errors[3] = function (_, notime)
				local timestring
				if (not notime) and (type(menu.tasks[tostring(menu.object)]) == "userdata") then
					timestring = "--:--"
					local buildtask = ConvertIDTo64Bit(menu.tasks[tostring(menu.object)])
					local buildtaskinfo = C.GetBuildTaskInfo(buildtask)
					if buildtaskinfo.buildingcontainer ~= 0 then
						if (buildtaskinfo.queueposition == 0) and (buildtaskinfo.buildercomponent ~= 0) then
							timestring = ConvertTimeString(C.GetBuildProcessorEstimatedTimeLeft(buildtaskinfo.buildercomponent), "%h:%M:%S")
						end
					end
				end
				return ReadText(1001, 8521) .. (timestring and (" (" .. ReadText(1001, 2923) .. ReadText(1001, 120) .. " " .. timestring .. ")") or "")
			end
		end
	end

	local hasminingequipment, hasmilitaryequipment = false, false
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		local slots = menu.upgradeplan[upgradetype.type]
		for slot, macro in pairs(slots) do
			-- current allowempty warning
			local allowempty
			if upgradetype.supertype == "macro" then
				local data = macro
				if data.macro == "" then
					allowempty = upgradetype.allowempty and (not C.IsSlotMandatory(menu.object, 0, menu.macro, false, upgradetype.type, slot))
				else
					local isminingweapon = GetMacroData(data.macro, "isminingweapon")
					hasminingequipment = hasminingequipment or isminingweapon
					hasmilitaryequipment = hasmilitaryequipment or (not isminingweapon)
				end
			elseif upgradetype.supertype == "group" then
				local data = macro
				if data.macro ~= "" then
					local isminingweapon = GetMacroData(data.macro, "isminingweapon")
					hasminingequipment = hasminingequipment or isminingweapon
					hasmilitaryequipment = hasmilitaryequipment or (not isminingweapon)
				end
			elseif upgradetype.supertype == "virtualmacro" then
				local data = macro
				if data.macro == "" then
					allowempty = upgradetype.allowempty
				end
			else
				if macro == "" then
					allowempty = upgradetype.allowempty
				end
			end
			if allowempty == false then
				if (menu.mode == "customgamestart") or (menu.mode == "comparison") then
					menu.criticalerrors[2] = ReadText(1001, 8020)
				else
					menu.errors[1] = menu.objectgroup and ReadText(1001, 8568) or ReadText(1001, 8020)
				end
				break
			end
		end
		-- missing software
		if upgradetype.supertype == "software" then
			if menu.software[upgradetype.type] then
				for slot, slotdata in ipairs(menu.software[upgradetype.type]) do
					if #slotdata.possiblesoftware > 0 then
						if (slotdata.defaultsoftware ~= 0) and (menu.upgradeplan[upgradetype.type][slot] == "") then
							if (menu.mode == "customgamestart") or (menu.mode == "comparison") then
								menu.criticalerrors[2] = ReadText(1001, 8020)
							else
								menu.errors[1] = menu.objectgroup and ReadText(1001, 8568) or ReadText(1001, 8020)
							end
							break
						end
					end
				end
			end
		end
		-- missing captain
		if (menu.mode == "purchase") and (not menu.captainSelected) then
			menu.errors[1] = ReadText(1001, 8020)
		end
		-- current ammo warning
		if upgradetype.supertype == "ammo" then
			local total, capacity = menu.getAmmoUsage(upgradetype.type)
			if total > capacity then
				menu.warnings[2] = menu.objectgroup and ReadText(1001, 8569) or ReadText(1001, 8021)
			end
		end
	end
	local purpose, storagetags
	local transporttypes
	if menu.macro ~= "" then
		purpose, storagetags = GetMacroData(menu.macro, "primarypurpose", "storagetags")
	elseif menu.object ~= 0 then
		local primarypurpose, macro = GetComponentData(ConvertStringToLuaID(tostring(menu.object)), "primarypurpose", "macro")
		purpose = primarypurpose
		storagetags = GetMacroData(macro, "storagetags")
	end
	if purpose ~= nil then
		-- mining equipment warning
		if (purpose == "mine") and (storagetags["universal"] or storagetags["solid"]) and (not hasminingequipment) then
			menu.warnings[7] = menu.objectgroup and ReadText(1001, 8584) or ReadText(1001, 8583)
		end
		-- combat equipment warning
		if ((purpose == "fight") or (purpose == "auxiliary")) and (not hasmilitaryequipment) then
			menu.warnings[8] = menu.objectgroup and ReadText(1001, 8586) or ReadText(1001, 8585)
		end
	end

	-- current crew warning
	if #menu.crew.unassigned > 0 then
		menu.warnings[3] = ReadText(1001, 8022)
	end
	-- resource warning
	if menu.mode == "purchase" then
		local considerCurrent = false
		if (menu.macro ~= "") and (menu.editingshoppinglist == nil) then
			considerCurrent = true
		end
		local numorders = #menu.shoppinglist + (considerCurrent and 1 or 0)
		local buildorders = ffi.new("UIBuildOrderList[?]", numorders)
		for i, entry in ipairs(menu.shoppinglist) do
			buildorders[i - 1].shipid = 0
			buildorders[i - 1].macroname = Helper.ffiNewString(entry.macro)
			buildorders[i - 1].loadout = Helper.callLoadoutFunction(entry.upgradeplan, nil, function (loadout, _) return loadout end, false)
			buildorders[i - 1].amount = entry.amount
		end
		if considerCurrent then
			local index = #menu.shoppinglist
			buildorders[index].shipid = 0
			buildorders[index].macroname = Helper.ffiNewString(menu.macro)
			buildorders[index].loadout = Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return loadout end, false)
			buildorders[index].amount = 1
		end

		menu.missingResources = {}
		if not menu.errors[4] then
			local n = C.GetNumMissingBuildResources2(menu.container, buildorders, numorders, true)
			local buf = ffi.new("UIWareInfo[?]", n)
			n = C.GetMissingBuildResources(buf, n)
			for i = 0, n - 1 do
				table.insert(menu.missingResources, { ware = ffi.string(buf[i].ware), amount = buf[i].amount })
			end
		end
		if (not menu.isReadOnly) and (#menu.missingResources > 0) then
			menu.warnings[4] = ReadText(1001, 8018)
		end
	elseif menu.mode == "upgrade" then
		local considerCurrent = false
		if (menu.object ~= 0) and (menu.editingshoppinglist == nil) then
			considerCurrent = true
		end
		local numorders = considerCurrent and 1 or 0
		for i, entry in ipairs(menu.shoppinglist) do
			if entry.objectgroup then
				local groupentry = menu.shipgroups[entry.objectgroup]
				numorders = numorders + #groupentry.ships
			else
				numorders = numorders + 1
			end
		end
		local buildorders = ffi.new("UIBuildOrderList[?]", numorders)
		local i = 0
		for _, entry in ipairs(menu.shoppinglist) do
			if entry.objectgroup then
				local groupentry = menu.shipgroups[entry.objectgroup]
				for _, ship in ipairs(groupentry.ships) do
					buildorders[i].shipid = ship.ship
					buildorders[i].macroname = ""
					buildorders[i].loadout = Helper.callLoadoutFunction(entry.upgradeplan, nil, function (loadout, _) return loadout end, false)
					buildorders[i].amount = 1
					i = i + 1
				end
			else
				buildorders[i].shipid = entry.object
				buildorders[i].macroname = ""
				buildorders[i].loadout = Helper.callLoadoutFunction(entry.upgradeplan, nil, function (loadout, _) return loadout end, false)
				buildorders[i].amount = entry.amount
				i = i + 1
			end
		end
		if considerCurrent then
			local index = numorders - 1
			buildorders[index].shipid = menu.object
			buildorders[index].macroname = ""
			buildorders[index].loadout = Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return loadout end, false)
			buildorders[index].amount = 1
		end

		menu.missingResources = {}
		if menu.container then
			local n = C.GetNumMissingLoadoutResources2(menu.container, buildorders, numorders, true)
			local buf = ffi.new("UIWareInfo[?]", n)
			n = C.GetMissingLoadoutResources(buf, n)
			for i = 0, n - 1 do
				table.insert(menu.missingResources, { ware = ffi.string(buf[i].ware), amount = buf[i].amount })
			end
		end
		if (not menu.isReadOnly) and (#menu.missingResources > 0) then
			menu.warnings[4] = ReadText(1001, 8018)
		end
	end

	if (not menu.isReadOnly) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
		menu.addedCrewByPlayerBuildTasks = 0
		local constructions = {}
		-- current builds
		local n = C.GetNumBuildTasks(menu.container, 0, true, true)
		local buf = ffi.new("BuildTaskInfo[?]", n)
		n = C.GetBuildTasks(buf, n, menu.container, 0, true, true)
		menu.buildInProgress = n
		for i = 0, n - 1 do
			menu.addedCrewByPlayerBuildTasks = menu.addedCrewByPlayerBuildTasks + menu.getAddedPeopleFromBuildTask(menu.container, buf[i].id)
		end
		-- other builds
		n = C.GetNumBuildTasks(menu.container, 0, false, true)
		local buf = ffi.new("BuildTaskInfo[?]", n)
		n = C.GetBuildTasks(buf, n, menu.container, 0, false, true)
		for i = 0, n - 1 do
			local factionid = ffi.string(buf[i].factionid)
			table.insert(constructions, { id = buf[i].id, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, inprogress = false })
			if factionid == "player" then
				menu.addedCrewByPlayerBuildTasks = menu.addedCrewByPlayerBuildTasks + menu.getAddedPeopleFromBuildTask(menu.container, buf[i].id)
			end
		end
		menu.queuePosition = #constructions + 1
		for i, construction in ipairs(constructions) do
			if (not construction.inprogress) and (construction.factionid ~= "player") then
				menu.queuePosition = i
				break
			end
		end
		Helper.ffiClearNewHelper()
	end

	menu.shoppinglisttotal = 0
	menu.shoppinglistrefund = 0
	menu.timetotal = 0
	for i, entry in ipairs(menu.shoppinglist) do
		entry.color = menu.warnings[4] and Color["text_warning"] or Color["text_normal"]
		if i ~= menu.editingshoppinglist then
			local object = entry.object
			local groupamount = 1
			if entry.objectgroup then
				local groupentry = menu.shipgroups[entry.objectgroup]
				object = groupentry.ships[1].ship
				groupamount = #groupentry.ships
			end
			menu.timetotal = menu.timetotal + math.ceil(entry.amount * groupamount / C.GetNumSuitableBuildProcessors(menu.container, object, entry.macro)) * entry.duration
			menu.shoppinglisttotal = menu.shoppinglisttotal + entry.amount * (entry.price + entry.crewprice)
			if (entry.price + entry.crewprice) < 0 then
				menu.shoppinglistrefund = menu.shoppinglistrefund + entry.amount * (entry.price + entry.crewprice)
			end
			-- ammo error
			if entry.warnings[2] then
				entry.color = Color["text_criticalerror"]
				menu.criticalerrors[3] = ReadText(1001, 8016)
			end
			-- crew error
			if #entry.crew.unassigned > 0 then
				entry.color = Color["text_criticalerror"]
				menu.criticalerrors[4] = ReadText(1001, 8017)
			end
		end
		for _, upgradetype in ipairs(Helper.upgradetypes) do
			local slots = entry.upgradeplan[upgradetype.type]
			for slot, macro in pairs(slots) do
				-- allowempty error
				local allowempty
				if (upgradetype.supertype == "macro") and (upgradetype.supertype == "virtualmacro") then
					local data = macro
					if data.macro == "" then
						allowempty = upgradetype.allowempty and (not C.IsSlotMandatory(entry.object, 0, entry.macro, false, upgradetype.type, slot))
					end
				else
					if macro == "" then
						allowempty = upgradetype.allowempty
					end
				end
				if allowempty == false then
					if i ~= menu.editingshoppinglist then
						entry.color = Color["text_criticalerror"]
						menu.criticalerrors[2] = ReadText(1001, 8015)
					end
					break
				end
			end
		end
	end
	-- money error
	local playerMoney = GetPlayerMoney()
	if (not menu.isplayerowned) and (menu.shoppinglisttotal - menu.shoppinglistrefund > playerMoney) then
		menu.criticalerrors[1] = ReadText(1001, 8014)
		if menu.shoppinglistrefund < 0 then
			menu.criticalerrors[1] = menu.criticalerrors[1] .. " (" .. string.format(ReadText(1001, 8547), ConvertMoneyString(menu.shoppinglisttotal - menu.shoppinglistrefund, false, true, 0, true, false) .. " " .. ReadText(1001, 101)) .. ")"
		end
	end
	-- selling parts, not getting money immediately
	if menu.shoppinglistrefund < 0 then
		menu.warnings[6] = ReadText(1001, 8546)
	end

	Helper.ffiClearNewHelper()
	if (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
		-- edit warning
		if (menu.macro ~= "") or (menu.object ~= 0) then
			menu.warnings[5] = menu.objectgroup and ReadText(1001, 8567) or ReadText(1001, 8019)
		end
	end

	-- BUTTONS
	local buttontable = frame:addTable(2, { tabOrder = 6, width = menu.planData.width, height = Helper.scaleY(Helper.standardButtonHeight), x = menu.planData.offsetX, y = 0, reserveScrollBar = false, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
	local row

	local infoCount = 0
	local visibleHeight

	if not menu.isReadOnly then
		if menu.mode == "comparison" then
			local row = buttontable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(2):createText(ReadText(1001, 3701), menu.headerTextProperties)
		elseif menu.mode == "customgamestart" then
			local row = buttontable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(2):createText(ReadText(1001, 2302), menu.headerTextProperties)

			local row = buttontable:addRow(false, { fixed = true })
			row[1]:createText(ReadText(1001, 9923))
			row[2]:createText(ConvertMoneyString((menu.macro ~= "") and tonumber(Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.GetShipValue(menu.macro, loadout) end, nil, "UILoadout2")) or 0, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })

			if not menu.modeparam.creative then
				local row = buttontable:addRow(false, { fixed = true })
				row[1]:createText(ReadText(1001, 9929))

				local value = 0
				if menu.macro ~= "" then
					value = value + tonumber(C.GetCustomGameStartShipPeopleValue2(menu.modeparam.gamestartid, menu.macro, menu.customgamestartpeopledef, menu.customgamestartpeoplefillpercentage))

					if next(menu.customgamestartpilot) then
						local skills = {}
						for skill, value in pairs(menu.customgamestartpilot.skills or {}) do
							table.insert(skills, { id = skill, value = value })
						end
						local buf = ffi.new("CustomGameStartPersonEntry")
						buf.race = Helper.ffiNewString(menu.customgamestartpilot.race or "")
						buf.tags = Helper.ffiNewString(menu.customgamestartpilot.tags or "")
						buf.numskills = #skills
						buf.skills = Helper.ffiNewHelper("SkillInfo[?]", buf.numskills)
						for i, entry in ipairs(skills) do
							buf.skills[i - 1].id = Helper.ffiNewString(entry.id)
							buf.skills[i - 1].value = entry.value
						end
						value = value + tonumber(C.GetCustomGameStartShipPersonValue(menu.modeparam.gamestartid, buf))
					end
				end

				row[2]:createText(ConvertIntegerString(value, true, 0, true)  .. " " .. ColorText["customgamestart_budget_people"] .. "\27[gamestart_custom_people]", { halign = "right" })
			end
		else
			local row = buttontable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(2):createText(menu.container and string.format(ReadText(1001, 8531), (menu.isplayerowned and ColorText["text_player"] or "") .. ffi.string(C.GetComponentName(menu.container))) or ReadText(1001, 8012), menu.headerTextProperties)

			local row = buttontable:addRow(false, { fixed = true })
			row[1]:createText(ReadText(1001, 8522))
			row[2]:createText(menu.buildInProgress, { halign = "right" })
			infoCount = infoCount + 1

			local row = buttontable:addRow(false, { fixed = true })
			row[1]:createText(ReadText(1001, 8523))
			row[2]:createText(menu.queuePosition - 1, { halign = "right" })
			infoCount = infoCount + 1

			local row = buttontable:addRow(false, { fixed = true })
			row[1]:createText(ReadText(1001, 8509))
			row[2]:createText("#" .. menu.queuePosition .. " - " .. (menu.warnings[4] and "--:--" or ConvertTimeString(menu.timetotal, (menu.timetotal >= 3600) and "%h:%M:%S" or "%M:%S")), { halign = "right" })
			infoCount = infoCount + 1

			if not menu.isplayerowned then
				local row = buttontable:addRow(false, { fixed = true })
				row[1]:createText(ReadText(1001, 2927))
				row[2]:createText(ConvertMoneyString(menu.shoppinglisttotal, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
				infoCount = infoCount + 1

				local row = buttontable:addRow(false, { fixed = true })
				row[1]:createText(ReadText(1001, 2003))
				row[2]:createText(function () return ConvertMoneyString(GetPlayerMoney(), false, true, 0, true, false) .. " " .. ReadText(1001, 101) end, { halign = "right" })
				infoCount = infoCount + 1

				local row = buttontable:addRow(false, { fixed = true })
				row[1]:createText(ReadText(1001, 2004))
				row[2]:createText(function () return ConvertMoneyString(GetPlayerMoney() - menu.shoppinglisttotal, false, true, 0, true, false) .. " " .. ReadText(1001, 101) end, { halign = "right", color = function () return GetPlayerMoney() - menu.shoppinglisttotal < 0 and Color["text_negative"] or Color["text_normal"] end })
				infoCount = infoCount + 1
			end
		end
	end

	if menu.isReadOnly then
		row = buttontable:addRow(true, { fixed = true })
		row[2]:createButton({ }):setText(ReadText(1001, 8035), { halign = "center" })
		row[2].handlers.onClick = function () return menu.closeMenu("back") end
	else
		row = buttontable:addRow(true, { fixed = true, bgColor = Color["row_title_background"] })
		local button = row[1]:createButton({ active = ((#menu.shoppinglist > (menu.editingshoppinglist and 1 or 0)) or (menu.mode == "customgamestart") or ((menu.mode == "comparison") and (menu.macro ~= ""))) and (next(menu.criticalerrors) == nil), helpOverlayID = "shipconfig_confirm", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_confirm" }):setText(((menu.mode == "customgamestart") or (menu.mode == "comparison")) and ReadText(1001, 2821) or ReadText(1001, 8011), { halign = "center" })
		if (menu.object == 0) and (menu.macro == "") then
			button:setHotkey("INPUT_STATE_DETAILMONITOR_X", { displayIcon = true })
		end
		row[1].handlers.onClick = menu.buttonConfirm
		row[2]:createButton({  }):setText(((menu.mode == "customgamestart") or (menu.mode == "comparison")) and ReadText(1001, 64) or ReadText(1001, 8010), { halign = "center" })
		row[2].handlers.onClick = function () return menu.closeMenu("back") end
	end
	buttontable.properties.y = Helper.viewHeight - buttontable:getFullHeight() - menu.planData.offsetY

	-- STATUS
	local statustable, resourcetable
	if not menu.isReadOnly then
		if (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
			if #menu.missingResources > 0 then
				resourcetable = frame:addTable(2, { tabOrder = 8, width = menu.planData.width, x = menu.planData.offsetX, y = 0, reserveScrollBar = true, highlightMode = "off", skipTabChange = true, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })

				local row = resourcetable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
				row[1]:setColSpan(2):createText(ReadText(1001, 8046), menu.headerWarningTextProperties)
				-- disable blink effect
				row[1].properties.color = Color["text_warning"]

				local visibleHeight
				for i, entry in ipairs(menu.missingResources) do
					local row = resourcetable:addRow(true, {  })
					row[1]:createText(GetWareData(entry.ware, "name"), { color = Color["text_warning"] })
					row[2]:createText(ConvertIntegerString(entry.amount, true, 0, true), { halign = "right", color = Color["text_warning"] })
					if i == 5 then
						visibleHeight = resourcetable:getFullHeight()
					end
				end

				if visibleHeight then
					resourcetable.properties.maxVisibleHeight = visibleHeight
				else
					resourcetable.properties.maxVisibleHeight = resourcetable:getFullHeight()
				end
				resourcetable.properties.y = buttontable.properties.y - resourcetable:getVisibleHeight() - 2 * Helper.borderSize
			end
		end

		if next(menu.criticalerrors) or next(menu.errors) or next(menu.warnings) then
			if not menu.warningShown then
				PlaySound("ui_notification_pickup_fail")
			end
			menu.warningShown = menu.warningShown or getElapsedTime()
			local iconfactor = 1.6
			local iconsize = iconfactor * Helper.headerRow1Height

			statustable = frame:addTable(4, { tabOrder = 7, width = menu.planData.width, x = menu.planData.offsetX, y = 0, reserveScrollBar = false, highlightMode = "off", skipTabChange = true, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
			statustable:setColWidth(1, iconsize)
			statustable:setColWidth(4, iconsize)

			local row = statustable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setBackgroundColSpan(4):createText("\27[maptr_illegal]", menu.headerWarningTextProperties)
			row[1].properties.fontsize = iconfactor * row[1].properties.fontsize
			row[1].properties.y = math.floor((menu.titleData.height - Helper.scaleY(iconfactor * Helper.headerRow1Height)) / 2 + Helper.scaleY(Helper.headerRow1Offsety))
			row[2]:setColSpan(2):createText(ReadText(1001, 8342), menu.headerWarningTextProperties)
			row[4]:createText("\27[maptr_illegal]", menu.headerWarningTextProperties)
			row[4].properties.fontsize = iconfactor * row[4].properties.fontsize
			row[4].properties.y = math.floor((menu.titleData.height - Helper.scaleY(iconfactor * Helper.headerRow1Height)) / 2 + Helper.scaleY(Helper.headerRow1Offsety))

			for _, errorentry in Helper.orderedPairs(menu.criticalerrors) do
				row = statustable:addRow(true, {  })
				row[1]:setColSpan(4):createText(errorentry, { color = Color["text_criticalerror"], wordwrap = true })
				infoCount = infoCount + 1
				if infoCount == config.maxStatusRowCount then
					visibleHeight = statustable:getFullHeight()
				end
			end
			for _, errorentry in Helper.orderedPairs(menu.errors) do
				row = statustable:addRow(true, {  })
				row[1]:setColSpan(4):createText(errorentry, { color = Color["text_error"], wordwrap = true })
				infoCount = infoCount + 1
				if infoCount == config.maxStatusRowCount then
					visibleHeight = statustable:getFullHeight()
				end
			end
			for _, warningentry in Helper.orderedPairs(menu.warnings) do
				row = statustable:addRow(true, {  })
				row[1]:setColSpan(4):createText(warningentry, { color = Color["text_warning"], wordwrap = true })
				infoCount = infoCount + 1
				if infoCount == config.maxStatusRowCount then
					visibleHeight = statustable:getFullHeight()
				end
			end

			if visibleHeight then
				statustable.properties.maxVisibleHeight = visibleHeight
			else
				statustable.properties.maxVisibleHeight = statustable:getFullHeight()
			end
			if (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") and (#menu.missingResources > 0) then
				statustable.properties.y = resourcetable.properties.y - statustable:getVisibleHeight() - 2 * Helper.borderSize
			else
				statustable.properties.y = buttontable.properties.y - statustable:getVisibleHeight() - 2 * Helper.borderSize
			end
		else
			menu.warningShown = nil
		end
	end

	-- SHOPPINGLIST
	local maxVisibleHeight = buttontable.properties.y - menu.planData.offsetY
	if (not menu.isReadOnly) then
		if next(menu.criticalerrors) or next(menu.errors) or next(menu.warnings) then
			maxVisibleHeight = statustable.properties.y - menu.planData.offsetY
		elseif (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") and (#menu.missingResources > 0) then
			maxVisibleHeight = resourcetable.properties.y - menu.planData.offsetY
		end
	end
	local ftable = frame:addTable(5, { tabOrder = 3, width = menu.planData.width, maxVisibleHeight = maxVisibleHeight, x = menu.planData.offsetX, y = menu.planData.offsetY, reserveScrollBar = true, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
	local iconwidth = 5 * Helper.scaleY(Helper.standardTextHeight) + 4 * Helper.borderSize
	local dropdownWidth = 0.2 * menu.planData.width
	local valueWidth = (menu.planData.width - iconwidth - Helper.borderSize) / 2
	ftable:setColWidth(1, Helper.scaleY(Helper.standardTextHeight), false)
	ftable:setColWidth(2, iconwidth - Helper.scaleY(Helper.standardTextHeight) - Helper.borderSize, false)
	ftable:setColWidth(4, valueWidth - dropdownWidth - Helper.borderSize, false)
	ftable:setColWidth(5, dropdownWidth, false)

	if IsCheatVersion() and (menu.mode == "customgamestart") then
		local row = ftable:addRow(true, {  })
		row[1]:createCheckBox(menu.allownonplayerblueprints)
		row[1].handlers.onClick = function () menu.allownonplayerblueprints = not menu.allownonplayerblueprints; menu.onShowMenu(menu.onSaveState()) end
		row[2]:setColSpan(4):createText("Allow non-playerblueprint ships and equipment [Cheat only]") -- cheat only
	end

	-- currently editing
	local row = ftable:addRow(false, { bgColor = Color["row_title_background"] })
	row[1]:setColSpan(5):createText(menu.isReadOnly and ReadText(1001, 8045) or ReadText(1001, 8005), menu.headerTextProperties)

	if (menu.object ~= 0) or (menu.macro ~= "") then
		local removedEquipment = {}
		local currentEquipment = {}
		local newEquipment = {}
		local repairedEquipment = {}
		if menu.objectgroup then
			for i = 1, #menu.objectgroup.ships do
				local total, crewtotal, hasupgrades, hasrepairs, objecttotal, objectcrewtotal = menu.checkEquipment(removedEquipment, currentEquipment, newEquipment, repairedEquipment, menu.objectgroup.shipdata[i], menu.objectgroup.ships[i].ship)
				menu.objectgroup.states[i] = {
					hasupgrades = hasupgrades,
					hasrepairs = hasrepairs,
					price = objecttotal,
					crewprice = objectcrewtotal,
				}
				-- menu.checkEquipment() sums up the value of all changes
				menu.total = total
				menu.crewtotal = crewtotal
			end
		else
			menu.total, menu.crewtotal = menu.checkEquipment(removedEquipment, currentEquipment, newEquipment, repairedEquipment)
		end

		local buildorder = ffi.new("UIBuildOrderList")
		buildorder.shipid = menu.object
		buildorder.macroname = Helper.ffiNewString(menu.macro)
		buildorder.loadout = Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return loadout end)
		buildorder.amount = 1
		if (not menu.isReadOnly) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
			menu.duration = (not menu.errors[4]) and C.GetBuildDuration(menu.container, buildorder) or 0
		end

		local colspan = 2
		if menu.isReadOnly then
			colspan = 4
		end

		local row = ftable:addRow(true, {  })
		local name = ""
		if menu.object ~= 0 then
			name = ffi.string(C.GetComponentName(menu.object))
		else
			name = GetMacroData(menu.macro, "name")
		end

		if menu.objectgroup then
			row[1]:setColSpan(colspan + 1):createText(#menu.objectgroup.ships .. ReadText(1001, 42) .. " " .. GetMacroData(menu.objectgroup.macro, "name"))
		elseif (not menu.isReadOnly) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
			menu.customShipNameEditBox = row[1]:setColSpan(colspan + 1):createEditBox({ description = ReadText(1001, 8537), height = Helper.standardTextHeight }):setText((menu.customshipname ~= "") and menu.customshipname or name, { halign = "left" })
			row[1].handlers.onTextChanged = menu.editboxCustomShipName
			row[1].handlers.onEditBoxDeactivated = menu.editboxCustomShipNameDeactivated

			if not menu.isplayerowned then
				row[4]:setColSpan(2):createText(ConvertMoneyString(menu.total + menu.crewtotal, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
			end

			local row = ftable:addRow(true, {  })
			row[1]:createCheckBox(function () return menu.useloadoutname end, { active = menu.loadoutName ~= "" })
			row[1].handlers.onClick = menu.checkboxLoadoutName
			row[2]:setColSpan(4):createText(function () return ReadText(1001, 8536) .. ((menu.loadoutName ~= "") and (" - " .. menu.getCustomShipName()) or "") end, { color = function () return (menu.loadoutName ~= "") and Color["text_normal"] or Color["text_inactive"] end })

			local row = ftable:addRow(false, { bgColor = Color["row_background_unselectable"] })
			row[1]:setBackgroundColSpan(5)
			if (next(removedEquipment) == nil) and (next(newEquipment) == nil) and (#repairedEquipment > 0) then
				row[2]:setColSpan(2):createText(ReadText(1001, 8535))
			else
				row[2]:setColSpan(2):createText(ReadText(1001, 8508))
			end
			row[4]:setColSpan(2):createText((menu.warnings[4] and "--:--" or ConvertTimeString(menu.duration, (menu.duration >= 3600) and "%h:%M:%S" or "%M:%S")), { halign = "right" })
		else
			row[1]:setColSpan(colspan + 1):createText((menu.customshipname ~= "") and menu.customshipname or name)
		end

		if next(removedEquipment) or next(currentEquipment) or next(newEquipment) or (#repairedEquipment > 0) or (menu.object == 0) then
			-- chassis
			if menu.object == 0 then
				local ware = GetMacroData(menu.macro, "ware")
				if ware then
					local isextended = menu.isUpgradeExpanded(menu.currentIdx, ware, "chassis")
					local name = GetWareData(ware, "name")
					local resources = menu.getBuildResources(ware)

					row = ftable:addRow(true, {  })
					if (resources ~= nil) and (#resources > 0) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
						row[1]:createButton({ height = Helper.standardTextHeight }):setText(isextended and "-" or "+", { halign = "center" })
						row[1].handlers.onClick = function () return menu.expandUpgrade(menu.currentIdx, ware, "chassis", row.index) end
					end
					row[2]:setColSpan(colspan):createText(ReadText(1001, 8008), { color = Color["text_positive"] })
					if (not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
						row[4]:setColSpan(2):createText(ConvertMoneyString(tonumber(C.GetBuildWarePrice(menu.container, ware or "")), false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right", color = Color["text_positive"] })
					end
					if resources and (#resources > 0) and isextended then
						menu.displayUpgradeResources(ftable, resources, 1)
					end
				end
			end
			for _, entry in ipairs(config.leftBar) do
				if removedEquipment[entry.mode] or currentEquipment[entry.mode] or newEquipment[entry.mode] then
					row = ftable:addRow(true, {  })
					row[2]:setColSpan(4):createText(entry.name,{ font = Helper.standardFontBold, titleColor = Color["row_title"] })
				end
				-- removed
				if removedEquipment[entry.mode] then
					for _, entry in ipairs(removedEquipment[entry.mode]) do
						local isextended = menu.isUpgradeExpanded(menu.currentIdx, entry.ware, "removed")
						local name = GetWareData(entry.ware, "name")
						local resources = menu.getBuildResources(entry.ware)
						local mouseOverText = (name or "") .. "\n" .. string.format(ReadText(1026, 8010), ConvertMoneyString(-entry.price, false, true, 0, true, false) .. " " .. ReadText(1001, 101))
						row = ftable:addRow(true, {  })
						if (resources ~= nil) and (#resources > 0) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
							row[1]:createButton({ height = Helper.standardTextHeight }):setText(isextended and "-" or "+", { halign = "center" })
							row[1].handlers.onClick = function () return menu.expandUpgrade(menu.currentIdx, entry.ware, "removed", row.index) end
						end
						row[2]:setColSpan(colspan):createText(entry.amount .. ReadText(1001, 42) .. " " .. (name or ""), { color = Color["text_negative"], mouseOverText = mouseOverText })
						if entry.price and (entry.price > 0) and (not menu.isplayerowned) then
							row[4]:setColSpan(2):createText(ConvertMoneyString(-entry.amount * entry.price, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right", color = Color["text_negative"], mouseOverText = mouseOverText })
						end
						if resources and (#resources > 0) and isextended then
							menu.displayUpgradeResources(ftable, resources, entry.amount)
						end
					end
				end
				-- current
				if currentEquipment[entry.mode] then
					for _, entry in ipairs(currentEquipment[entry.mode]) do
						local isextended = menu.isUpgradeExpanded(menu.currentIdx, entry.ware, "current")
						local name = GetWareData(entry.ware, "name")
						local resources = menu.getBuildResources(entry.ware)
						row = ftable:addRow(true, {  })
						row[2]:setColSpan(colspan):createText(entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name"), { mouseOverText = name })
						if resources and (#resources > 0) and isextended then
							menu.displayUpgradeResources(ftable, resources, entry.amount)
						end
					end
				end
				-- new
				if newEquipment[entry.mode] then
					for _, entry in ipairs(newEquipment[entry.mode]) do
						local isextended = menu.isUpgradeExpanded(menu.currentIdx, entry.ware, "new")
						local name = GetWareData(entry.ware, "name")
						local resources = menu.getBuildResources(entry.ware)
						local mouseOverText = (name or "") .. "\n" .. string.format(ReadText(1026, 8010), ConvertMoneyString(entry.price, false, true, 0, true, false) .. " " .. ReadText(1001, 101))
						row = ftable:addRow(true, {  })
						if (resources ~= nil) and (#resources > 0) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
							row[1]:createButton({ height = Helper.standardTextHeight }):setText(isextended and "-" or "+", { halign = "center" })
							row[1].handlers.onClick = function () return menu.expandUpgrade(menu.currentIdx, entry.ware, "new", row.index) end
						end
						row[2]:setColSpan(colspan):createText(entry.amount .. ReadText(1001, 42) .. " " .. (name or ""), { color = Color["text_positive"], mouseOverText = mouseOverText })
						if entry.price and (entry.price > 0) and (not menu.isplayerowned) then
							row[4]:setColSpan(2):createText(ConvertMoneyString(entry.amount * entry.price, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right", color = Color["text_positive"], mouseOverText = mouseOverText })
						end
						if resources and (#resources > 0) and isextended then
							menu.displayUpgradeResources(ftable, resources, entry.amount)
						end
					end
				end
			end
			-- repaired
			if #repairedEquipment > 0 then
				row = ftable:addRow(true, {  })
				row[2]:setColSpan(4):createText(ReadText(1001, 3000),{ font = Helper.standardFontBold, titleColor = Color["row_title"] })
			end
			for _, entry in ipairs(repairedEquipment) do
				local repaircomponent = ConvertStringTo64Bit(entry.component)
				local isextended = menu.isUpgradeExpanded(menu.currentIdx, repaircomponent, "repair")
				local name = ffi.string(C.GetComponentName(repaircomponent)) .. " (" .. ffi.string(C.GetObjectIDCode(repaircomponent)) .. ")"

				local resources = {}
				local n = C.GetNumRepairResources2(menu.container, menu.object, repaircomponent)
				local buf = ffi.new("UIWareInfo[?]", n)
				n = C.GetRepairResources2(buf, n, menu.container, menu.object, repaircomponent)
				for i = 0, n - 1 do
					local amount = buf[i].amount
					if amount > 0 then
						table.insert(resources, { ware = ffi.string(buf[i].ware), amount = buf[i].amount })
					end
				end

				row = ftable:addRow(true, {  })
				if (#resources > 0) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
					row[1]:createButton({ height = Helper.standardTextHeight }):setText(isextended and "-" or "+", { halign = "center" })
					row[1].handlers.onClick = function () return menu.expandUpgrade(menu.currentIdx, repaircomponent, "repair", row.index) end
				end
				row[2]:setColSpan(colspan):createText(ReadText(1001, 4217) .. ReadText(1001, 120) .. " " .. name, { color = Color["text_positive"], mouseOverText = name })
				if not menu.isplayerowned then
					row[4]:setColSpan(2):createText(ConvertMoneyString(tonumber(C.GetRepairPrice(repaircomponent, menu.container) * menu.repairdiscounts.totalfactor), false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right", color = Color["text_positive"] })
				end
				if (#resources > 0) and isextended then
					menu.displayUpgradeResources(ftable, resources, 1)
				end
			end
		else
			row = ftable:addRow(true, {  })
			row[2]:setColSpan(4):createText("--- " .. ReadText(1001, 7936) .. " ---", { halign = "center" } )
		end

		if (not menu.isReadOnly) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
			local row = ftable:addRow(true, {  })
			local hasupgrades = (next(removedEquipment) ~= nil) or (next(newEquipment) ~= nil) or (#menu.crew.transferdetails > 0)
			local hasrepairs = (#repairedEquipment > 0)
			local mouseovertext = ""
			for i, error in Helper.orderedPairs(menu.errors) do
				if (i >= 1) and (i <= 3) then
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n"
					else
						mouseovertext = ColorText["text_error"]
					end
					mouseovertext = mouseovertext .. ((type(error) == "function") and error(nil, true) or error)
				end
			end
			local button = row[3]:setColSpan(3):createButton({ active = (not menu.errors[1]) and (not menu.errors[2]) and (not menu.errors[3]) and (hasupgrades or hasrepairs), mouseOverText = mouseovertext, helpOverlayID = "shipconfig_addtoshoppinglist", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_addtoshoppinglist" }):setText(ReadText(1001, 8006), { halign = "center" })
			if (menu.object ~= 0) or (menu.macro ~= "") then
				button:setHotkey("INPUT_STATE_DETAILMONITOR_X", { displayIcon = true })
			end
			row[3].handlers.onClick = menu.editingshoppinglist and function () menu.buttonConfirmPurchaseEdit(hasupgrades, hasrepairs) end or function () menu.buttonAddPurchase(hasupgrades, hasrepairs) end
		end
	else
		-- nothing selected
		local row = ftable:addRow(true, {  })
		row[2]:setColSpan(4):createText(ReadText(1001, 8007))

		local row = ftable:addRow(true, {  })
		row[3]:setColSpan(3):createButton({ active = false, helpOverlayID = "shipconfig_addtoshoppinglist", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_addtoshoppinglist" }):setText(ReadText(1001, 8006), { halign = "center" })
	end

	if (not menu.isReadOnly) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
		-- shoppinglist
		local row = ftable:addRow(false, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(5):createText(ReadText(1001, 8009), menu.headerTextProperties)

		if next(menu.shoppinglist) then
			for i, entry in ipairs(menu.shoppinglist) do
				if i ~= menu.editingshoppinglist then
					-- name & icon
					local name, icon
					if entry.objectgroup then
						local groupentry = menu.shipgroups[entry.objectgroup]
						name = #groupentry.ships .. ReadText(1001, 42) .. " " .. GetMacroData(groupentry.macro, "name")
						icon = C.IsIconValid("ship_" .. groupentry.macro) and ("ship_" .. groupentry.macro) or "ship_notfound"
					elseif entry.object ~= 0 then
						name = ffi.string(C.GetComponentName(entry.object)) .. " (" .. ffi.string(C.GetObjectIDCode(entry.object)) .. ")"
						local macro = GetComponentData(ConvertStringTo64Bit(tostring(entry.object)), "macro")
						icon = C.IsIconValid("ship_" .. macro) and ("ship_" .. macro) or "ship_notfound"
					else
						name = GetMacroData(entry.macro, "name")
						icon = C.IsIconValid("ship_" .. entry.macro) and ("ship_" .. entry.macro) or "ship_notfound"
					end
					local row = ftable:addRow(false, {  })
					row[1]:setColSpan(2):createIcon(icon, { width = iconwidth, height = iconwidth, scaling = false, affectRowHeight = false, y = (iconwidth - Helper.scaleY(Helper.standardTextHeight)) / 2 })
					row[3]:setColSpan(3):createText((entry.customshipname ~= "") and entry.customshipname or name, { color = entry.color, font = Helper.standardFontBold, mouseOverText = menu.getLoadoutSummary(entry.upgradeplan, entry.crew, menu.repairplan and menu.repairplan[tostring(entry.object)]) })
					-- amount
					local researchprecursors, limitedamount
					if menu.mode == "purchase" then
						local ware = GetMacroData(entry.macro, "ware")
						local islimited = GetWareData(ware, "islimited")
						researchprecursors = GetWareData(ware, "productionresearchprecursors")

						if islimited then
							local limitamount = Helper.getLimitedWareAmount(ware)
							local shoppinglistamount = 0
							for i, entry in ipairs(menu.shoppinglist) do
								if i ~= menu.editingshoppinglist then
									if entry.macro == macro then
										shoppinglistamount = shoppinglistamount + entry.amount
									end
								end
							end

							local used = (menu.usedLimitedMacros[macro] or 0) + shoppinglistamount
							limitedamount = limitamount - used
						end
					end
					if (menu.mode == "purchase") and ((not researchprecursors) or (#researchprecursors == 0)) then
						local row = ftable:addRow(true, {  })
						row[3]:setColSpan(2):createText(ReadText(1001, 1202) .. ReadText(1001, 120))
						local options = {}
						for i = 1, 20 do
							if (not limitedamount) or (i <= limitedamount) then
								local active = menu.isplayerowned or (playerMoney - menu.shoppinglisttotal - (i - entry.amount) * entry.price > 0)
								table.insert(options, { id = i, text = i, icon = "", displayremoveoption = false, active = active, mouseovertext = active and "" or (ColorText["text_error"] .. ReadText(1026, 8016)), helpOverlayID = "shipconfig_purchaseamount_" .. i, helpOverlayText = " ", helpOverlayHighlightOnly = true })
							end
						end
						for i = 30, 100, 10 do
							if (not limitedamount) or (i <= limitedamount) then
								local active = menu.isplayerowned or (playerMoney - menu.shoppinglisttotal - (i - entry.amount) * entry.price > 0)
								table.insert(options, { id = i, text = i, icon = "", displayremoveoption = false, active = active, mouseovertext = active and "" or (ColorText["text_error"] .. ReadText(1026, 8016)), helpOverlayID = "shipconfig_purchaseamount_" .. i, helpOverlayText = " ", helpOverlayHighlightOnly = true })
							end
						end
						row[5]:createDropDown(options, { startOption = entry.amount, helpOverlayID = "shipconfig_purchaseamount", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setTextProperties({ halign = "right", x = Helper.standardTextOffsetx })
						row[5].handlers.onDropDownConfirmed = function (_, amountstring) return menu.dropdownChangePurchaseAmount(i, amountstring) end
					else
						local row = ftable:addRow(false, {  })
						row[1]:setColSpan(5):createText(" ")
					end
					-- price
					if not menu.isplayerowned then
						local row = ftable:addRow(false, {  })
						row[3]:createText(ReadText(1001, 2927) .. ReadText(1001, 120))
						row[4]:setColSpan(2):createText(ConvertMoneyString(entry.amount * (entry.price and (entry.price + entry.crewprice) or 0), false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
					end
					-- Time estimate
					local row = ftable:addRow(false, {  })
					row[3]:createText(ReadText(1001, 8508) .. ReadText(1001, 120))
					local object = entry.object
					local groupamount = 1
					if entry.objectgroup then
						local groupentry = menu.shipgroups[entry.objectgroup]
						object = groupentry.ships[1].ship
						groupamount = #groupentry.ships
					end
					local duration = math.ceil(entry.amount * groupamount / C.GetNumSuitableBuildProcessors(menu.container, object, entry.macro)) * entry.duration
					row[4]:setColSpan(2):createText((menu.warnings[4] and "- -:- -" or ConvertTimeString(duration, (duration >= 3600) and "%h:%M:%S" or "%M:%S")), { halign = "right" })
					-- edit & remove
					local row = ftable:addRow(true, {  })
					row[3]:createButton({ height = Helper.standardTextHeight }):setText(ReadText(1001, 8529), { halign = "center" })
					row[3].handlers.onClick = function () return menu.buttonEditPurchase(i) end
					row[4]:setColSpan(2):createButton({ height = Helper.standardTextHeight }):setText(ReadText(1001, 8530), { halign = "center" })
					row[4].handlers.onClick = function () return menu.buttonRemovePurchase(i) end
					if i ~= #menu.shoppinglist then
						local row = ftable:addRow(false, { bgColor = Color["row_background_blue"] })
						row[1]:setColSpan(5):createText(" ", { height = 2, fontsize = 1 })
					end
				end
			end
		else
			local row = ftable:addRow(true, {  })
			row[2]:setColSpan(4):createText("--- " .. ReadText(1001, 34) .. " ---")
		end
	end

	menu.topRows.plan = nil
	menu.selectedRows.plan = nil
	menu.selectedCols.plan = nil
end

function menu.getBuildResources(ware)
	local resources = {}
	if menu.container and (not menu.errors[4]) then
		local n = C.GetNumBuildResources(menu.container, menu.object, menu.macro, ware)
		local buf = ffi.new("UIWareInfo[?]", n)
		n = C.GetBuildResources(buf, n, menu.container, menu.object, menu.macro, ware)
		for i = 0, n - 1 do
			local amount = buf[i].amount
			if amount > 0 then
				table.insert(resources, { ware = ffi.string(buf[i].ware), amount = buf[i].amount })
			end
		end
	end
	return resources
end

function menu.displayUpgradeResources(ftable, resources, upgradeamount)
	local colspan = 3
	if menu.isReadOnly then
		colspan = 6
	end

	for _, resource in ipairs(resources) do
		local ismissing = false
		for _, entry in ipairs(menu.missingResources) do
			if entry.ware == resource.ware then
				ismissing = true
				break
			end
		end
		local row = ftable:addRow(true, {  })
		local color = Color["text_normal"]
		if ismissing then
			color = Color["text_error"]
		end
		row[2]:setColSpan(colspan):createText("   " .. upgradeamount * resource.amount .. ReadText(1001, 42) .. " " .. GetWareData(resource.ware, "name"), { color = color, mouseOverText = mouseOverText })
	end
end

function menu.displayModifyPlan(frame)
	-- errors & warnings
	menu.criticalerrors = {}
	menu.errors = {}
	if menu.upgradetypeMode == "paintmods" then
		menu.warnings = {}

		local isdefaultpaintmod = false
		local buf = ffi.new("UIPaintMod")
		if (menu.object ~= 0) or (menu.macro ~= "") then
			if C.GetPlayerPaintThemeMod(menu.object, menu.macro, buf) then
				if menu.installedPaintMod and (ffi.string(buf.Ware) == menu.installedPaintMod.ware) then
					isdefaultpaintmod = true
				end
			end
		end
		if not isdefaultpaintmod then
			menu.warnings = {
				[1] = ReadText(1001, 8518)
			}
		end
	else
		menu.warnings = {}
		if not menu.isplayerowned then
			menu.warnings[1] = ReadText(1001, 8036)
		end
	end

	menu.shoppinglisttotal = 0

	-- BUTTONS
	local buttontable = frame:addTable(2, { tabOrder = 6, width = menu.planData.width, height = Helper.scaleY(Helper.standardButtonHeight), x = menu.planData.offsetX, y = Helper.viewHeight - Helper.scaleY(Helper.standardButtonHeight) - menu.planData.offsetY, reserveScrollBar = false, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })

	if not menu.isplayerowned then
		local row = buttontable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(2):createText(menu.container and string.format(ReadText(1001, 8531), (menu.isplayerowned and ColorText["text_player"] or "") .. ffi.string(C.GetComponentName(menu.container))) or ReadText(1001, 8012), menu.headerTextProperties)

		local row = buttontable:addRow(false, { fixed = true })
		row[1]:createText(ReadText(1001, 2003))
		row[2]:createText(function () return ConvertMoneyString(GetPlayerMoney(), false, true, 0, true, false) .. " " .. ReadText(1001, 101) end, { halign = "right" })
	end

	local row = buttontable:addRow(true, { fixed = true })
	row[2]:createButton({ }):setText(ReadText(1001, 8035), { halign = "center" })
	row[2].handlers.onClick = function () return menu.closeMenu("back") end

	buttontable.properties.y = Helper.viewHeight - buttontable:getFullHeight() - menu.planData.offsetY

	-- STATUS
	local infoCount = 0
	local visibleHeight

	local statustable
	if next(menu.criticalerrors) or next(menu.errors) or next(menu.warnings) then
		if not menu.warningShown then
			PlaySound("ui_notification_pickup_fail")
		end
		menu.warningShown = menu.warningShown or getElapsedTime()

		local iconfactor = 1.6
		local iconsize = iconfactor * Helper.headerRow1Height

		statustable = frame:addTable(4, { tabOrder = 7, width = menu.planData.width, x = menu.planData.offsetX, y = 0, reserveScrollBar = false, highlightMode = "off", skipTabChange = true, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
		statustable:setColWidth(1, iconsize)
		statustable:setColWidth(4, iconsize)

		local row = statustable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setBackgroundColSpan(4):createText("\27[maptr_illegal]", menu.headerWarningTextProperties)
		row[1].properties.fontsize = iconfactor * row[1].properties.fontsize
		row[1].properties.y = math.floor((menu.titleData.height - Helper.scaleY(iconfactor * Helper.headerRow1Height)) / 2 + Helper.scaleY(Helper.headerRow1Offsety))
		row[2]:setColSpan(2):createText(ReadText(1001, 8342), menu.headerWarningTextProperties)
		row[4]:createText("\27[maptr_illegal]", menu.headerWarningTextProperties)
		row[4].properties.fontsize = iconfactor * row[4].properties.fontsize
		row[4].properties.y = math.floor((menu.titleData.height - Helper.scaleY(iconfactor * Helper.headerRow1Height)) / 2 + Helper.scaleY(Helper.headerRow1Offsety))

		for _, errorentry in Helper.orderedPairs(menu.criticalerrors) do
			row = statustable:addRow(true, {  })
			row[1]:setColSpan(4):createText(errorentry, { color = Color["text_criticalerror"], wordwrap = true })
			infoCount = infoCount + 1
			if infoCount == 4 then
				visibleHeight = statustable:getFullHeight()
			end
		end
		for _, errorentry in Helper.orderedPairs(menu.errors) do
			row = statustable:addRow(true, {  })
			row[1]:setColSpan(4):createText(errorentry, { color = Color["text_error"], wordwrap = true })
			infoCount = infoCount + 1
			if infoCount == 4 then
				visibleHeight = statustable:getFullHeight()
			end
		end
		for _, warningentry in Helper.orderedPairs(menu.warnings) do
			row = statustable:addRow(true, {  })
			row[1]:setColSpan(4):createText(warningentry, { color = Color["text_warning"], wordwrap = true })
			infoCount = infoCount + 1
			if infoCount == 4 then
				visibleHeight = statustable:getFullHeight()
			end
		end

		if visibleHeight then
			statustable.properties.maxVisibleHeight = visibleHeight
		else
			statustable.properties.maxVisibleHeight = statustable:getFullHeight()
		end
		statustable.properties.y = buttontable.properties.y - statustable:getVisibleHeight() - 2 * Helper.borderSize
	else
		menu.warningShown = nil
	end

	-- PRICE LIST
	local maxVisibleHeight = buttontable.properties.y - menu.planData.offsetY
	if next(menu.criticalerrors) or next(menu.errors) or next(menu.warnings) then
		maxVisibleHeight = statustable.properties.y - menu.planData.offsetY
	end
	local ftable = frame:addTable(2, { tabOrder = 0, width = menu.planData.width, maxVisibleHeight = maxVisibleHeight, x = menu.planData.offsetX, y = menu.planData.offsetY, reserveScrollBar = true, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
	ftable:setColWidth(2, 0.3 * menu.planData.width)

	if not menu.isplayerowned then
		local row = ftable:addRow(false, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(2):createText(ReadText(1001, 8037), menu.headerTextProperties)

		if menu.upgradetypeMode == "paintmods" then
			local row = ftable:addRow(false, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8517))
		else
			for i = #Helper.modQualities, 1, -1 do
				local entry = Helper.modQualities[i]
				local row = ftable:addRow(false, {  })
				row[1]:createText(entry.name)
				row[2]:createText(ConvertMoneyString(entry.price * menu.moddingdiscounts.totalfactor, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
			end

			if #menu.moddingdiscounts > 0 then
				ftable:addEmptyRow()

				local row = ftable:addRow(nil, { bgColor = Color["row_title_background"] })
				row[1]:setColSpan(2):createText(ReadText(1001, 2819), menu.subHeaderTextProperties)

				for _, entry in ipairs(menu.moddingdiscounts) do
					local row = ftable:addRow(nil, {  })
					row[1]:createText(entry.name)
					row[2]:createText(entry.amount .. " %", { halign = "right" })
				end
			end
		end
	end

	-- SELECTEDSHIPS
	if menu.modeparam[1] then
		local row = ftable:addRow(false, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(2):createText(ReadText(1001, 8519), menu.headerTextProperties)
		for _, ship in pairs(menu.modeparam[2]) do
			local row = ftable:addRow(false, {  })
			row[1]:createText(ffi.string(C.GetComponentName(ship)) .. " (" .. ffi.string(C.GetObjectIDCode(ship)) .. ")", { color = Color["text_player"] })
			local paintmod = ffi.new("UIPaintMod")
			if C.GetInstalledPaintMod(ship, paintmod) then
				row[2]:createText(ffi.string(paintmod.Name), { color = Helper.modQualities[paintmod.Quality].color, halign = "right" })
			end
		end
	end

	menu.topRows.plan = nil
	menu.selectedRows.plan = nil
	menu.selectedCols.plan = nil
end

function menu.displayStats(frame)
	-- title
	local titletable = frame:addTable(5, { tabOrder = 19, width = menu.statsData.width, x = menu.statsData.offsetX, y = 0, reserveScrollBar = false, skipTabChange = true })
	local title = ReadText(1001, 8534)
	local titlewidth = C.GetTextWidth(title, Helper.headerRow1Font, Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize)) + 2 * (Helper.headerRow1Offsetx + Helper.borderSize)
	local checkboxwidth = Helper.scaleY(Helper.headerRow1Height) - Helper.borderSize
	titletable:setColWidth(2, checkboxwidth, false)
	titletable:setColWidth(3, titlewidth, false)
	titletable:setColWidth(4, checkboxwidth, false)

	local statskeyword = "showStats"
	if (menu.mode == "modify") and (menu.upgradetypeMode == "paintmods") then
		statskeyword = "showStatsPaintMod"
	end

	local row = titletable:addRow(true, { fixed = true, borderBelow = false })
	row[2]:setBackgroundColSpan(2):createCheckBox(__CORE_DETAILMONITOR_SHIPBUILD[statskeyword], { height = checkboxwidth, scaling = false })
	row[2].handlers.onClick = menu.buttonShowStats
	row[3]:createButton({ bgColor = Color["button_background_hidden"], height = Helper.headerRow1Height }):setText(title, { font = Helper.headerRow1Font, fontsize = Helper.headerRow1FontSize, x = Helper.headerRow1Offsetx, y = Helper.headerRow1Offsety, halign = "left" })
	row[3].handlers.onClick = menu.buttonShowStats
	if __CORE_DETAILMONITOR_SHIPBUILD[statskeyword] then
		local row = titletable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
		row[1]:setColSpan(5):createText(" ", { fontsize = 1, height = 2 })

		local loadoutstats, currentloadoutstats
		if menu.usemacro then
			local ffiloadoutstats = Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.GetLoadoutStatistics4(0, menu.macro, loadout) end)
			loadoutstats = Helper.convertLoadoutStats(ffiloadoutstats)

			currentloadoutstats = Helper.convertLoadoutStats(ffi.new("UILoadoutStatistics4", 0))
		elseif menu.mode == "upgrade" then
			local ffiloadoutstats = Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.GetLoadoutStatistics4(menu.object, "", loadout) end)
			loadoutstats = Helper.convertLoadoutStats(ffiloadoutstats)

			local fficurrentloadoutstats = C.GetCurrentLoadoutStatistics4(menu.object)
			currentloadoutstats = Helper.convertLoadoutStats(fficurrentloadoutstats)
		elseif menu.mode == "modify" then
			local fficurrentloadoutstats = C.GetCurrentLoadoutStatistics4(menu.object)
			loadoutstats = Helper.convertLoadoutStats(fficurrentloadoutstats)

			currentloadoutstats = menu.initialLoadoutStatistics
		end

		local ffimaxloadoutstats = C.GetMaxLoadoutStatistics4(menu.object, menu.macro)
		local maxloadoutstats = Helper.convertLoadoutStats(ffimaxloadoutstats)

		local ftable = frame:addTable(6, { tabOrder = 0, width = menu.statsData.width, x = menu.statsData.offsetX, y = titletable:getFullHeight() + Helper.borderSize, reserveScrollBar = false, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
		ftable:setColWidthPercent(2, 10)
		ftable:setColWidthPercent(5, 10)

		local iscapship = false
		-- If we have an object or a macro use its size information
		if menu.object ~= 0 then
			iscapship = C.IsComponentClass(menu.object, "ship_l") or C.IsComponentClass(menu.object, "ship_xl")
		elseif menu.macro ~= "" then
			iscapship = IsMacroClass(menu.macro, "ship_l") or IsMacroClass(menu.macro, "ship_xl")
		end

		local numRows = math.ceil(#config.stats / 2)
		for i = 1, numRows do
			local row = ftable:addRow(false, {  })
			local entry = config.stats[i]

			local id = entry.id
			if entry.capshipid ~= nil then
				id = iscapship and entry.capshipid or id
			end

			if id ~= "" then
				row[1]:createText(entry.name .. ((entry.unit ~= "") and (" (" .. entry.unit .. ")") or ""), { mouseOverText = entry.mouseovertext })
				local color = Color["text_normal"]
				if loadoutstats[id] > currentloadoutstats[id] then
					color = entry.inverted and (menu.usemacro and Color["text_normal"] or Color["text_negative"]) or Color["text_positive"]
				elseif loadoutstats[id] < currentloadoutstats[id] then
					color = entry.inverted and Color["text_positive"] or Color["text_negative"]
				end
				local value
				if entry.type == "UINT" then
					value = ConvertIntegerString(Helper.round(loadoutstats[id], 0), true, 0, true, false)
				elseif (entry.type == "float") or (entry.type == "double") then
					local int, frac = math.modf(Helper.round(loadoutstats[id], entry.accuracy))
					value = ConvertIntegerString(int, true, 0, true, false)
					if entry.accuracy > 0 then
						frac = Helper.round(math.abs(frac or 0) * (10 ^ entry.accuracy))
						value = value .. ReadText(1001, 105) .. string.format("%0".. (entry.accuracy) .."d", frac)
					end
				end
				row[2]:createText(value, { halign = "right", color = color })
					local posChangeColor, negChangeColor
					if entry.inverted then
						if menu.usemacro then
							posChangeColor = Color["statusbar_value_default"]
						else
							posChangeColor = Color["statusbar_diff_neg_default"]
						end
						negChangeColor = Color["statusbar_diff_pos_default"]
					end
				row[3]:createStatusBar({ current = loadoutstats[id], start = currentloadoutstats[id], max = maxloadoutstats[id], cellBGColor = Color["ship_stat_background"], posChangeColor = posChangeColor, negChangeColor = negChangeColor })
			else
				row[1]:createText("")
			end
			if i + numRows <= #config.stats then
				local entry2 = config.stats[i + numRows]

				local id2 = entry2.id
				if entry2.capshipid ~= nil then
					id2 = iscapship and entry2.capshipid or id2
				end

				if id2 ~= "" then
					row[4]:createText(entry2.name .. ((entry2.unit ~= "") and (" (" .. entry2.unit .. ")") or ""))
					local color = Color["text_normal"]
					if loadoutstats[id2] > currentloadoutstats[id2] then
						color = entry2.inverted and (menu.usemacro and Color["text_normal"] or Color["text_negative"]) or Color["text_positive"]
					elseif loadoutstats[id2] < currentloadoutstats[id2] then
						color = entry2.inverted and Color["text_positive"] or Color["text_negative"]
					end
					local value
					if entry2.type == "UINT" then
						value = ConvertIntegerString(Helper.round(loadoutstats[id2], 0), true, 0, true, false)
					elseif (entry2.type == "float") or (entry2.type == "double") then
						local int, frac = math.modf(Helper.round(loadoutstats[id2], entry2.accuracy))
						value = ConvertIntegerString(int, true, 0, true, false)
						if entry2.accuracy > 0 then
							frac = Helper.round(math.abs(frac or 0) * (10 ^ entry2.accuracy))
							value = value .. ReadText(1001, 105) .. string.format("%0".. (entry2.accuracy) .."d", frac)
						end
					end
					row[5]:createText(value, { halign = "right", color = color })
					local posChangeColor, negChangeColor
					if entry2.inverted then
						if menu.usemacro then
							posChangeColor = Color["statusbar_value_default"]
						else
							posChangeColor = Color["statusbar_diff_neg_default"]
						end
						negChangeColor = Color["statusbar_diff_pos_default"]
					end
					row[6]:createStatusBar({ current = loadoutstats[id2], start = currentloadoutstats[id2], max = maxloadoutstats[id2], cellBGColor = Color["ship_stat_background"], posChangeColor = posChangeColor, negChangeColor = negChangeColor })
				else
					row[4]:createText("")
				end
			end
		end

		titletable.properties.y = Helper.viewHeight - titletable:getFullHeight() - Helper.borderSize - ftable:getVisibleHeight() - menu.statsData.offsetY
		ftable.properties.y = titletable.properties.y + ftable.properties.y
	else
		titletable.properties.y = Helper.viewHeight - titletable:getFullHeight() - menu.statsData.offsetY
	end

	menu.statsTableOffsetY = titletable.properties.y
end

function menu.evaluateShipOptions()
	local classOptions = {}
	for _, class in ipairs(config.classorder) do
		if menu.usemacro then
			if menu.availableshipmacrosbyclass[class] then
				table.insert(classOptions, { id = class, text = ReadText(1001, 8026) .. " " .. Helper.getClassText(class), icon = "", displayremoveoption = false, helpOverlayID = "shipconfig_classoptions_" .. class, helpOverlayText = " ", helpOverlayHighlightOnly = true })
			end
		elseif (menu.mode == "upgrade") or (menu.mode == "modify") then
			if menu.selectableshipsbyclass[class] then
				table.insert(classOptions, { id = class, text = ReadText(1001, 8026) .. " " .. Helper.getClassText(class), icon = "", displayremoveoption = false, helpOverlayID = "shipconfig_classoptions_" .. class, helpOverlayText = " ", helpOverlayHighlightOnly = true })
			end
		end
	end

	local shipOptions = {}
	local curShipOption
	if menu.usemacro then
		if menu.class ~= "" then
			for _, macro in ipairs(menu.availableshipmacrosbyclass[menu.class]) do
				local haslicence, icon, overridecolor, mouseovertext, limitstring = menu.checkLicence(macro, true)
				local name, infolibrary, shiptypename, primarypurpose, shipicon = GetMacroData(macro, "name", "infolibrary", "shiptypename", "primarypurpose", "icon")

				-- start: alexandretk call-back
				if callbacks ["evaluateShipOptions_override_shiptypename"] then
					local shiptypename_override
					for _, callback in ipairs (callbacks ["evaluateShipOptions_override_shiptypename"]) do
						shiptypename_override = callback (shiptypename, shipicon, menu.class)
						if shiptypename_override then
							shiptypename = shiptypename_override
							break
						end
					end
				end
				-- end: alexandretk call-back

				table.insert(shipOptions, { id = macro, text = "\27[" .. shipicon .. "] " .. name .. " - " .. shiptypename .. limitstring, icon = icon or "", displayremoveoption = false, overridecolor = overridecolor, mouseovertext = mouseovertext, name = name .. " - " .. shiptypename, objectid = "", class = menu.class, purpose = primarypurpose, helpOverlayID = "shipconfig_shipoptions_" .. macro, helpOverlayText = " ", helpOverlayHighlightOnly = true })
				AddKnownItem(infolibrary, macro)
			end
		end
		curShipOption = menu.macro
		table.sort(shipOptions, Helper.sortShipsByClassAndPurpose)
	elseif menu.class ~= "" then
		if menu.mode == "upgrade" then
			for _, entry in ipairs(menu.selectableshipsbyclass[menu.class] or {}) do
				if entry.group then
					local groupentry = menu.shipgroups[entry.group]
					local name = GetMacroData(groupentry.macro, "name")

					local icon = ""
					for i, shoppinglistentry in ipairs(menu.shoppinglist) do
						if shoppinglistentry.objectgroup == entry.group then
							icon = "menu_shoppingcart"
							break
						end
					end

					local mouseovertext = ""
					for i, ship in ipairs(groupentry.ships) do
						if i ~= 1 then
							mouseovertext = mouseovertext .. "\n"
						end
						mouseovertext = mouseovertext .. "\27[" .. ship.icon .. "] " .. ship.name .. " (" .. ship.objectid .. ")"
					end
					table.insert(shipOptions, { id = groupentry.macro, text = "\27[" .. groupentry.ships[1].icon .. "] " .. #groupentry.ships .. ReadText(1001, 42) .. " " .. name, icon = icon, displayremoveoption = false, mouseovertext = mouseovertext })
				elseif entry.grouped ~= nil then
					local icon = ""
					local active = true
					local mouseovertext = ""
					for i, shoppinglistentry in ipairs(menu.shoppinglist) do
						if shoppinglistentry.objectgroup == entry.groupidx then
							icon = "menu_shoppingcart"
							if entry.grouped then
								active = false
								mouseovertext = ReadText(1026, 8025)
							end
							break
						elseif shoppinglistentry.object == entry.ship.ship then
							icon = "menu_shoppingcart"
							break
						end
					end

					table.insert(shipOptions, { id = tostring(entry.ship.ship), text = (entry.grouped and "       " or "") .. "\27[" .. entry.ship.icon .. "] " .. entry.ship.name .. " (" .. entry.ship.objectid .. ")", icon = icon, displayremoveoption = false, active = active, mouseovertext = mouseovertext })
				else
					local icon = ""
					for i, shoppinglistentry in ipairs(menu.shoppinglist) do
						if shoppinglistentry.object == entry.ship then
							icon = "menu_shoppingcart"
							break
						end
					end

					table.insert(shipOptions, { id = tostring(entry.ship), text = "\27[" .. entry.icon .. "] " .. entry.name .. " (" .. entry.objectid .. ")", icon = icon, displayremoveoption = false })
				end
			end
			if menu.objectgroup then
				curShipOption = menu.objectgroup.macro
			else
				curShipOption = tostring(menu.object)
			end
		elseif menu.mode == "modify" then
			for _, ship in ipairs(menu.selectableshipsbyclass[menu.class] or {}) do
				local name = ffi.string(C.GetComponentName(ship))
				local idcode = ffi.string(C.GetObjectIDCode(ship))
				local primarypurpose, icon = GetComponentData(ConvertStringTo64Bit(tostring(ship)), "primarypurpose", "icon")

				table.insert(shipOptions, { id = tostring(ship), text = "\27[" .. icon .. "] " .. name .. " (" .. idcode .. ")", icon = "", displayremoveoption = false, name = name, objectid = idcode, class = menu.class, purpose = primarypurpose })
			end
			table.sort(shipOptions, Helper.sortShipsByClassAndPurpose)
			curShipOption = tostring(menu.object)
		end
	end

	local loadoutOptions = {}
	if next(menu.loadouts) then
		for _, loadout in ipairs(menu.loadouts) do
			table.insert(loadoutOptions, { id = loadout.id, text = loadout.name, icon = "", displayremoveoption = loadout.deleteable, active = loadout.active, mouseovertext = loadout.mouseovertext })
		end
	end

	return classOptions, shipOptions, curShipOption, loadoutOptions
end

function menu.createTitleBar(frame)
	local classOptions, shipOptions, curShipOption, loadoutOptions = menu.evaluateShipOptions()

	if menu.mode == "modify" then
		local ftable = frame:addTable(5, { tabOrder = 4, height = 0, x = menu.titleData.offsetX, y = menu.titleData.offsetY, scaling = false, reserveScrollBar = false })
		ftable:setColWidth(1, menu.titleData.dropdownWidth)
		ftable:setColWidth(2, menu.titleData.dropdownWidth)
		ftable:setColWidth(3, menu.titleData.height)
		ftable:setColWidth(4, menu.titleData.height)
		ftable:setColWidth(5, menu.titleData.height)

		local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
		-- class
		row[1]:createDropDown(classOptions, { startOption = menu.class, active = (not menu.isReadOnly) and (#classOptions > 0), optionWidth = menu.titleData.dropdownWidth, helpOverlayID = "shipconfig_classoptions", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_classoptions" }):setTextProperties(config.dropDownTextProperties)
		row[1].handlers.onDropDownConfirmed = menu.dropdownShipClass
		-- ships
		local dropDownIconProperties = {
			width = menu.titleData.height / 2,
			height = menu.titleData.height / 2,
			x = menu.titleData.dropdownWidth - 1.5 * menu.titleData.height,
			y = 0,
			scaling = false,
		}

		row[2]:createDropDown(shipOptions, { startOption = curShipOption, active = (not menu.isReadOnly) and (menu.class ~= ""), optionWidth = menu.titleData.dropdownWidth, optionHeight = (menu.statsTableOffsetY or Helper.viewHeight) - menu.titleData.offsetY - Helper.frameBorder, helpOverlayID = "shipconfig_shipoptions", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_shipoptions" }):setTextProperties(config.dropDownTextProperties):setIconProperties(dropDownIconProperties)
		row[2].properties.text.halign = "left"
		row[2].handlers.onDropDownConfirmed = menu.dropdownShip
		-- reset camera
		row[3]:createButton({ active = true, height = menu.titleData.height, mouseOverText = ffi.string(C.ConvertInputString(ReadText(1026, 7911), ReadText(1026, 7902))) }):setIcon("menu_reset_view"):setHotkey("INPUT_STATE_DETAILMONITOR_RESET_VIEW", { displayIcon = false })
		row[3].handlers.onClick = function () return C.ResetMapPlayerRotation(menu.holomap) end
		-- undo
		row[4]:createButton({ active = function () return (#menu.undoStack > 1) and (menu.undoIndex < #menu.undoStack) end, height = menu.titleData.height, mouseOverText = ReadText(1026, 7903) .. Helper.formatOptionalShortcut(" (%s)", "action", 278) }):setIcon("menu_undo")
		row[4].handlers.onClick = function () return menu.undoHelper(true) end
		-- redo
		row[5]:createButton({ active = function () return (#menu.undoStack > 1) and (menu.undoIndex > 1) end, height = menu.titleData.height, mouseOverText = ReadText(1026, 7904) .. Helper.formatOptionalShortcut(" (%s)", "action", 279) }):setIcon("menu_redo")
		row[5].handlers.onClick = function () return menu.undoHelper(false) end
	else
		local ftable = frame:addTable(7, { tabOrder = 4, height = 0, x = menu.titleData.offsetX, y = menu.titleData.offsetY, scaling = false, reserveScrollBar = false })
		if ((menu.macro == "") and (menu.object == 0)) then
			ftable.properties.defaultInteractiveObject = true
		end
		ftable:setColWidth(1, config.dropdownRatios.class * menu.titleData.dropdownWidth)
		ftable:setColWidth(2, config.dropdownRatios.ship * menu.titleData.dropdownWidth)
		ftable:setColWidth(3, menu.titleData.dropdownWidth)
		ftable:setColWidth(4, menu.titleData.height)
		ftable:setColWidth(5, menu.titleData.height)
		ftable:setColWidth(6, menu.titleData.height)
		ftable:setColWidth(7, menu.titleData.height)

		local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
		-- class
		row[1]:createDropDown(classOptions, { startOption = menu.class, active = (not menu.isReadOnly) and (#classOptions > 0), helpOverlayID = "shipconfig_classoptions", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setTextProperties(config.dropDownTextProperties)
		row[1].handlers.onDropDownConfirmed = menu.dropdownShipClass
		-- ships
		local dropDownIconProperties = {
			width = menu.titleData.height / 2,
			height = menu.titleData.height / 2,
			x = config.dropdownRatios.ship * menu.titleData.dropdownWidth - 1.5 * menu.titleData.height,
			y = 0,
			scaling = false,
		}

		local dropdown = row[2]:createDropDown(shipOptions, { startOption = curShipOption, active = (not menu.isReadOnly) and (menu.class ~= ""), optionHeight = (menu.statsTableOffsetY or Helper.viewHeight) - menu.titleData.offsetY - Helper.frameBorder, helpOverlayID = "shipconfig_shipoptions", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setTextProperties(config.dropDownTextProperties):setIconProperties(dropDownIconProperties)
		row[2].properties.text.halign = "left"
		row[2].handlers.onDropDownConfirmed = menu.dropdownShip
		local active = true
		if (menu.mode == "purchase") and (menu.macro ~= "") and (not menu.validLicence) then
			active = false
			local haslicence, icon, overridecolor, mouseovertext = menu.checkLicence(menu.macro, true)
			dropdown.properties.text.color = overridecolor
			dropdown.properties.icon.color = overridecolor
		end
		if (menu.mode == "upgrade") and (not menu.isReadOnly) and (menu.object ~= 0) then
			if not C.CanContainerEquipShip(menu.container, menu.object) then
				active = false
			end
		end

		-- loadout
		row[3]:createDropDown(loadoutOptions, { textOverride = ReadText(1001, 7905), active = (not menu.isReadOnly) and active and ((menu.object ~= 0) or (menu.macro ~= "")) and (next(menu.loadouts) ~= nil), optionWidth = menu.titleData.dropdownWidth + menu.titleData.height + Helper.borderSize, optionHeight = (menu.statsTableOffsetY or Helper.viewHeight) - menu.titleData.offsetY - Helper.frameBorder, mouseOverText = (menu.mode == "customgamestart") and (ColorText["text_warning"] .. ReadText(1026, 8022)) or "" }):setTextProperties(config.dropDownTextProperties)
		row[3].handlers.onDropDownConfirmed = menu.dropdownLoadout
		row[3].handlers.onDropDownRemoved = menu.dropdownLoadoutRemoved
		-- save

		-- mycu start: callback
		if callbacks ["displaySlots_on_before_create_store_loadout_button"] then
			for _, callback in ipairs (callbacks ["displaySlots_on_before_create_store_loadout_button"]) do
				callback ()
			end
		end
		-- mycu end: callback

		row[4]:createButton({ active = (not menu.isReadOnly) and active and ((menu.object ~= 0) or (menu.macro ~= "")), height = menu.titleData.height, mouseOverText = ReadText(1026, 7905), helpOverlayID = "shipconfig_saveloadout", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_saveloadout" }):setIcon("menu_save")
		row[4].handlers.onClick = menu.buttonTitleSave

		-- mycu start: callback
		if callbacks ["displaySlots_on_after_create_store_loadout_button"] then
			for _, callback in ipairs (callbacks ["displaySlots_on_after_create_store_loadout_button"]) do
				callback ()
			end
		end
		-- mycu end: callback

		-- reset camera
		row[5]:createButton({ active = true, height = menu.titleData.height, mouseOverText = ffi.string(C.ConvertInputString(ReadText(1026, 7911), ReadText(1026, 7902))) }):setIcon("menu_reset_view"):setHotkey("INPUT_STATE_DETAILMONITOR_RESET_VIEW", { displayIcon = false })
		row[5].handlers.onClick = function () return C.ResetMapPlayerRotation(menu.holomap) end
		-- undo
		row[6]:createButton({ active = function () return (#menu.undoStack > 1) and (menu.undoIndex < #menu.undoStack) end, height = menu.titleData.height, mouseOverText = ReadText(1026, 7903) .. Helper.formatOptionalShortcut(" (%s)", "action", 278) }):setIcon("menu_undo")
		row[6].handlers.onClick = function () return menu.undoHelper(true) end
		-- redo
		row[7]:createButton({ active = function () return (#menu.undoStack > 1) and (menu.undoIndex > 1) end, height = menu.titleData.height, mouseOverText = ReadText(1026, 7904) .. Helper.formatOptionalShortcut(" (%s)", "action", 279) }):setIcon("menu_redo")
		row[7].handlers.onClick = function () return menu.undoHelper(false) end
	end

	menu.topRows.ship = nil
	menu.selectedRows.ship = nil
	menu.selectedCols.ship = nil
end

function menu.displayMenu(firsttime)
	-- Remove possible button scripts from previous view
	Helper.removeAllWidgetScripts(menu, config.infoLayer)
	Helper.currentTableRow = {}

	menu.infoFrame = Helper.createFrameHandle(menu, {
		layer = config.infoLayer,
		standardButtons = {},
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	})

	-- title bar
	menu.createTitleBar(menu.infoFrame)

	menu.displayLeftBar(menu.infoFrame)

	if (menu.usemacro and (menu.macro ~= "")) or ((menu.mode == "upgrade") and (menu.object ~= 0)) then
		menu.displaySlots(menu.infoFrame, firsttime)
	elseif menu.mode == "modify" then
		if menu.upgradetypeMode == "paintmods" then
			menu.displayModifyPaintSlots(menu.infoFrame)
		else
			menu.displayModifySlots(menu.infoFrame)
		end
	else
		menu.displayEmptySlots(menu.infoFrame)
	end

	if menu.usemacro or (menu.mode == "upgrade") then
		menu.displayPlan(menu.infoFrame)
	elseif menu.mode == "modify" then
		menu.displayModifyPlan(menu.infoFrame)
	end

	menu.statsTableOffsetY = nil
	if (menu.usemacro and (menu.macro ~= "")) or ((menu.mode == "upgrade") or (menu.mode == "modify")) and (menu.object ~= 0) then
		menu.displayStats(menu.infoFrame)
	end

	menu.infoFrame:display()
end

function menu.displayContextFrame(mode, width, x, y)
	PlaySound("ui_positive_click")
	menu.contextMode = { mode = mode, width = width, x = x, y = y }
	if mode == "saveLoadout" then
		menu.createLoadoutSaveContext()
	elseif mode == "equipment" then
		menu.createEquipmentContext()
	elseif mode == "userquestion" then
		menu.createUserQuestionContext()
	elseif mode == "equipmentfilter" then
		menu.createEquipmentFilterContext()
	elseif mode == "slot" then
		menu.createSlotContext()
	end
end

function menu.createSlotContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(1, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	local upgradetype = Helper.findUpgradeType(menu.contextData.upgradetype)
	local upgradetype2 = Helper.findUpgradeTypeByGroupType(upgradetype.type)
	local slotdata
	if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
		slotdata = menu.groups[menu.currentSlot][upgradetype2.grouptype]
	else
		slotdata = menu.slots[upgradetype.type][menu.contextData.slot]
	end
	local plandata
	if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
		plandata = menu.upgradeplan[upgradetype2.type][menu.currentSlot].macro
	else
		plandata = menu.upgradeplan[upgradetype.type][menu.contextData.slot].macro
	end
	local prefix = ""
	if upgradetype.mergeslots then
		prefix = #menu.slots[upgradetype.type] .. ReadText(1001, 42) .. " "
	end

	local hasmod, modicon = false, ""
	if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
		hasmod, modicon = menu.checkMod(upgradetype2.grouptype, slotdata.currentcomponent, true)
	else
		hasmod, modicon = menu.checkMod(upgradetype.type, slotdata.component)
	end

	local canequip = not menu.isReadOnly
	if (menu.mode == "upgrade") and (not menu.isReadOnly) and (menu.object ~= 0) then
		canequip = C.CanContainerEquipShip(menu.container, menu.object)
	end

	if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
		local name = upgradetype2.text.default
		if plandata == "" then
			if slotdata.slotsize ~= "" then
				name = upgradetype2.text[slotdata.slotsize]
			end
		else
			name = GetMacroData(plandata, "name")
		end

		if not upgradetype2.mergeslots then
			local minselect = (plandata == "") and 0 or 1
			local maxselect = (plandata == "") and 0 or slotdata.total

			local scale = {
				min       = 0,
				minselect = minselect,
				max       = slotdata.total,
				maxselect = maxselect,
				step      = 1,
				suffix    = "",
				exceedmax = false,
				readonly = canequip and (hasmod or menu.isReadOnly),
			}

			-- handle already installed equipment
			local haslicence = menu.checkLicence(plandata)
			if (plandata == menu.groups[menu.currentSlot][upgradetype2.grouptype].currentmacro) and (not haslicence) then
				scale.maxselect = math.min(scale.maxselect, slotdata.count)
			end
			local j = menu.findUpgradeMacro(upgradetype2.grouptype, plandata)
			if j then
				local upgradeware = menu.upgradewares[upgradetype2.grouptype][j]
				if not upgradeware.isFromShipyard then
					scale.maxselect = menu.objectgroup and 0 or math.min(scale.maxselect, slotdata.count)
					if menu.objectgroup then
						scale.minselect = 0
					end
				end
			end
			scale.start = math.max(scale.minselect, math.min(scale.maxselect, menu.upgradeplan[upgradetype2.type][menu.currentSlot].count))

			local mouseovertext = ""
			if hasmod then
				mouseovertext = ColorText["text_error"] .. ReadText(1026, 8009) .. "\27X"
			end

			local row = ftable:addRow(true)
			row[1]:createSliderCell({ height = Helper.headerRow1Height, valueColor = Color["slider_value"], min = scale.min, minSelect = scale.minselect, max = scale.max, maxSelect = scale.maxselect, start = scale.start, step = scale.step, suffix = scale.suffix, exceedMaxValue = scale.exceedmax, readOnly = scale.readonly, mouseOverText = mouseovertext }):setText(name, { font = Helper.headerRow1Font, fontsize = Helper.headerRow1FontSize })
			row[1].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellSelectGroupAmount(upgradetype2.type, menu.currentSlot, nil, row.index, ...) end
		else
			local row = ftable:addRow(nil)
			row[1]:createText(name)
		end
	end

	for k, macro in ipairs(slotdata.possiblemacros) do
		local name = prefix .. GetMacroData(macro, "name")

		local haslicence, icon, overridecolor, mouseovertext = menu.checkLicence(macro, true)

		-- handle already installed equipment
		if (macro == slotdata.currentmacro) and (not haslicence) then
			haslicence = true
			mouseovertext = mouseovertext .. "\n" .. ColorText["text_positive"] .. ReadText(1026, 8004)
		end

		if hasmod then
			mouseovertext = ColorText["text_error"] .. ReadText(1026, 8009) .. "\27X\n" .. mouseovertext
		end

		mouseovertext = name .. "\n" .. mouseovertext

		local bgcolor = Color["button_background_default"]
		if not haslicence then
			bgcolor = Color["button_background_inactive"]
		end

		local color = Color["text_normal"]
		if (macro == slotdata.currentmacro) and (macro ~= plandata) then
			color = Color["text_negative"]
		elseif (macro == plandata) then
			color = Color["text_positive"]
			if hasmod then
				name = name .. " " .. modicon
			end
		end

		local hasstock = false
		if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
			local j = menu.findUpgradeMacro(upgradetype2.grouptype, macro)
			if j then
				local upgradeware = menu.upgradewares[upgradetype2.grouptype][j]
					hasstock = upgradeware.isFromShipyard or ((slotdata.currentmacro == macro) and (slotdata.hasstock ~= false))
			end
		else
			local j = menu.findUpgradeMacro(upgradetype.type, macro)
			if j then
				local upgradeware = menu.upgradewares[upgradetype.type][j]
					hasstock = upgradeware.isFromShipyard or ((slotdata.currentmacro == macro) and (slotdata.hasstock ~= false))
			end
		end

		local row = ftable:addRow(true)
		row[1]:createButton({ active = canequip and ((macro == plandata) or (not hasmod)) and hasstock, bgColor = bgcolor, mouseOverText = mouseovertext, height = Helper.standardTextHeight }):setText(name, { color = color })
		if icon and (icon ~= "") then
			local iconsize = Helper.scaleX(Helper.standardTextHeight)
			row[1]:setIcon(icon, { color = overridecolor, width = iconsize, height = iconsize, x = menu.contextMode.width - iconsize, scaling = false })
		end
		if haslicence then
			if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
				row[1].handlers.onClick = function () return menu.buttonSelectGroupUpgrade(upgradetype2.type, menu.currentSlot, macro, nil, nil, row.index) end
			else
				row[1].handlers.onClick = function () return menu.buttonSelectUpgradeMacro(upgradetype.type, menu.contextData.slot, macro, nil, nil, row.index) end
			end
		end
	end

	local allowempty = upgradetype.allowempty
	if upgradetype.supertype == "macro" then
		allowempty = allowempty and (not C.IsSlotMandatory(menu.object, 0, menu.macro, false, upgradetype.type,  menu.contextData.slot))
	end
	if allowempty then
		local name = ReadText(1001, 7906)

		local mouseovertext = ""
		if hasmod then
			mouseovertext = ColorText["text_error"] .. ReadText(1026, 8009) .. "\27X"
		end

		local color = Color["text_normal"]
		if ("" == slotdata.currentmacro) and ("" ~= plandata) then
			color = Color["text_negative"]
		elseif ("" == plandata) then
			color = Color["text_positive"]
		end

		local row = ftable:addRow(true)
		row[1]:createButton({ active = canequip and (not hasmod), bgColor = bgcolor, mouseOverText = mouseovertext, height = Helper.standardTextHeight, helpOverlayID = "upgrade_empty", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(name, { color = color })
		if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
			row[1].handlers.onClick = function () return menu.buttonSelectGroupUpgrade(upgradetype2.type, menu.currentSlot, "", nil, nil, row.index) end
		else
			row[1].handlers.onClick = function () return menu.buttonSelectUpgradeMacro(upgradetype.type, menu.contextData.slot, "", nil, nil, row.index) end
		end
	end

	ftable:setTopRow(menu.topRows.context)
	ftable:setSelectedRow(menu.selectedRows.context)
	menu.topRows.context = nil
	menu.selectedRows.context = nil

	menu.contextFrame:display()
end

function menu.createUserQuestionContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = {},
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(5, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	if menu.contextData.mode == "removevolatile" then
		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(ReadText(1001, 8561), Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(ReadText(1001, 8562), { wordwrap = true })
	elseif menu.contextData.mode == "replacesingleshoppinglistentry" then
		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(ReadText(1001, 8574), Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(ReadText(1001, 8575), { wordwrap = true })
	end

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(5):createText("")

	local row = ftable:addRow(true, { fixed = true })
	row[2]:createButton():setText(ReadText(1001, 2617), { halign = "center" })
	if menu.contextData.mode == "removevolatile" then
		row[2].handlers.onClick = function () return menu.buttonSelectUpgradeMacro(menu.contextData.type, menu.contextData.slot, menu.contextData.macro, menu.contextData.row, menu.contextData.col, false, true) end
	elseif menu.contextData.mode == "replacesingleshoppinglistentry" then
		row[2].handlers.onClick = function () return menu.buttonDiscardShoppingListAndEditGroup(menu.contextData.group, menu.contextData.shipid) end
	end
	row[4]:createButton():setText(ReadText(1001, 2618), { halign = "center" })
	row[4].handlers.onClick = menu.closeContextMenu
	ftable:setSelectedCol(4)

	menu.contextFrame:display()
end

function menu.createEquipmentContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(1, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	local row = ftable:addRow(false, { fixed = true })
	row[1]:createText(menu.selectedUpgrade.name, menu.subHeaderTextProperties)

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = true, bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 2400), { color = Color["text_normal"] })
	row[1].handlers.onClick = function () return menu.buttonContextEncyclopedia(menu.selectedUpgrade) end

	menu.contextFrame:display()
end

function menu.checkLoadoutNameID()
	local canoverwrite = false
	local cansaveasnew = false
	if menu.loadout then
		local found = false
		for _, loadout in ipairs(menu.loadouts) do
			if loadout.id == menu.loadout then
				menu.loadoutName = loadout.name
				menu.setCustomShipName()
				break
			end
		end
		if not found then
			menu.loadout = nil
		end
	end
	if (not menu.loadout) and menu.loadoutName and (menu.loadoutName ~= "") then
		cansaveasnew = true
		for _, loadout in ipairs(menu.loadouts) do
			if (not loadout.preset) and (not loadout.mission) and (loadout.name == menu.loadoutName) then
				canoverwrite = true
				cansaveasnew = false
				menu.loadout = loadout.id
				break
			end
		end
	end

	return canoverwrite, cansaveasnew
end

function menu.createLoadoutSaveContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})

	local ftable = menu.contextFrame:addTable(2, { tabOrder = 5, scaling = false, borderEnabled = false, reserveScrollBar = false })
	ftable:setDefaultCellProperties("button", { height = Helper.standardTextHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = Helper.standardFontSize, halign = "center" })

	local canoverwrite, cansaveasnew = menu.checkLoadoutNameID()

	local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
	menu.contextMode.nameEditBox = row[1]:setColSpan(2):createEditBox({ height = menu.titleData.height, description = ReadText(1001, 9413) }):setText(menu.loadoutName or "", { halign = "center", font = Helper.headerRow1Font, fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize) })
	row[1].handlers.onTextChanged = menu.editboxLoadoutNameUpdateText

	if menu.mode == "customgamestart" then
		local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
		row[1]:setColSpan(2):createText(ReadText(1026, 8021), { color = Color["text_warning"], wordwrap = true, scaling = true })
	end

	local row = ftable:addRow(true, { scaling = true, fixed = true, bgColor = Color["row_background_blue"] })
	row[1]:createButton({ active = menu.checkLoadoutOverwriteActive, mouseOverText = ReadText(1026, 7908), helpOverlayID = "shipconfig_saveloadout_overwrite", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_saveloadout_overwrite" }):setText(ReadText(1001, 7908), {  })
	row[1].handlers.onClick = function () return menu.buttonSave(true) end
	row[2]:createButton({ active = menu.checkLoadoutSaveNewActive, mouseOverText = ReadText(1026, 7909), helpOverlayID = "shipconfig_saveloadout_saveasnew", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "shipconfig_saveloadout_saveasnew" }):setText(ReadText(1001, 7909), {  })
	row[2].handlers.onClick = function () return menu.buttonSave(false) end

	menu.contextFrame:display()
end

function menu.checkLoadoutOverwriteActive()
	local canoverwrite, cansaveasnew = menu.checkLoadoutNameID()
	return canoverwrite
end

function menu.checkLoadoutSaveNewActive()
	local canoverwrite, cansaveasnew = menu.checkLoadoutNameID()
	return cansaveasnew
end

function menu.createEquipmentFilterContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(2, { tabOrder = 6, reserveScrollBar = false })
	ftable:setColWidth(1, Helper.standardTextHeight)

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createCheckBox(menu.checkAllRacesSelected, { height = Helper.standardTextHeight })
	row[1].handlers.onClick = menu.checkboxSelectAllRaces
	row[2]:createText(ReadText(1001, 11912), Helper.headerRowCenteredProperties)

	local isgenericselected
	if menu.equipmentfilter_races.generic then
		isgenericselected = menu.equipmentfilter_races.generic.selected
	end
	-- remove generic and re-add it later after the sort
	menu.equipmentfilter_races.generic = nil
	local races = {}
	for id, racedata in pairs(menu.equipmentfilter_races) do
		racedata.id = id
		table.insert(races, racedata)
	end
	table.sort(races, Helper.sortName)
	menu.equipmentfilter_races.generic = { id = "generic", name = ReadText(1001, 8579), selected = isgenericselected }
	table.insert(races, 1, menu.equipmentfilter_races.generic)

	local color
	for _, racedata in ipairs(races) do
		local row = ftable:addRow(true, { fixed = true })
		row[1]:createCheckBox(function () return menu.checkRacesSelected(racedata) end, { height = Helper.standardTextHeight })
		row[1].handlers.onClick = function(_, checked) menu.checkboxSelectRace(racedata, checked) end
		if racedata.id == "generic" or (menu.equipmentfilter_races[racedata.id].upgradeTypes and menu.equipmentfilter_races[racedata.id].upgradeTypes[menu.upgradetypeMode]) then
			color = Color["text_normal"]
		else
			color = Color["text_inactive"]
		end
		row[2]:createText(racedata.name, { color = color })
	end

	menu.contextFrame:display()
end

function menu.checkRacesSelected(race)
	for _, racedata in pairs(menu.equipmentfilter_races) do
		if racedata.id == race.id then
			return racedata.selected == true
		end
	end
	return false
end

function menu.checkAllRacesSelected()
	for i, racedata in pairs(menu.equipmentfilter_races) do
		if not racedata.selected then
			return false
		end
	end
	return true
end

function menu.checkboxSelectRace(race, checked)
	race.selected = checked
	local found = false
	for j, text in ipairs(menu.equipmentsearchtext) do
		if text.race == race.id then
			found = true
			if not checked then
				table.remove(menu.equipmentsearchtext, j)
			end
			break
		end
	end
	if checked and (not found) then
		table.insert(menu.equipmentsearchtext, { text = race.name, race = race.id })
	end
	menu.displayMenu()
end

function menu.checkboxSelectAllRaces(_, checked)
	for _, racedata in pairs(menu.equipmentfilter_races) do
		racedata.selected = checked
		local found = false
		for j, text in ipairs(menu.equipmentsearchtext) do
			if text.race == racedata.id then
				found = true
				if not checked then
					table.remove(menu.equipmentsearchtext, j)
				end
				break
			end
		end
		if checked and (not found) then
			table.insert(menu.equipmentsearchtext, { text = racedata.name, race = racedata.id })
		end
	end
	menu.displayMenu()
end

function menu.buttonRemoveSearchEntry(index)
	if menu.equipmentsearch_editboxrow > 0 then
		Helper.cancelEditBoxInput(menu.slottable, menu.equipmentsearch_editboxrow, 1)
	end

	if menu.equipmentsearchtext[index].race then
		for _, racedata in pairs(menu.equipmentfilter_races) do
			if racedata.id == menu.equipmentsearchtext[index].race then
				racedata.selected = nil
				break
			end
		end
	end
	table.remove(menu.equipmentsearchtext, index)

	menu.displayMenu()
end

function menu.viewCreated(layer, ...)
	if layer == config.mainLayer then
		menu.map = ...

		if menu.activatemap == nil then
			menu.activatemap = true
		end
	elseif layer == config.infoLayer then
		if menu.upgradetypeMode == "paintmods" then
			menu.titlebartable, menu.leftbartable, menu.buttontable, menu.slottable, menu.plantable = ...
		else
			menu.titlebartable, menu.leftbartable, menu.slottable, menu.plantable = ...
		end

		if (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") then
			menu.updateMoney = GetCurRealTime()
		end
	elseif layer == config.contextLayer then
		menu.contexttable = ...
	end
end

menu.updateInterval = 0.01

function menu.onUpdate()
	local curtime = GetCurRealTime()

	if menu.activatemap then
		-- pass relative screenspace of the holomap rendertarget to the holomap (value range = -1 .. 1)
		local renderX0, renderX1, renderY0, renderY1 = Helper.getRelativeRenderTargetSize(menu, config.mainLayer, menu.map)
		local rendertargetTexture = GetRenderTargetTexture(menu.map)
		if rendertargetTexture then
			menu.holomap = C.AddHoloMap(rendertargetTexture, renderX0, renderX1, renderY0, renderY1, menu.mapData.width / menu.mapData.height, 1)
			if (menu.usemacro and (menu.macro ~= "")) or (((menu.mode == "upgrade") or (menu.mode == "modify")) and (menu.object ~= 0)) then
				if menu.holomap and (menu.holomap ~= 0) then
					menu.currentIdx = menu.currentIdx + 1
					Helper.callLoadoutFunction(menu.upgradeplan, nil, function (loadout, _) return C.ShowObjectConfigurationMap2(menu.holomap, menu.object, 0, menu.macro, false, loadout, 0) end)
					if menu.installedPaintMod then
						C.SetMapPaintMod(menu.holomap, menu.installedPaintMod.ware)
					end
					menu.selectMapMacroSlot()

					if menu.mapstate then
						C.SetMapState(menu.holomap, menu.mapstate)
						menu.mapstate = nil
					end
				end
			end

			menu.activatemap = false
		end
	end

	if menu.map and menu.holomap ~= 0 then
		local x, y = GetRenderTargetMousePosition(menu.map)
		C.SetMapRelativeMousePosition(menu.holomap, (x and y) ~= nil, x or 0, y or 0)
	end

	if menu.holomap and (menu.holomap ~= 0) then
		if menu.picking ~= menu.pickstate then
			menu.pickstate = menu.picking
			C.SetMapPicking(menu.holomap, menu.pickstate)
		end
	end

	if menu.contextMode and (type(menu.contextMode) == "table") and menu.contextMode.nameEditBox then
		ActivateEditBox(menu.contextMode.nameEditBox.id)
		menu.contextMode.nameEditBox = nil
	end

	if menu.noupdate then
		return
	end

	if (menu.object ~= 0) and (not IsValidComponent(ConvertStringTo64Bit(tostring(menu.object)))) then
		menu.object = 0
		menu.damagedcomponents = {}
		menu.selectableships = {}
		menu.selectableshipsbyclass = {}
		menu.modeparam[2] = {}
		menu.macro = ""
		menu.customshipname = ""
		menu.useloadoutname = false
		menu.loadoutName = ""
		menu.playershipname = nil
		menu.clearUndoStack()
		menu.getDataAndDisplay()
		return
	end

	local refresh, newdatarefresh = false, false

	-- update player money
	if menu.updateMoney and (menu.updateMoney + 1 < curtime) then
		menu.updateMoney = curtime
		local currentplayermoney = GetPlayerMoney()
		if menu.shoppinglisttotal > currentplayermoney then
			if not menu.criticalerrors[1] then
				refresh = true
			end
		else
			if menu.criticalerrors[1] then
				refresh = true
			end
		end
	end
	-- update previous upgrades
	if (menu.mode == "upgrade") or (menu.mode == "modify") then
		if menu.object ~= 0 then
			menu.checkCurrentBuildTasks()
			if not menu.tasks[tostring(menu.object)] and menu.errors[3] then
				newdatarefresh = true
			end
		end
	end

	-- do this after the build task check, so there is no error for already finished tasks in menu.errors[3]
	menu.mainFrame:update()
	menu.infoFrame:update()
	if menu.contextFrame then
		menu.contextFrame:update()
	end

	if newdatarefresh then
		menu.getDataAndDisplay(menu.upgradeplan, menu.crew, nil, nil, true)
	elseif refresh then
		menu.displayMenu()
	end
end

function menu.onRowChanged(row, rowdata, uitable)
	if menu.mode == "modify" then
		if uitable == menu.slottable then
			if type(rowdata) == "table" then
				menu.currentSlot = rowdata[1]
				menu.selectMapMacroSlot()
			end
		end
	end
end

function menu.onSelectElement()
end

-- rendertarget selections
function menu.onRenderTargetSelect()
	local offset = table.pack(GetLocalMousePosition())
	-- Check if the mouse button was down less than 0.2 seconds and the mouse was moved more than a distance of 2px
	if menu.leftdown and (menu.leftdown.time + 0.2 > GetCurRealTime()) and (not Helper.comparePositions(menu.leftdown.position, offset, 2)) then
		menu.closeContextMenu()
		if (menu.usemacro and (menu.macro ~= "")) or ((menu.mode == "upgrade") and (menu.object ~= 0)) then
			local pickedslot = ffi.new("UILoadoutSlot")
			if C.GetPickedMapMacroSlot(menu.holomap, menu.object, 0, menu.macro, false, pickedslot) then
				local groupinfo = C.GetUpgradeSlotGroup(menu.object, menu.macro, pickedslot.upgradetype, pickedslot.slot)

				if (ffi.string(groupinfo.path) ~= "..") or (ffi.string(groupinfo.group) ~= "") then
					menu.upgradetypeMode, menu.currentSlot = menu.findGroupIndex(ffi.string(groupinfo.path), ffi.string(groupinfo.group))
				else
					menu.upgradetypeMode = ffi.string(pickedslot.upgradetype)
					menu.currentSlot = tonumber(pickedslot.slot)
				end
				menu.selectMapMacroSlot()
				menu.displayMenu(true)
			end
		elseif ((menu.mode == "modify") and (menu.object ~= 0)) then
			local pickedslot = ffi.new("UILoadoutSlot")
			if C.GetPickedMapMacroSlot(menu.holomap, menu.object, 0, menu.macro, false, pickedslot) then
				local mode = menu.getModUpgradeMode(ffi.string(pickedslot.upgradetype))
				if mode then
					if next(menu.groups) and ((mode == "shieldmods") or (mode == "turretmods")) then
						local groupinfo = C.GetUpgradeSlotGroup(menu.object, menu.macro, pickedslot.upgradetype, pickedslot.slot)
						for i, entry in ipairs(menu.shieldgroups) do
							if ffi.string(groupinfo.group) == entry.group then
								menu.currentSlot = i
								break
							end
						end
					else
						menu.currentSlot = tonumber(pickedslot.slot)
					end
					menu.upgradetypeMode = mode
					menu.selectMapMacroSlot()
					menu.displayMenu()
				end
			end
		end
	end

	menu.leftdown = nil
end

function menu.selectMapMacroSlot()
	if menu.holomap and (menu.holomap ~= 0) then
		if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
			local group = menu.groups[menu.currentSlot]
			if group then
				C.SetSelectedMapGroup(menu.holomap, menu.object, menu.macro, group.path, group.group)
			end
		elseif menu.upgradetypeMode == "repair" then
			if menu.repairslots then
				local group = math.ceil(menu.currentSlot / 3)
				local loccol = menu.currentSlot - ((group - 1) * 3)

				if menu.repairslots[group] and menu.repairslots[group][loccol] then
					local component = menu.repairslots[group][loccol][4]
					local macro = menu.repairslots[group][loccol][2]
					local slot = menu.repairslots[group][loccol][1]

					for i, upgradetype in ipairs(Helper.upgradetypes) do
						if menu.slots[upgradetype.type] and menu.slots[upgradetype.type][slot] and menu.slots[upgradetype.type][slot].component == component then
							C.SetSelectedMapMacroSlot(menu.holomap, menu.object, 0, macro, false, upgradetype.type, slot)
							break
						end
					end

				else
					C.ClearSelectedMapMacroSlots(menu.holomap)
				end
			else
				C.ClearSelectedMapMacroSlots(menu.holomap)
			end
		elseif menu.upgradetypeMode == "settings" then
			C.ClearSelectedMapMacroSlots(menu.holomap)
		elseif menu.mode == "modify" then
			local entry = menu.getLeftBarEntry(menu.upgradetypeMode)
			if next(entry) then
				if (entry.upgrademode == "ship") or (entry.upgrademode == "paint") then
					C.ClearSelectedMapMacroSlots(menu.holomap)
				elseif next(menu.groups) and ((entry.upgrademode == "shield") or (entry.upgrademode == "turret")) then
					local shieldgroup = menu.shieldgroups[menu.currentSlot]
					if shieldgroup then
						C.SetSelectedMapGroup(menu.holomap, menu.object, menu.macro, "..", shieldgroup.group)
					end
				else
					local upgradetype = Helper.findUpgradeType(entry.upgrademode)
					if upgradetype.supertype == "macro" then
						if upgradetype.mergeslots then
							C.SetSelectedMapMacroSlot(menu.holomap, menu.object, 0, menu.macro, false, entry.upgrademode, 0)
						else
							C.SetSelectedMapMacroSlot(menu.holomap, menu.object, 0, menu.macro, false, entry.upgrademode, menu.currentSlot)
						end
					else
						C.ClearSelectedMapMacroSlots(menu.holomap)
					end
				end
			end
		elseif menu.upgradetypeMode and (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") then
			local upgradetype = Helper.findUpgradeType(menu.upgradetypeMode)
			if upgradetype.supertype == "macro" then
				if upgradetype.mergeslots then
					C.SetSelectedMapMacroSlot(menu.holomap, menu.object, 0, menu.macro, false, menu.upgradetypeMode, 0)
				else
					C.SetSelectedMapMacroSlot(menu.holomap, menu.object, 0, menu.macro, false, menu.upgradetypeMode, menu.currentSlot)
				end
			else
				C.ClearSelectedMapMacroSlots(menu.holomap)
			end
		else
			C.ClearSelectedMapMacroSlots(menu.holomap)
		end
	end
end

-- rendertarget mouse input helper
function menu.onRenderTargetMouseDown()
	C.StartPanMap(menu.holomap)
	menu.leftdown = { time = GetCurRealTime(), position = table.pack(GetLocalMousePosition()) }
end

function menu.onRenderTargetMouseUp()
	C.StopPanMap(menu.holomap)
end

function menu.onRenderTargetRightMouseDown()
	C.StartRotateMap(menu.holomap)
	menu.rightdown = { time = GetCurRealTime(), position = table.pack(GetLocalMousePosition()) }
end

function menu.onRenderTargetRightMouseUp()
	C.StopRotateMap(menu.holomap)
	if not menu.isReadOnly then
		local offset = table.pack(GetLocalMousePosition())
		-- Check if the mouse button was down less than 0.2 seconds and the mouse was moved more than a distance of 2px
		if (menu.rightdown.time + 0.2 > GetCurRealTime()) and (not Helper.comparePositions(menu.rightdown.position, offset, 2)) then
			menu.closeContextMenu()
			if (menu.usemacro and (menu.macro ~= "")) or (menu.mode == "upgrade") then
				local pickedslot = ffi.new("UILoadoutSlot")
				if C.GetPickedMapMacroSlot(menu.holomap, menu.object, 0, menu.macro, false, pickedslot) then
					local groupinfo = C.GetUpgradeSlotGroup(menu.object, menu.macro, pickedslot.upgradetype, pickedslot.slot)
					if (ffi.string(groupinfo.path) ~= "..") or (ffi.string(groupinfo.group) ~= "") then
						menu.upgradetypeMode, menu.currentSlot = menu.findGroupIndex(ffi.string(groupinfo.path), ffi.string(groupinfo.group))
					else
						menu.upgradetypeMode = ffi.string(pickedslot.upgradetype)
						menu.currentSlot = tonumber(pickedslot.slot)
					end
					menu.selectMapMacroSlot()
					menu.displayMenu()

					menu.contextData = { upgradetype = ffi.string(pickedslot.upgradetype), slot = tonumber(pickedslot.slot) }
					menu.displayContextFrame("slot", Helper.scaleX(300), offset[1] + Helper.viewWidth / 2, Helper.viewHeight / 2 - offset[2])
				end
			end
		end
	end
	menu.rightdown = nil
end

function menu.onRenderTargetCombinedScrollDown(step)
	C.ZoomMap(menu.holomap, step)
end

function menu.onRenderTargetCombinedScrollUp(step)
	C.ZoomMap(menu.holomap, -step)
end

-- table mouse input helper
function menu.onTableMouseOut(uitable, row)
	if menu.currentMouseOverTable and (uitable == menu.currentMouseOverTable) then
		menu.currentMouseOverTable = nil
		if menu.holomap ~= 0 then
			menu.picking = true
		end
	end
end

function menu.onTableMouseOver(uitable, row)
	menu.currentMouseOverTable = uitable
	if menu.holomap ~= 0 then
		menu.picking = false
	end
end

function menu.onTableRightMouseClick(uitable, row, posx, posy)
	if (menu.mode ~= "modify") and (menu.mode ~= "customgamestart") then
		local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
		if uitable == menu.slottable then
			if type(rowdata) == "table" then
				menu.selectedUpgrade = rowdata
				local x, y = GetLocalMousePosition()
				if x == nil then
					-- gamepad case
					x = posx
					y = -posy
				end
				menu.displayContextFrame("equipment", Helper.scaleX(200), x + Helper.viewWidth / 2, Helper.viewHeight / 2 - y)
			end
		end
	end
end

function menu.onSaveState()
	local state = {}

	if menu.holomap ~= 0 then
		local mapstate = ffi.new("HoloMapState")
		C.GetMapState(menu.holomap, mapstate)
		state.map = { offset = { x = mapstate.offset.x, y = mapstate.offset.y, z = mapstate.offset.z, yaw = mapstate.offset.yaw, pitch = mapstate.offset.pitch, roll = mapstate.offset.roll,}, cameradistance = mapstate.cameradistance }
	end

	for _, key in ipairs(config.stateKeys) do
		state[key[1]] = menu[key[1]]
	end
	return state
end

function menu.onRestoreState(state)
	if state.map then
		local offset = ffi.new("UIPosRot", {
			x = state.map.offset.x,
			y = state.map.offset.y,
			z = state.map.offset.z,
			yaw = state.map.offset.yaw,
			pitch = state.map.offset.pitch,
			roll = state.map.offset.roll
		})
		menu.mapstate = ffi.new("HoloMapState", {
			offset = offset,
			cameradistance = state.map.cameradistance
		})
	end

	local upgradeplan, crew
	for _, key in ipairs(config.stateKeys) do
		if key[1] == "upgradeplan" then
			upgradeplan = state[key[1]]
		elseif key[1] == "crew" then
			crew = state[key[1]]
		elseif key[1] == "shoppinglist" then
			menu.shoppinglist = state[key[1]]
			for i, entry in ipairs(menu.shoppinglist) do
				menu.shoppinglist[i].object = ffi.new("UniverseID", ConvertIDTo64Bit(entry.object))
				menu.shoppinglist[i].hasupgrades = entry.hasupgrades ~= 0
				menu.shoppinglist[i].useloadoutname = entry.useloadoutname ~= 0
			end
		else
			if key[2] == "UniverseID" then
				menu[key[1]] = C.ConvertStringTo64Bit(tostring(state[key[1]]))
			elseif key[2] == "bool" then
				menu[key[1]] = state[key[1]] ~= 0
			else
				menu[key[1]] = state[key[1]]
			end
		end
	end

	return upgradeplan, crew
end

function menu.closeMenu(dueToClose)
	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

function menu.onCloseElement(dueToClose, layer)
	if menu.contextMode then
		menu.closeContextMenu()
		if (dueToClose == "back") or (layer == config.contextLayer) then
			return
		end
	end

	if menu.upgradetypeMode and (dueToClose == "back") and ((menu.mode ~= "modify") or (not menu.modeparam[1])) then
		menu.deactivateUpgradeMode()
		return
	end

	menu.closeMenu((menu.mode == "customgamestart") and "back" or dueToClose)
end

function menu.closeContextMenu()
	Helper.clearFrame(menu, config.contextLayer)
	menu.contextFrame = nil
	menu.contextMode = nil
end

function menu.getAmmoUsage(type)
	local capacity = 0
	if type == "missile" then
		if menu.usemacro then
			if menu.macro ~= "" then
				capacity = C.GetDefaultMissileStorageCapacity(menu.macro)
			end
		elseif menu.mode == "upgrade" then
			if menu.object ~= 0 then
				capacity = GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "missilecapacity")
			end
		end
		for slot, data in pairs(menu.upgradeplan.weapon) do
			local currentmacro = menu.slots.weapon[slot].currentmacro
			if currentmacro ~= data.macro then
				if currentmacro ~= "" then
					capacity = capacity - C.GetMacroMissileCapacity(currentmacro)
				end
				if data.macro ~= "" then
					capacity = capacity + C.GetMacroMissileCapacity(data.macro)
				end
			end
		end
		for slot, data in pairs(menu.upgradeplan.turret) do
			local currentmacro = menu.slots.turret[slot].currentmacro
			if currentmacro ~= data.macro then
				if currentmacro ~= "" then
					capacity = capacity - C.GetMacroMissileCapacity(currentmacro)
				end
				if data.macro ~= "" then
					capacity = capacity + C.GetMacroMissileCapacity(data.macro)
				end
			end
		end
		for slot, groupdata in pairs(menu.upgradeplan.turretgroup) do
			local currentmacro = menu.groups[slot].turret.currentmacro
			local currentoperational = menu.groups[slot].turret.operational
			if currentmacro ~= groupdata.macro then
				if currentmacro ~= "" then
					capacity = capacity - currentoperational * C.GetMacroMissileCapacity(currentmacro)
				end
				if groupdata.macro ~= "" then
					capacity = capacity + groupdata.count * C.GetMacroMissileCapacity(groupdata.macro)
				end
			end
		end
	elseif type == "drone" then
		if menu.usemacro then
			if menu.macro ~= "" then
				capacity = GetMacroUnitStorageCapacity(menu.macro)
			end
		elseif menu.mode == "upgrade" then
			if menu.object ~= 0 then
				if C.IsComponentClass(menu.object, "defensible") then
					capacity = GetUnitStorageData(ConvertStringTo64Bit(tostring(menu.object))).capacity
				else
					capacity = GetMacroUnitStorageCapacity(GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro"))
				end
			end
		end
	elseif type == "deployable" then
		if menu.usemacro then
			if menu.macro ~= "" then
				capacity = C.GetMacroDeployableCapacity(menu.macro)
			end
		elseif menu.mode == "upgrade" then
			if menu.object ~= 0 then
				capacity = C.GetDefensibleDeployableCapacity(ConvertStringTo64Bit(tostring(menu.object)))
			end
		end
	elseif type == "countermeasure" then
		if menu.usemacro then
			if menu.macro ~= "" then
				capacity = C.GetDefaultCountermeasureStorageCapacity(menu.macro)
			end
		elseif menu.mode == "upgrade" then
			if menu.object ~= 0 then
				if C.IsComponentClass(menu.object, "defensible") then
					capacity = GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "countermeasurecapacity") or 0
				else
					capacity = C.GetDefaultCountermeasureStorageCapacity(GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "macro"))
				end
			end
		end
	end

	local total = 0
	for macro, amount in pairs(menu.upgradeplan[type]) do
		local volume = 1
		if type == "missile" then
			local ware = menu.upgradewares[type][menu.findUpgradeMacro(type, macro)]
			if ware.ware then
				volume = GetWareData(ware.ware, "volume")
			end
		end
		total = total + amount * volume
	end

	return total or 0, capacity or 0
end

function menu.isAmmoCompatible(type, ammomacro)
	if ammomacro ~= "" then
		if type == "missile" then
			for slot, data in pairs(menu.upgradeplan.weapon) do
				if data.macro ~= "" then
					if C.IsAmmoMacroCompatible(data.macro, ammomacro) then
						return true
					end
				end
			end
			for slot, data in pairs(menu.upgradeplan.turret) do
				if data.macro ~= "" then
					if C.IsAmmoMacroCompatible(data.macro, ammomacro) then
						return true
					end
				end
			end
			for slot, groupdata in pairs(menu.upgradeplan.turretgroup) do
				if groupdata.macro ~= "" then
					if C.IsAmmoMacroCompatible(groupdata.macro, ammomacro) then
						return true
					end
				end
			end
		elseif type == "drone" then
			return C.IsUnitMacroCompatible(menu.object, menu.macro, ammomacro)
		elseif type == "deployable" then
			return C.IsDeployableMacroCompatible(menu.object, menu.macro, ammomacro)
		elseif type == "countermeasure" then
			if menu.macro ~= "" then
				return (C.GetDefaultCountermeasureStorageCapacity(menu.macro) > 0)
			elseif menu.object ~= 0 then
				return (GetComponentData(ConvertStringTo64Bit(tostring(menu.object)), "countermeasurecapacity") > 0)
			end
		end
	end

	return false
end

function menu.filterUpgradeByText(mode, upgrade, texts)
	local hasracefilter, racematch = false, false
	if mode ~= "crew" and mode ~= "repair" and mode ~= "settings" and mode ~= "software" then
		for _, textentry in ipairs(texts) do
			if textentry.race then
				hasracefilter = true
				local makerraces = GetMacroData(upgrade, "makerraceid")
				if (textentry.race == "generic") and (#makerraces == 0) then
					racematch = true
				end
				for _, makerrace in ipairs(makerraces) do
					if makerrace == textentry.race then
						racematch = true
						break
					end
				end
				if racematch then
					break
				end
			end
		end
	end

	local hasadditionalfilter, filtermatch = false, false
	for _, textentry in ipairs(texts) do
		if not textentry.race then
			hasadditionalfilter = true
			text = utf8.lower(textentry.text)

			if mode == "software" then
				filtermatch = menu.filterSoftwareByText(upgrade, text)
			else
				local shortname, makerracenames = GetMacroData(upgrade, "shortname", "makerracename")
				if string.find(utf8.lower(shortname), text, 1, true) then
					filtermatch = true
				end
				for _, makerracename in ipairs(makerracenames) do
					if string.find(utf8.lower(makerracename), text, 1, true) then
						filtermatch = true
						break
					end
				end
			end
			if filtermatch then
				break
			end
		end
	end

	return ((not hasracefilter) or racematch) and ((not hasadditionalfilter) or filtermatch)
end

function menu.filterSoftwareByText(software, text)
	text = utf8.lower(text)

	local name = GetWareData(software, "name")
	if name and string.find(utf8.lower(name), text, 1, true) then
		return true
	end

	return false
end

function menu.findGroupIndex(path, group)
	for i, groupinfo in ipairs(menu.groups) do
		if (groupinfo.path == path) and (groupinfo.group == group) then
			local mode = "turretgroup"
			if groupinfo["engine"].total > 0 then
				mode = "enginegroup"
			end
			return mode, i
		end
	end
end

function menu.getLeftBarEntry(mode)
	local leftBar = config.leftBar
	if menu.mode == "modify" then
		leftBar = config.leftBarMods
	end

	for i, entry in ipairs(leftBar) do
		if entry.mode == mode then
			return entry
		end
	end

	return {}
end

function menu.prepareComponentUpgradeSlots(object, slots, ammo, software, changeupgradeplan)
	local canequip = menu.container and C.CanContainerEquipShip(menu.container, object)
	-- for all members of set upgradetypes,
	for i, upgradetype in ipairs(Helper.upgradetypes) do
		-- with supertype "macro" (there should be 4)
		if upgradetype.supertype == "macro" then
			-- initialize an entry in table slots with key upgradetype.type
			slots[upgradetype.type] = {}
			-- and for all slots in the object,
			for j = 1, tonumber(C.GetNumUpgradeSlots(object, "", upgradetype.type)) do
				local groupinfo = C.GetUpgradeSlotGroup(object, "", upgradetype.type, j)
				if upgradetype.pseudogroup or ((ffi.string(groupinfo.path) == "..") and (ffi.string(groupinfo.group) == "")) then
					slots[upgradetype.type][j] = { currentmacro = ffi.string(C.GetUpgradeSlotCurrentMacro(object, 0, upgradetype.type, j)), possiblemacros = {}, component = nil }
					if changeupgradeplan then
						local macro = slots[upgradetype.type][j].currentmacro
						local checkforeignmacro
						if canequip then
							if menu.objectgroup then
								local wareidx = menu.findUpgradeMacro(upgradetype.type, slots[upgradetype.type][j].currentmacro)
								if not wareidx then
									checkforeignmacro = true
								else
									local upgradeware = menu.upgradewares[upgradetype.type][wareidx]
									if not upgradeware.isFromShipyard then
										checkforeignmacro = true
									end
								end
							end
						end
						menu.upgradeplan[upgradetype.type][j] = { macro = macro, ammomacro = "", weaponmode = "", checkforeignmacro = checkforeignmacro }
					end
				else
					slots[upgradetype.type][j] = { currentmacro = "", possiblemacros = {}, component = nil }
					if changeupgradeplan then
						menu.upgradeplan[upgradetype.type][j] = { macro = "", ammomacro = "", weaponmode = "" }
					end
				end

				local currentcomponent = C.GetUpgradeSlotCurrentComponent(object, upgradetype.type, j)
				if currentcomponent ~= 0 then
					slots[upgradetype.type][j].component = currentcomponent
					if changeupgradeplan then
						if C.IsComponentClass(currentcomponent, "weapon") then
							menu.upgradeplan[upgradetype.type][j].weaponmode = ffi.string(C.GetWeaponMode(currentcomponent))
							if C.IsComponentClass(currentcomponent, "missilelauncher") then
								menu.upgradeplan[upgradetype.type][j].ammomacro = ffi.string(C.GetCurrentAmmoOfWeapon(currentcomponent))
							end
						end
					end
				end
			end
		elseif upgradetype.supertype == "ammo" then
			ammo[upgradetype.type] = {}

			local ammoentry = {}
			if upgradetype.type == "missile" then
				local n = C.GetNumAllMissiles(object)
				local buf = ffi.new("AmmoData[?]", n)
				n = C.GetAllMissiles(buf, n, object)
				for j = 0, n - 1 do
					local entry = {}
					entry.macro = ffi.string(buf[j].macro)
					entry.amount = buf[j].amount
					table.insert(ammoentry, entry)
				end
			elseif upgradetype.type == "drone" then
				local n = C.GetNumAllUnits(object, false)
				local buf = ffi.new("UnitData[?]", n)
				n = C.GetAllUnits(buf, n, object, false)
				for j = 0, n - 1 do
					local entry = {}
					entry.macro = ffi.string(buf[j].macro)
					entry.category = ffi.string(buf[j].category)
					entry.amount = buf[j].amount
					table.insert(ammoentry, entry)
				end
			elseif upgradetype.type == "deployable" then
				local numlasertowers = C.GetNumAllLaserTowers(object)
				local lasertowers = ffi.new("AmmoData[?]", numlasertowers)
				numlasertowers = C.GetAllLaserTowers(lasertowers, numlasertowers, object)
				for j = 0, numlasertowers - 1 do
					local entry = {}
					entry.macro = ffi.string(lasertowers[j].macro)
					entry.amount = lasertowers[j].amount
					table.insert(ammoentry, entry)
				end

				local numsatellites = C.GetNumAllSatellites(object)
				local satellites = ffi.new("AmmoData[?]", numsatellites)
				numsatellites = C.GetAllSatellites(satellites, numsatellites, object)
				for j = 0, numsatellites - 1 do
					local entry = {}
					entry.macro = ffi.string(satellites[j].macro)
					entry.amount = satellites[j].amount
					table.insert(ammoentry, entry)
				end

				local nummines = C.GetNumAllMines(object)
				local mines = ffi.new("AmmoData[?]", nummines)
				nummines = C.GetAllMines(mines, nummines, object)
				for j = 0, nummines - 1 do
					local entry = {}
					entry.macro = ffi.string(mines[j].macro)
					entry.amount = mines[j].amount
					table.insert(ammoentry, entry)
				end

				local numnavbeacons = C.GetNumAllNavBeacons(object)
				local navbeacons = ffi.new("AmmoData[?]", numnavbeacons)
				numnavbeacons = C.GetAllNavBeacons(navbeacons, numnavbeacons, object)
				for j = 0, numnavbeacons - 1 do
					local entry = {}
					entry.macro = ffi.string(navbeacons[j].macro)
					entry.amount = navbeacons[j].amount
					table.insert(ammoentry, entry)
				end

				local numresourceprobes = C.GetNumAllResourceProbes(object)
				local resourceprobes = ffi.new("AmmoData[?]", numresourceprobes)
				numresourceprobes = C.GetAllResourceProbes(resourceprobes, numresourceprobes, object)
				for j = 0, numresourceprobes - 1 do
					local entry = {}
					entry.macro = ffi.string(resourceprobes[j].macro)
					entry.amount = resourceprobes[j].amount
					table.insert(ammoentry, entry)
				end
			elseif upgradetype.type == "countermeasure" then
				local n = C.GetNumAllCountermeasures(object)
				local buf = ffi.new("AmmoData[?]", n)
				n = C.GetAllCountermeasures(buf, n, object)
				local totalnumcountermeasures = 0
				for j = 0, n - 1 do
					local entry = {}
					entry.macro = ffi.string(buf[j].macro)
					entry.amount = buf[j].amount
					table.insert(ammoentry, entry)
				end
			end

			for _, item in ipairs(ammoentry) do
				local isexcluded = false
				for _, exclusion in ipairs(upgradetype.exclude) do
					if item.category == exclusion then
						isexcluded = true
						break
					end
				end
				if not isexcluded then
					ammo[upgradetype.type][item.macro] = item.amount
				end
				if changeupgradeplan then
					menu.upgradeplan[upgradetype.type][item.macro] = item.amount
				end
			end
		elseif upgradetype.supertype == "software" then
			software[upgradetype.type] = {}
			local n = C.GetNumSoftwareSlots(object, "")
			local buf = ffi.new("SoftwareSlot[?]", n)
			n = C.GetSoftwareSlots(buf, n, object, "")
			for j = 0, n - 1 do
				local entry = {}
				entry.maxsoftware = ffi.string(buf[j].max)
				entry.currentsoftware = ffi.string(buf[j].current)
				if changeupgradeplan then
					table.insert(menu.upgradeplan[upgradetype.type], entry.currentsoftware)
				end
				table.insert(software[upgradetype.type], entry)
			end
		elseif upgradetype.supertype == "virtualmacro" then
			slots[upgradetype.type] = {}
			for j = 1, tonumber(C.GetNumVirtualUpgradeSlots(object, "", upgradetype.type)) do
				-- convert index from lua to C-style
				slots[upgradetype.type][j] = { currentmacro = ffi.string(C.GetVirtualUpgradeSlotCurrentMacro(object, upgradetype.type, j)), possiblemacros = {} }
				if changeupgradeplan then
					local macro = slots[upgradetype.type][j].currentmacro
					local checkforeignmacro
					if canequip then
						if menu.objectgroup then
							local wareidx = menu.findUpgradeMacro(upgradetype.type, slots[upgradetype.type][j].currentmacro)
							if not wareidx then
								checkforeignmacro = true
							end
						end
					end
					menu.upgradeplan[upgradetype.type][j] = { macro = macro, ammomacro = "", weaponmode = "", checkforeignmacro = checkforeignmacro }
				end
			end
		end
	end

	-- add installed components in menu.upgradewares
	for type, slotsentry in pairs(slots) do
		for _, slot in ipairs(slotsentry) do
			if slot.currentmacro and (slot.currentmacro ~= "") then
				local ware = GetMacroData(slot.currentmacro, "ware")
				local i = menu.findUpgradeMacro(type, slot.currentmacro)
				if i then
					menu.upgradewares[type][i].objectamount = menu.upgradewares[type][i].objectamount + 1
				else
					table.insert(menu.upgradewares[type], { ware = ware, macro = slot.currentmacro, objectamount = 1, isFromShipyard = false })
				end
				menu.setMissingUpgrade(ware, 1, i == nil)
			end
		end
	end

	-- add installed ammo in menu.upgradewares
	for type, ammoentry in pairs(ammo) do
		for macro, amount in pairs(ammoentry) do
			local ware = GetMacroData(macro, "ware")
			local i = menu.findUpgradeMacro(type, macro)
			if i then
				menu.upgradewares[type][i].objectamount = menu.upgradewares[type][i].objectamount + amount
			else
				table.insert(menu.upgradewares[type], { ware = ware, macro = macro, objectamount = amount, isFromShipyard = false })
			end
			menu.setMissingUpgrade(ware, amount, i == nil)
		end
	end

	-- assemble possible ammo
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.supertype == "ammo" then
			if ((menu.mode == "upgrade") or (menu.mode == "modify")) and (menu.object ~= 0) then
				if menu.upgradewares[upgradetype.type] then
					for _, upgradeware in ipairs(menu.upgradewares[upgradetype.type]) do
						if not ammo[upgradetype.type][upgradeware.macro] then
							ammo[upgradetype.type][upgradeware.macro] = 0
							if changeupgradeplan then
								menu.upgradeplan[upgradetype.type][upgradeware.macro] = 0
							end
						end
					end
				end
			end
		end
	end
end

function menu.prepareMacroUpgradeSlots(macro)
	for i, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.supertype == "macro" then
			menu.slots[upgradetype.type] = {}
			for j = 1, tonumber(C.GetNumUpgradeSlots(0, macro, upgradetype.type)) do
				-- convert index from lua to C-style
				menu.slots[upgradetype.type][j] = { currentmacro = "", possiblemacros = {} }
				menu.upgradeplan[upgradetype.type][j] = { macro = "", ammomacro = "", weaponmode = "" }
			end
		elseif upgradetype.supertype == "ammo" then
			menu.ammo[upgradetype.type] = {}
		elseif upgradetype.supertype == "software" then
			menu.software[upgradetype.type] = {}
			local n = C.GetNumSoftwareSlots(0, macro)
			local buf = ffi.new("SoftwareSlot[?]", n)
			n = C.GetSoftwareSlots(buf, n, 0, macro)
			for j = 0, n - 1 do
				local entry = {}
				entry.maxsoftware = ffi.string(buf[j].max)
				entry.currentsoftware = ffi.string(buf[j].current)
				table.insert(menu.upgradeplan[upgradetype.type], entry.currentsoftware)
				table.insert(menu.software[upgradetype.type], entry)
			end
		elseif upgradetype.supertype == "virtualmacro" then
			menu.slots[upgradetype.type] = {}
			for j = 1, tonumber(C.GetNumVirtualUpgradeSlots(0, macro, upgradetype.type)) do
				-- convert index from lua to C-style
				menu.slots[upgradetype.type][j] = { currentmacro = "", possiblemacros = {} }
				menu.upgradeplan[upgradetype.type][j] = { macro = "", ammomacro = "", weaponmode = "" }
			end
		end
	end

	-- assemble possible ammo
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.supertype == "ammo" then
			if menu.upgradewares[upgradetype.type] then
				for _, upgradeware in ipairs(menu.upgradewares[upgradetype.type]) do
					if not menu.ammo[upgradetype.type][upgradeware.macro] then
						menu.ammo[upgradetype.type][upgradeware.macro] = 0
						menu.upgradeplan[upgradetype.type][upgradeware.macro] = 0
					end
				end
			end
		end
	end
end

function menu.prepareComponentCrewInfo(object)
	local n = C.GetNumAllRoles()
	local buf = ffi.new("PeopleInfo[?]", n)
	n = C.GetPeople2(buf, n, object, true)
	local numhireable = 0
	for i = 0, n - 1 do
		if buf[i].canhire then
			numhireable = numhireable + 1
			menu.crew.roles[numhireable] = { id = ffi.string(buf[i].id), name = ffi.string(buf[i].name), desc = ffi.string(buf[i].desc), total = buf[i].amount, wanted = buf[i].amount, tiers = {}, canhire = buf[i].canhire }
			menu.crew.total = menu.crew.total + buf[i].amount

			local numtiers = buf[i].numtiers
			local buf2 = ffi.new("RoleTierData[?]", numtiers)
			numtiers = C.GetRoleTiers(buf2, numtiers, object, menu.crew.roles[numhireable].id)
			for j = 0, numtiers - 1 do
				menu.crew.roles[numhireable].tiers[j + 1] = { skilllevel = buf2[j].skilllevel, name = ffi.string(buf2[j].name), total = buf2[j].amount, wanted = buf2[j].amount, npcs = {}, currentnpcs = {} }

				local numnpcs = buf2[j].amount
				local buf3 = ffi.new("NPCSeed[?]", numnpcs)
				numnpcs = C.GetRoleTierNPCs(buf3, numnpcs, object, menu.crew.roles[numhireable].id, menu.crew.roles[numhireable].tiers[j + 1].skilllevel)
				for k = 0, numnpcs - 1 do
					table.insert(menu.crew.roles[numhireable].tiers[j + 1].npcs, buf3[k])
					table.insert(menu.crew.roles[numhireable].tiers[j + 1].currentnpcs, buf3[k])
				end
			end
			if numtiers == 0 then
				menu.crew.roles[numhireable].tiers[1] = { skilllevel = 0, hidden = true, total = buf[i].amount, wanted = buf[i].amount, npcs = {}, currentnpcs = {} }
				local numnpcs = buf[i].amount
				local buf3 = ffi.new("NPCSeed[?]", numnpcs)
				numnpcs = C.GetRoleTierNPCs(buf3, numnpcs, object, menu.crew.roles[numhireable].id, 0)
				for k = 0, numnpcs - 1 do
					table.insert(menu.crew.roles[numhireable].tiers[1].npcs, buf3[k])
					table.insert(menu.crew.roles[numhireable].tiers[1].currentnpcs, buf3[k])
				end
			end
		end
	end

	menu.crew.capacity = C.GetPeopleCapacity(menu.object, menu.macro, false)
end

function menu.prepareMacroCrewInfo(macro)
	local n = C.GetNumAllRoles()
	local buf = ffi.new("PeopleInfo[?]", n)
	n = C.GetAllRoles(buf, n)
	local numhireable = 0
	for i = 0, n - 1 do
		if buf[i].canhire then
			numhireable = numhireable + 1
			menu.crew.roles[numhireable] = { id = ffi.string(buf[i].id), name = ffi.string(buf[i].name), desc = ffi.string(buf[i].desc), total = buf[i].amount, wanted = buf[i].amount, tiers = {}, canhire = buf[i].canhire }
			menu.crew.roles[numhireable].tiers[1] = { skilllevel = 0, hidden = true, total = buf[i].amount, wanted = buf[i].amount, npcs = {}, currentnpcs = {} }
			menu.crew.total = menu.crew.total + buf[i].amount
		end
	end

	menu.crew.capacity = C.GetPeopleCapacity(menu.object, menu.macro, false)
end

function menu.prepareModWares()
	menu.inventory = GetPlayerInventory()

	menu.modwares = {}
	local n = C.GetNumAvailableEquipmentMods()
	local buf = ffi.new("UIEquipmentMod[?]", n)
	n = C.GetAvailableEquipmentMods(buf, n)
	for i = 0, n - 1 do
		local entry = {}
		entry.ware = ffi.string(buf[i].Ware)

		local modclass, modquality, rawresources = GetWareData(entry.ware, "modclass", "modquality", "resources")
		entry.quality = modquality

		entry.resources = {}
		for _, resource in ipairs(rawresources or {}) do
			local resourcedata = menu.inventory[resource.ware]
			if resourcedata then
				local isprimarymodpart = GetWareData(resource.ware, "isprimarymodpart")
				local maxcraftable = math.floor(resourcedata.amount / resource.amount)
				entry.craftableamount = entry.craftableamount and math.min(maxcraftable, entry.craftableamount) or maxcraftable
				if not isprimarymodpart then
					entry.normalcraftableamount = entry.normalcraftableamount and math.min(maxcraftable, entry.normalcraftableamount) or maxcraftable
				end
				table.insert(entry.resources, isprimarymodpart and 1 or (#entry.resources + 1), { ware = resource.ware, data = { name = resourcedata.name, amount = resourcedata.amount, price = resourcedata.price, needed = resource.amount } })
			else
				local resourcename, resourcebuyprice, isprimarymodpart = GetWareData(resource.ware, "name", "buyprice", "isprimarymodpart")
				entry.craftableamount = 0
				if not isprimarymodpart then
					entry.normalcraftableamount = 0
				end
				table.insert(entry.resources, isprimarymodpart and 1 or (#entry.resources + 1), { ware = resource.ware, data = { name = resourcename, amount = 0, price = resourcebuyprice, needed = resource.amount } })
			end
		end

		if menu.modwares[modclass] then
			table.insert(menu.modwares[modclass], entry)
		else
			menu.modwares[modclass] = { entry }
		end
	end

	n = C.GetNumInventoryPaintMods()
	buf = ffi.new("UIPaintMod[?]", n)
	n = C.GetInventoryPaintMods(buf, n);
	for i = 0, n - 1 do
		local entry = {}
		entry.name = ffi.string(buf[i].Name)
		entry.ware = ffi.string(buf[i].Ware)
		entry.quality = buf[i].Quality
		entry.amount = buf[i].Amount

		if menu.modwares["paint"] then
			table.insert(menu.modwares["paint"], entry)
		else
			menu.modwares["paint"] = { entry }
		end
	end
end

function menu.determineNeededRepairs(ship)
	local damagedcomponents = {}

	Helper.ffiVLA(damagedcomponents, "UniverseID", C.GetNumSubComponents, C.GetDamagedSubComponents, ship)

	local hullpercent = GetComponentData(ConvertStringToLuaID(tostring(ship)), "hullpercent")
	if hullpercent < 100 then
		-- NB: we want this to be the last entry so that it will appear first because we then go over damagedcomponents in reverse order.
		table.insert(damagedcomponents, ship)
	end

	return damagedcomponents
end

function menu.findWareIdx(array, ware)
	for i, v in ipairs(array) do
		if v.ware == ware then
			return i
		end
	end
end

function menu.insertWare(array, objectarray, category, ware, count, pricetype)
	local array2 = array
	if category then
		array[category] = array[category] or {}
		array2 = array[category]
	end
	local objectarray2 = objectarray
	if objectarray then
		if category then
			objectarray[category] = objectarray[category] or {}
			objectarray2 = objectarray[category]
		end
	end
	local price = 0
	local i = menu.findWareIdx(array2, ware)
	if i then
		array2[i].amount = array2[i].amount + count
	else
		if menu.container then
			if pricetype == "normal" then
				local isvolatile = GetWareData(ware, "volatile")
				price = isvolatile and 0 or tonumber(C.GetBuildWarePrice(menu.container, ware))
			elseif pricetype == "software" then
				price = C.GetContainerBuildPriceFactor(menu.container) * GetContainerWarePrice(ConvertStringToLuaID(tostring(menu.container)), ware, false)
			elseif pricetype == "crew" then
				price = menu.crew.price
			end
		end
		table.insert(array2, { ware = ware, amount = count, price = price })
	end
	if objectarray then
		local i = menu.findWareIdx(objectarray2, ware)
		if i then
			objectarray2[i].amount = objectarray2[i].amount + count
		else
			if menu.container and (price == 0) then
				if pricetype == "normal" then
					local isvolatile = GetWareData(ware, "volatile")
					price = isvolatile and 0 or tonumber(C.GetBuildWarePrice(menu.container, ware))
				elseif pricetype == "software" then
					price = C.GetContainerBuildPriceFactor(menu.container) * GetContainerWarePrice(ConvertStringToLuaID(tostring(menu.container)), ware, false)
				elseif pricetype == "crew" then
					price = menu.crew.price
				end
			end
			table.insert(objectarray2, { ware = ware, amount = count, price = price })
		end
	end
end

function menu.insertComponent(array, objectarray, component, pricetype)
	local price
	if pricetype == "normal" then
		price = tonumber(C.GetRepairPrice(ConvertStringTo64Bit(component), menu.container)) * menu.repairdiscounts.totalfactor
	end
	table.insert(array, { component = component, price = price })
	table.insert(objectarray, { component = component, price = price })
end

function menu.getLoadoutSummary(upgradeplan, crew, repairplan)
	local wareAmounts = {}

	for i, upgradetype in ipairs(Helper.upgradetypes) do
		local slots = upgradeplan[upgradetype.type]
		local first = true
		for slot, macro in pairs(slots) do
			if first or (not upgradetype.mergeslots) then
				first = false
				if (upgradetype.supertype == "group") and (not upgradetype.pseudogroup) then
					local data = macro
					if data.macro ~= "" then
						local upgradeware = GetMacroData(data.macro, "ware")
						menu.insertWare(wareAmounts, nil, nil, upgradeware, (upgradetype.mergeslots and #slots or data.count))
					end
				elseif (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
					local data = macro
					if data.macro ~= "" then
						local upgradeware = GetMacroData(data.macro, "ware")
						menu.insertWare(wareAmounts, nil, nil, upgradeware, (upgradetype.mergeslots and #slots or 1))
					end
				elseif upgradetype.supertype == "ammo" then
					local new = macro
					local macro = slot
					if new > 0 then
						local upgradeware = GetMacroData(macro, "ware")
						menu.insertWare(wareAmounts, nil, nil, upgradeware, new)
					end
				elseif upgradetype.supertype == "software" then
					local newware = macro
					if newware ~= "" then
						menu.insertWare(wareAmounts, nil, nil, newware, 1)
					end
				end
			end
		end
	end

	-- Crew
	if (crew.total + crew.hired - #crew.fired) > 0 then
		menu.insertWare(wareAmounts, nil, nil, crew.ware, crew.total + crew.hired - #crew.fired)
	end

	local summary = ReadText(1001, 7935) .. ReadText(1001, 120)
	for _, entry in ipairs(wareAmounts) do
		summary = summary .. "\n" .. entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name")
	end

	-- Repair
	if repairplan then
		for componentidstring in pairs(repairplan) do
			if componentidstring ~= "processed" then
				summary = summary .. "\n" .. ReadText(1001, 4217) .. ReadText(1001, 120) .. " " .. ffi.string(C.GetComponentName(ConvertStringTo64Bit(componentidstring))) .. " (" .. (100 - GetComponentData(ConvertStringTo64Bit(componentidstring), "hullpercent")) .. "% " .. ReadText(1001, 1) .. ")"
			end
		end
	end

	return summary
end

function menu.getModUpgradeMode(upgradetype)
	for i, entry in ipairs(config.leftBarMods) do
		if entry.upgrademode == upgradetype then
			return entry.mode
		end
	end
end

function menu.sortAmmo(a, b)
	local atype, btype = "", ""
	if IsMacroClass(a, "satellite") then
		atype = "satellite"
	elseif IsMacroClass(a, "navbeacon") then
		atype = "navbeacon"
	elseif IsMacroClass(a, "resourceprobe") then
		atype = "resourceprobe"
	elseif IsMacroClass(a, "mine") then
		atype = "mine"
	elseif GetMacroData(a, "islasertower") then
		atype = "lasertower"
	end
	if IsMacroClass(b, "satellite") then
		btype = "satellite"
	elseif IsMacroClass(b, "navbeacon") then
		btype = "navbeacon"
	elseif IsMacroClass(b, "resourceprobe") then
		btype = "resourceprobe"
	elseif IsMacroClass(b, "mine") then
		btype = "mine"
	elseif GetMacroData(b, "islasertower") then
		btype = "lasertower"
	end

	if atype == btype then
		return Helper.sortMacroName(a, b)
	end
	return config.deployableOrder[atype] < config.deployableOrder[btype]
end

function menu.findMacroIdx(array, macro)
	for i, v in ipairs(array) do
		if v.macro == macro then
			return i
		end
	end
end

function menu.setupGroupData(object, macro, groups, changeupgradeplan)
	local sizecounts = { engine = {}, turret = {} }
	local n = C.GetNumUpgradeGroups(object, macro)
	local buf = ffi.new("UpgradeGroup[?]", n)
	n = C.GetUpgradeGroups(buf, n, object, macro)
	for i = 0, n - 1 do
		if (ffi.string(buf[i].path) ~= "..") or (ffi.string(buf[i].group) ~= "") then
			table.insert(groups, { path = ffi.string(buf[i].path), group = ffi.string(buf[i].group) })
		end
	end
	table.sort(groups, function (a, b) return a.group < b.group end)
	for i, group in ipairs(groups) do
		for j, upgradetype in ipairs(Helper.upgradetypes) do
			if upgradetype.supertype == "group" then
				local groupinfo = C.GetUpgradeGroupInfo(object, macro, group.path, group.group, upgradetype.grouptype)
				local currentmacro = ffi.string(groupinfo.currentmacro)
				local slotsize = ffi.string(groupinfo.slotsize)

				local compatibilities
				local n_comp = C.GetNumUpgradeGroupCompatibilities(object, macro, 0, group.path, group.group, upgradetype.grouptype)
				if n_comp > 0 then
					compatibilities = {}
					local buf_comp = ffi.new("EquipmentCompatibilityInfo[?]", n)
					n_comp = C.GetUpgradeGroupCompatibilities(buf_comp, n_comp, object, macro, 0, group.path, group.group, upgradetype.grouptype)
					for k = 0, n_comp - 1 do
						compatibilities[ffi.string(buf_comp[k].tag)] = ffi.string(buf_comp[k].name)
					end
				end

				groups[i][upgradetype.grouptype] = { count = groupinfo.count, operational = groupinfo.operational, total = groupinfo.total, slotsize = slotsize, compatibilities = compatibilities, currentcomponent = (groupinfo.currentcomponent ~= 0) and groupinfo.currentcomponent or nil, currentmacro = currentmacro, possiblemacros = {} }
				if upgradetype.grouptype ~= "shield" then
					groups[i].slotsize = slotsize
					groups[i].compatibilities = compatibilities

					if groups[i][upgradetype.grouptype].total > 0 then
						groups[i].groupname = i
						if slotsize ~= "" then
							if sizecounts[upgradetype.grouptype][slotsize] then
								sizecounts[upgradetype.grouptype][slotsize] = sizecounts[upgradetype.grouptype][slotsize] + 1
							else
								sizecounts[upgradetype.grouptype][slotsize] = 1
							end
							groups[i].groupname = upgradetype.shorttext[slotsize] .. sizecounts[upgradetype.grouptype][slotsize]
						end
					end
				end
				if changeupgradeplan then
					local weaponmode = ""
					if object ~= 0 then
						weaponmode = ffi.string(C.GetTurretGroupMode2(object, 0, group.path, group.group))
					end
					menu.upgradeplan[upgradetype.type][i] = { macro = currentmacro, count = groupinfo.count, path = group.path, group = group.group, ammomacro = "", weaponmode = weaponmode }
					if currentmacro ~= "" then
						local ware = GetMacroData(currentmacro, "ware")
						local k = menu.findUpgradeMacro(upgradetype.grouptype, currentmacro)
						if k then
							if menu.objectgroup then
								if not menu.upgradewares[upgradetype.grouptype][k].isFromShipyard then
									menu.upgradeplan[upgradetype.type][i].checkforeignmacro = true
								end
							end
							menu.upgradewares[upgradetype.grouptype][k].objectamount = menu.upgradewares[upgradetype.grouptype][k].objectamount + groupinfo.count
						else
							if menu.objectgroup then
								menu.upgradeplan[upgradetype.type][i].checkforeignmacro = true
							end
							table.insert(menu.upgradewares[upgradetype.grouptype], { ware = ware, macro = currentmacro, objectamount = groupinfo.count, isFromShipyard = false })
						end
						menu.setMissingUpgrade(ware, groupinfo.count, k == nil)
					end
				end
			end
		end
	end
end

function menu.setMissingUpgrade(ware, amount, allownewentry)
	for j, entry in ipairs(menu.missingUpgrades) do
		if entry.ware == ware then
			menu.missingUpgrades[j].amount = menu.missingUpgrades[j].amount + amount
			return
		end
	end
	if allownewentry then
		table.insert(menu.missingUpgrades, { ware = ware, name = GetWareData(ware, "name"), amount = amount })
	end
end

function menu.repairandupgrade(shoppinglistentry, object, macro, hasupgrades, haspaid, objectprice, objectcrewprice)
	local objectstring = tostring(object)
	if (object ~= 0) and menu.repairplan[objectstring] and next(menu.repairplan[objectstring]) and (not menu.repairplan[objectstring]["processed"]) then
		local skip = menu.checkCommanderRepairOrders(objectstring)
		if not skip then
			--print("pilot: " .. tostring(GetComponentData(ConvertStringTo64Bit(objectstring), "pilot")) .. ", cond: " .. tostring( (object == C.GetPlayerOccupiedShipID()) or not GetComponentData(ConvertStringTo64Bit(objectstring), "pilot") ) .. " cond1: " .. tostring(object == C.GetPlayerOccupiedShipID()) .. " cond2: " .. tostring(not GetComponentData(ConvertStringTo64Bit(objectstring), "pilot")))
			if (C.GetTopLevelContainer(object) == menu.container) then
				local damagedcomponents = {}
				for componentidstring, _ in pairs(menu.repairplan[objectstring]) do
					if componentidstring ~= "processed" and componentidstring ~= objectstring then
						table.insert(damagedcomponents, ConvertStringToLuaID(componentidstring))
					end
				end

				-- signal received in build.shiptrader
				-- param = "'repairs_initiate'", param2 = $shiptoberepaired, param3 = [hullpercent(int), damagedcomponents(list)]
				--print("signalling " .. ffi.string(C.GetComponentName(menu.container)) .. " to repair " .. ffi.string(C.GetComponentName(object)) .. " " .. objectstring)
				SignalObject(menu.container, "repairs_initiate", ConvertStringToLuaID(objectstring), {100, damagedcomponents})
			else
				local orderindex = C.CreateOrder(object, "Repair", false)
				if orderindex > 0 then
					menu.processRepairsFor(objectstring, orderindex)

					-- in this case, signal is sent from order.repair
					if not C.EnableOrder(object, orderindex) then
						print("ERROR: Order to initiate repairs for " .. ffi.string(C.GetComponentName(entry.object)) .. " was not enabled.")
					end
				end
			end
		end
	end

	if hasupgrades then
		for i = 1, shoppinglistentry.amount do
			local numblacklisttypes = 0
			for _ in pairs(shoppinglistentry.settings.blacklists) do
				numblacklisttypes = numblacklisttypes + 1
			end
			local blacklists = ffi.new("BlacklistTypeID[?]", numblacklisttypes)
			local i = 0
			for blacklisttype, id in pairs(shoppinglistentry.settings.blacklists) do
				blacklists[i].type = blacklisttype
				blacklists[i].id = id
				i = i + 1
			end

			local numfightruletypes = 0
			for _ in pairs(shoppinglistentry.settings.fightrules) do
				numfightruletypes = numfightruletypes + 1
			end
			local fightrules = ffi.new("FightRuleTypeID[?]", numfightruletypes)
			local i = 0
			for fightruletype, id in pairs(shoppinglistentry.settings.fightrules) do
				fightrules[i].type = fightruletype
				fightrules[i].id = id
				print(id)
				i = i + 1
			end

			local additionalinfo = ffi.new("AddBuildTask5Container", {
				blacklists = blacklists,
				numblacklists = numblacklisttypes,
				fightrules = fightrules,
				numfightrules = numfightruletypes
			})

			local buildtaskid = Helper.callLoadoutFunction(shoppinglistentry.upgradeplan, shoppinglistentry.crew, function (loadout, crewtransfer) return C.AddBuildTask5(menu.container, object, macro, loadout, menu.isplayerowned and 0 or (objectprice or shoppinglistentry.price), crewtransfer, menu.immediate, shoppinglistentry.customshipname, additionalinfo) end, nil, "UILoadout2")
			if (buildtaskid ~= 0) and haspaid then
				C.SetBuildTaskTransferredMoney(buildtaskid, objectprice and (objectprice + objectcrewprice) or haspaid)
			end

            		-- kuertee start: callback
			if callbacks["repairandupgrade_after_build_order_created"] then
                		for _, callback in ipairs(callbacks["repairandupgrade_after_build_order_created"]) do
                    		callback(shoppinglistentry, object, buildtaskid)
                		end
            		end
			-- kuertee end: callback

		end
	end
end

function menu.upgradeSettingsVersion()
	local oldversion = __CORE_DETAILMONITOR_SHIPBUILD.version

	if oldversion < 2 then

	end

	__CORE_DETAILMONITOR_SHIPBUILD.version = config.persistentdataversion
end


-- kuertee start:
function menu.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.

	-- to find callbacks available for this menu,
	-- reg-ex search for callbacks.*\[\".*\]

	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end

function menu.deregisterCallback(callbackName, callbackFunction)
	-- for i, callback in ipairs(callbacks[callbackName]) do
	if callbacks[callbackName] and #callbacks[callbackName] > 0 then
		for i = #callbacks[callbackName], 1, -1 do
			if callbacks[callbackName][i] == callbackFunction then
				table.remove(callbacks[callbackName], i)
			end
		end
	end
end

function menu.loadModLuas()
	if Helper then
		Helper.loadModLuas(menu.name, "menu_shipconfiguration_uix")
	end
end
-- kuertee end

init()
