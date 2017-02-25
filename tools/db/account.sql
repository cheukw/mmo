CREATE TABLE `accountidentity` (
  `id_account_identity` int(11) NOT NULL auto_increment,
  `plat_user_name` varbinary(64) NOT NULL default '' COMMENT '平台名',
  `name` varbinary(20) NOT NULL default '' COMMENT '姓名',
  `identity_num` varchar(20) NOT NULL default '' COMMENT '身份证号',
  `phone_num` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY  (`id_account_identity`),
  KEY `id_index` (`identity_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家的身份证记录，用于防沉迷，属Account数据库(不缓存)';

CREATE TABLE `login` (
  `login_id` bigint(20) NOT NULL auto_increment COMMENT '登录ID',
  `plat_user_name` varbinary(64) NOT NULL default '' COMMENT '平台用户账号',
  `ditch_name` varbinary(8) NOT NULL default '0' COMMENT '渠道名',
  `role_id_1` int(11) NOT NULL default '0' COMMENT '角色id',
  `role_id_2` int(11) NOT NULL default '0',
  `role_id_3` int(11) NOT NULL default '0',
  `last_login_time` bigint(20) NOT NULL default '0' COMMENT '最后登录时间\n',
  `create_time` bigint(20) NOT NULL default '0' COMMENT '帐号创建时间',
  `forbid_time` bigint(20) NOT NULL default '0' COMMENT '封号时间',
  `is_anti_wallow` tinyint(4) NOT NULL default '0' COMMENT '是否通过防沉迷，0为未通过',
  PRIMARY KEY  (`login_id`),
  KEY `plat_user_id_INX` (`plat_user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登录注册表\n属Account数据库';

CREATE TABLE `role_name_map` (
  `id_role_name_map` bigint(20) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL default '0',
  `role_name` varbinary(32) NOT NULL default '',
  `plat_user_name` varbinary(64) NOT NULL default '',
  `ditch_name` varbinary(8) NOT NULL default '',
  PRIMARY KEY  (`id_role_name_map`),
  KEY `role_name_index` (`role_name`),
  KEY `role_id_index` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='属Account数据库';



