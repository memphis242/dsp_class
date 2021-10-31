#define K 50 
#define NS 25 

float A[4][NS][3] = { 
	 {
		1.000000000000, 0.000000000000, -0.963000741875,
		1.000000000000, 1.962572379656, 0.963301300144,
		1.000000000000, -1.962572379656, 0.963301300144,
		1.000000000000, 1.962351705148, 0.964196727574,
		1.000000000000, -1.962351705148, 0.964196727574,
		1.000000000000, 1.962043369258, 0.965668644183,
		1.000000000000, -1.962043369258, 0.965668644183,
		1.000000000000, 1.961731757089, 0.967687572344,
		1.000000000000, -1.961731757089, 0.967687572344,
		1.000000000000, 1.961525853338, 0.970214500530,
		1.000000000000, -1.961525853338, 0.970214500530,
		1.000000000000, 1.961551043600, 0.973202767343,
		1.000000000000, -1.961551043600, 0.973202767343,
		1.000000000000, 1.961939773237, 0.976600031290,
		1.000000000000, -1.961939773237, 0.976600031290,
		1.000000000000, 1.962821719403, 0.980350104851,
		1.000000000000, -1.962821719403, 0.980350104851,
		1.000000000000, 1.964314080088, 0.984394476321,
		1.000000000000, -1.964314080088, 0.984394476321,
		1.000000000000, 1.966512490965, 0.988673407502,
		1.000000000000, -1.966512490965, 0.988673407502,
		1.000000000000, 1.969482976332, 0.993126566933,
		1.000000000000, -1.969482976332, 0.993126566933,
		1.000000000000, 1.973255250551, 0.997693226469,
		1.000000000000, -1.973255250551, 0.997693226469,
	 },

	 {
		1.000000000000, 0.000000000000, -0.925545679836,
		1.000000000000, -1.923221040902, 0.926228769207,
		1.000000000000, 1.923221040902, 0.926228769207,
		1.000000000000, -1.920654948975, 0.928251359225,
		1.000000000000, 1.920654948975, 0.928251359225,
		1.000000000000, -1.916662306747, 0.931536893464,
		1.000000000000, 1.916662306747, 0.931536893464,
		1.000000000000, -1.911640460618, 0.935968553552,
		1.000000000000, 1.911640460618, 0.935968553552,
		1.000000000000, -1.906092985355, 0.941402853270,
		1.000000000000, 1.906092985355, 0.941402853270,
		1.000000000000, -1.900587413611, 0.947684431196,
		1.000000000000, 1.900587413611, 0.947684431196,
		1.000000000000, -1.895712500487, 0.954659460141,
		1.000000000000, 1.895712500487, 0.954659460141,
		1.000000000000, -1.892039351709, 0.962185868629,
		1.000000000000, 1.892039351709, 0.962185868629,
		1.000000000000, -1.890088873047, 0.970139542523,
		1.000000000000, 1.890088873047, 0.970139542523,
		1.000000000000, -1.890306119132, 0.978416513089,
		1.000000000000, 1.890306119132, 0.978416513089,
		1.000000000000, -1.893040672456, 0.986931672436,
		1.000000000000, 1.893040672456, 0.986931672436,
		1.000000000000, -1.898531368965, 0.995614780742,
		1.000000000000, 1.898531368965, 0.995614780742,
	 },

	 {
		1.000000000000, 0.000000000000, -0.840838923646,
		1.000000000000, 1.828858152370, 0.843197912269,
		1.000000000000, -1.828858152370, 0.843197912269,
		1.000000000000, 1.814200575618, 0.849990687532,
		1.000000000000, -1.814200575618, 0.849990687532,
		1.000000000000, 1.791650620093, 0.860455202103,
		1.000000000000, -1.791650620093, 0.860455202103,
		1.000000000000, 1.763612740101, 0.873573220714,
		1.000000000000, -1.763612740101, 0.873573220714,
		1.000000000000, 1.732790487759, 0.888314450295,
		1.000000000000, -1.732790487759, 0.888314450295,
		1.000000000000, 1.701812900419, 0.903813461598,
		1.000000000000, -1.701812900419, 0.903813461598,
		1.000000000000, 1.672991318471, 0.919449978787,
		1.000000000000, -1.672991318471, 0.919449978787,
		1.000000000000, 1.648215690852, 0.934851573240,
		1.000000000000, -1.648215690852, 0.934851573240,
		1.000000000000, 1.628956489743, 0.949854289516,
		1.000000000000, -1.628956489743, 0.949854289516,
		1.000000000000, 1.616326216877, 0.964450756685,
		1.000000000000, -1.616326216877, 0.964450756685,
		1.000000000000, 1.611161594754, 0.978742515455,
		1.000000000000, -1.611161594754, 0.978742515455,
		1.000000000000, 1.614100472387, 0.992902611065,
		1.000000000000, -1.614100472387, 0.992902611065,
	 },

	 {
		1.000000000000, 0.000000000000, -0.463855180907,
		1.000000000000, 1.329452099011, 0.525225827691,
		1.000000000000, -1.329452099011, 0.525225827691,
		1.000000000000, 1.235213964569, 0.643076888750,
		1.000000000000, -1.235213964569, 0.643076888750,
		1.000000000000, 1.111582160172, 0.746563060069,
		1.000000000000, -1.111582160172, 0.746563060069,
		1.000000000000, 0.991873457110, 0.820946703558,
		1.000000000000, -0.991873457110, 0.820946703558,
		1.000000000000, 0.890282927407, 0.871944505951,
		1.000000000000, -0.890282927407, 0.871944505951,
		1.000000000000, 0.808999490859, 0.907171726275,
		1.000000000000, -0.808999490859, 0.907171726275,
		1.000000000000, 0.745922985584, 0.932217789601,
		1.000000000000, -0.745922985584, 0.932217789601,
		1.000000000000, 0.698150990059, 0.950720001871,
		1.000000000000, -0.698150990059, 0.950720001871,
		1.000000000000, 0.663136923722, 0.965003921459,
		1.000000000000, -0.663136923722, 0.965003921459,
		1.000000000000, 0.638960044283, 0.976591185301,
		1.000000000000, -0.638960044283, 0.976591185301,
		1.000000000000, 0.624320309758, 0.986527980627,
		1.000000000000, -0.624320309758, 0.986527980627,
		1.000000000000, 0.618478709165, 0.995591630657,
		1.000000000000, -0.618478709165, 0.995591630657,
	 },

};

float B[4][NS][3] = { 
	 {
		1.000000000000, 1.999612671799, 1.000000000000,
		1.000000000000, -1.999612671799, 1.000000000000,
		1.000000000000, 1.998476324300, 1.000000000000,
		1.000000000000, -1.998476324300, 1.000000000000,
		1.000000000000, 1.996665925206, 1.000000000000,
		1.000000000000, -1.996665925206, 1.000000000000,
		1.000000000000, 1.994300152668, 1.000000000000,
		1.000000000000, -1.994300152668, 1.000000000000,
		1.000000000000, 1.991532691871, 1.000000000000,
		1.000000000000, -1.991532691871, 1.000000000000,
		1.000000000000, 1.988541319105, 1.000000000000,
		1.000000000000, -1.988541319105, 1.000000000000,
		1.000000000000, -1.985515778043, 1.000000000000,
		1.000000000000, 1.985515778043, 1.000000000000,
		1.000000000000, -1.982645441162, 1.000000000000,
		1.000000000000, 1.982645441162, 1.000000000000,
		1.000000000000, -1.980107620653, 1.000000000000,
		1.000000000000, 1.980107620653, 1.000000000000,
		1.000000000000, 1.978057196057, 1.000000000000,
		1.000000000000, -1.978057196057, 1.000000000000,
		1.000000000000, -1.976618011603, 1.000000000000,
		1.000000000000, 1.976618011603, 1.000000000000,
		1.000000000000, 1.975876307071, 1.000000000000,
		1.000000000000, -1.975876307071, 1.000000000000,
		0.742501060686, -1.485002121372, 0.742501060686,
	 },

	 {
		1.000000000000, -2.000000000000, 1.000000000000,
		1.000000000000, -1.998371447977, 1.000000000000,
		1.000000000000, 1.993611024920, 1.000000000000,
		1.000000000000, -1.993611024920, 1.000000000000,
		1.000000000000, 1.986080074479, 1.000000000000,
		1.000000000000, -1.986080074479, 1.000000000000,
		1.000000000000, 1.976335986334, 1.000000000000,
		1.000000000000, -1.976335986334, 1.000000000000,
		1.000000000000, 1.965074399783, 1.000000000000,
		1.000000000000, -1.965074399783, 1.000000000000,
		1.000000000000, 1.953064045961, 1.000000000000,
		1.000000000000, -1.953064045961, 1.000000000000,
		1.000000000000, 1.941084028266, 1.000000000000,
		1.000000000000, -1.941084028266, 1.000000000000,
		1.000000000000, 1.929870574562, 1.000000000000,
		1.000000000000, -1.929870574562, 1.000000000000,
		1.000000000000, -1.920076667236, 1.000000000000,
		1.000000000000, 1.920076667236, 1.000000000000,
		1.000000000000, 1.912244686841, 1.000000000000,
		1.000000000000, -1.912244686841, 1.000000000000,
		1.000000000000, -1.906789995331, 1.000000000000,
		1.000000000000, 1.906789995331, 1.000000000000,
		1.000000000000, -1.903992391408, 1.000000000000,
		1.000000000000, 1.903992391408, 1.000000000000,
		0.551222859904, 1.101548024704, 0.551222859904,
	 },

	 {
		1.000000000000, 2.000000000000, 1.000000000000,
		1.000000000000, 1.991896797206, 1.000000000000,
		1.000000000000, -1.968654033248, 1.000000000000,
		1.000000000000, 1.968654033248, 1.000000000000,
		1.000000000000, -1.933172143953, 1.000000000000,
		1.000000000000, 1.933172143953, 1.000000000000,
		1.000000000000, -1.889439758572, 1.000000000000,
		1.000000000000, 1.889439758572, 1.000000000000,
		1.000000000000, 1.841686898092, 1.000000000000,
		1.000000000000, -1.841686898092, 1.000000000000,
		1.000000000000, 1.793734770970, 1.000000000000,
		1.000000000000, -1.793734770970, 1.000000000000,
		1.000000000000, 1.748658501207, 1.000000000000,
		1.000000000000, -1.748658501207, 1.000000000000,
		1.000000000000, 1.708720394554, 1.000000000000,
		1.000000000000, -1.708720394554, 1.000000000000,
		1.000000000000, 1.675466209085, 1.000000000000,
		1.000000000000, -1.675466209085, 1.000000000000,
		1.000000000000, -1.649885025532, 1.000000000000,
		1.000000000000, 1.649885025532, 1.000000000000,
		1.000000000000, -1.632568814390, 1.000000000000,
		1.000000000000, 1.632568814390, 1.000000000000,
		1.000000000000, 1.623840607723, 1.000000000000,
		1.000000000000, -1.623840607723, 1.000000000000,
		0.303498205030, -0.604537102558, 0.303498205030,
	 },

	 {
		1.000000000000, -2.000000000000, 1.000000000000,
		1.000000000000, 1.868021538130, 1.000000000000,
		1.000000000000, -1.868021538130, 1.000000000000,
		1.000000000000, 1.593139531260, 1.000000000000,
		1.000000000000, -1.593139531260, 1.000000000000,
		1.000000000000, -1.329769803617, 1.000000000000,
		1.000000000000, 1.329769803617, 1.000000000000,
		1.000000000000, -1.124829350342, 1.000000000000,
		1.000000000000, 1.124829350342, 1.000000000000,
		1.000000000000, 0.973860864839, 1.000000000000,
		1.000000000000, -0.973860864839, 1.000000000000,
		1.000000000000, 0.863532003560, 1.000000000000,
		1.000000000000, -0.863532003560, 1.000000000000,
		1.000000000000, 0.782713300302, 1.000000000000,
		1.000000000000, -0.782713300302, 1.000000000000,
		1.000000000000, -0.723610859741, 1.000000000000,
		1.000000000000, 0.723610859741, 1.000000000000,
		1.000000000000, 0.681014232668, 1.000000000000,
		1.000000000000, -0.681014232668, 1.000000000000,
		1.000000000000, 0.651503615451, 1.000000000000,
		1.000000000000, -0.651503615451, 1.000000000000,
		1.000000000000, 0.632894586130, 1.000000000000,
		1.000000000000, -0.632894586130, 1.000000000000,
		1.000000000000, -0.623891739276, 1.000000000000,
		0.091489499958, 0.057079543254, 0.091489499958,
	 },

};
