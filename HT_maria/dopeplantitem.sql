CREATE TABLE IF NOT EXISTS `dopeplants` (
  `owner` varchar(50) NOT NULL,
  `plant` longtext NOT NULL,
  `plantid` bigint(20) NOT NULL
);


INSERT INTO `items` (`name`,`label`,`limit`) VALUES
	('highgradefemaleseed', 'Semilla Queen', 10),
	('lowgradefemaleseed', 'Semilla hembra', 10),
	('highgrademaleseed', 'Semilla King', 10),
	('lowgrademaleseed', 'Semilla macho', 10),
	('highgradefert', 'Fertilizante especial', 2),
	('lowgradefert', 'Fertilizante', 2),
	('purifiedwater', 'Agua tratada', 2),
	('wateringcan', 'Garrafa de agua', 2),
	('plantpot', 'Maceta', 2),
	('trimmedweed', 'Cogollo', 300),
	('dopebag', 'Bolsa de plastico', 40),
	('bagofdope', 'Bolsa de marihuana', 20),
	('drugscales', 'Bascula', 1);
