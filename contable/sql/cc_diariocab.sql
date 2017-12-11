/*
Navicat MySQL Data Transfer

Source Server         : vps
Source Server Version : 50628
Source Host           : 5.189.144.206:3306
Source Database       : magiadb

Target Server Type    : MYSQL
Target Server Version : 50628
File Encoding         : 65001

Date: 2017-12-11 08:05:08
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `cc_diariocab`
-- ----------------------------
DROP TABLE IF EXISTS `cc_diariocab`;
CREATE TABLE `cc_diariocab` (
  `secuencial` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(36) DEFAULT NULL,
  `diario` int(11) NOT NULL DEFAULT '0',
  `tc_compra` float(10,3) NOT NULL DEFAULT '0.000',
  `tipodoc` char(2) NOT NULL DEFAULT '0',
  `tipodocid` char(2) DEFAULT '0',
  `docid` varchar(14) DEFAULT NULL,
  `percepcion` char(1) NOT NULL DEFAULT '0',
  `detraccion` char(1) NOT NULL DEFAULT '0',
  `ruc` varchar(11) DEFAULT NULL,
  `glosa` varchar(128) DEFAULT NULL,
  `estado` enum('0','1','2') NOT NULL DEFAULT '0',
  `fecha_conta` date DEFAULT '0000-00-00',
  `moneda` enum('0','1') NOT NULL DEFAULT '0',
  `referencia` int(11) NOT NULL DEFAULT '0',
  `consolida` int(11) NOT NULL DEFAULT '0',
  `lastupdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `usuario` varchar(12) DEFAULT NULL,
  `tc_compra1` float(10,3) NOT NULL DEFAULT '0.000',
  `tc_venta` float(10,3) NOT NULL DEFAULT '0.000',
  PRIMARY KEY (`secuencial`),
  KEY `fecha_conta` (`fecha_conta`) USING BTREE,
  KEY `glosa` (`glosa`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `diario` (`diario`,`fecha_conta`) USING BTREE,
  KEY `referencia` (`referencia`) USING BTREE,
  KEY `consolida` (`consolida`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=88 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of cc_diariocab
-- ----------------------------
INSERT INTO `cc_diariocab` VALUES ('64', 'c35b0b3dff7c4117956b60b7c923e1b6', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('65', 'd5cbe30fe8ed455b812235cc4edfd7af', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('66', '596220ea40ba404a9c42445c9b401169', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('67', '16fc9a34527b4fce9ad9c19b9552f1e0', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('68', 'f7bc19ffc323495a965f8f6a9ff9883e', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('69', 'e9a057148263498ebc28bb15d1cba55a', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('70', '2219774bcb6e4ab285aca79965bdeb62', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('71', 'c25ffecafec34741abbb509c17c13a69', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('72', '5219a704180a4a419696f4139240a45d', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('73', '957f1cb572834eed8084a160821679b9', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('74', '0f58b440aea9471f99ccad5982594f4a', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('75', '23322bab9f3d4fd1917da24fd9a527c6', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('76', '2b23c5a0daef4b9eaefd55765e9eb155', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('77', '978ee9b82f3b45e0b63d79e0251f292c', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('78', '0c241185d36849ec9594a991dd66d8ed', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('79', 'b8df6b270e194f4ab9f28ed6f30964d6', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('80', '6349baa4f79640ee8a64ebc3bf857c68', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('81', '2a5baf2f838844d9b61b9c8f10ce14fa', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('82', 'b446238744ff467ab185b9f5fd3ca9b1', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('83', '700b1701093644a5b63363170c988c03', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('84', '1c4eab43a3ce46b59ab57b87a589b8a4', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('85', 'ff128e4240ed44308810bbcac76fca58', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('86', '3ca027ecd69749c09c3c2cf67b5736d6', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');
INSERT INTO `cc_diariocab` VALUES ('87', '36e995b5131a430d92074b54f665060b', '17', '3.200', '6', '1', 'F008-13', '0', '0', '48301368', 'VENTA', '0', '2017-11-26', '0', '13', '0', '2017-11-26 00:00:00', '10706008391', '3.200', '3.200');

-- ----------------------------
-- Table structure for `cc_diariodet`
-- ----------------------------
DROP TABLE IF EXISTS `cc_diariodet`;
CREATE TABLE `cc_diariodet` (
  `secuencial` int(11) NOT NULL DEFAULT '0',
  `interno` int(11) NOT NULL AUTO_INCREMENT,
  `cuenta` varchar(60) NOT NULL DEFAULT '',
  `memo` varchar(24) DEFAULT NULL,
  `dh` char(1) NOT NULL DEFAULT '0',
  `soles` float(10,2) DEFAULT NULL,
  `dolar` float(10,2) DEFAULT NULL,
  `pesos` float(10,3) NOT NULL DEFAULT '0.000',
  PRIMARY KEY (`secuencial`,`interno`),
  KEY `cuenta` (`cuenta`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of cc_diariodet
-- ----------------------------
INSERT INTO `cc_diariodet` VALUES ('65', '0', '121200', null, '1', '100.00', '31.25', '0.000');
INSERT INTO `cc_diariodet` VALUES ('67', '0', '121200', null, '1', '100.00', '31.25', '0.000');
INSERT INTO `cc_diariodet` VALUES ('69', '3', '121200', null, '1', '100.00', '31.25', '0.000');
INSERT INTO `cc_diariodet` VALUES ('70', '3', '121200', null, '1', '100.00', '31.25', '0.000');
INSERT INTO `cc_diariodet` VALUES ('71', '3', '121200', null, '1', '100.00', '31.25', '0.000');
INSERT INTO `cc_diariodet` VALUES ('72', '3', '121200', null, '0', '100.00', '36.88', '0.000');
INSERT INTO `cc_diariodet` VALUES ('73', '1', '701100', null, '1', '118.00', '36.88', '0.000');
INSERT INTO `cc_diariodet` VALUES ('74', '2', '401110', null, '1', '18.00', '36.88', '0.000');
INSERT INTO `cc_diariodet` VALUES ('75', '3', '121200', null, '0', '100.00', '36.88', '0.000');
INSERT INTO `cc_diariodet` VALUES ('76', '3', '121200', null, '0', '100.00', '36.88', '0.000');
INSERT INTO `cc_diariodet` VALUES ('82', '3', '121200', null, '0', '100.00', '31.25', '0.000');
INSERT INTO `cc_diariodet` VALUES ('83', '3', '121200', null, '0', '100.00', '31.25', '0.000');
INSERT INTO `cc_diariodet` VALUES ('84', '3', '121200', null, '0', '100.00', '31.25', '0.000');
INSERT INTO `cc_diariodet` VALUES ('87', '3', '121200', null, '0', '100.00', '31.25', '0.000');
