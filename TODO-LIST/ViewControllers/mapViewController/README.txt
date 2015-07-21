11/30

作为nav push存在，delegate返回选定的pin的坐标，类型为PFGeoPoint，数据库存储okay

TODO：
1. callOut view transition





11/25
Siyao:
	
MapViewController：作为弹出的VC，包含搜索栏，可以搜索区域内的相关地点。

目前已完成基本功能，可搜索，可更新user location，可delegate返回NSMutableArray数据(MKMapItem)

TODO：
1. 需要保存哪些数据，自身位置？兴趣点位置？哪些兴趣点位置？
2. search模式和view模式：	view不需要搜索，只需要知道兴趣点在哪里
3. 在database没有问题之后，可以尝试基于位置的提醒功能，比如你想去超市买个东西，list里维护了一个或者多个超市坐标的array。然后后台或者前台的位置服务，如果检测到现在在附近，给出提醒之类的。因为想了想，除此之外，位置/地图这个功能，好像没有太大的实用性。