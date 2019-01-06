/*
 Navicat Premium Data Transfer

 Source Server         : ubuntu16.04
 Source Server Type    : MySQL
 Source Server Version : 50724
 Source Host           : 192.168.1.130:3306
 Source Schema         : ssms

 Target Server Type    : MySQL
 Target Server Version : 50724
 File Encoding         : 65001

 Date: 01/01/2019 00:39:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for schools
-- ----------------------------
DROP TABLE IF EXISTS `schools`;
CREATE TABLE `schools`  (
  `school_num` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `school_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`school_num`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of schools
-- ----------------------------
INSERT INTO `schools` VALUES ('sc001', '数学与信息学院');
INSERT INTO `schools` VALUES ('sc002', '音乐学院');
INSERT INTO `schools` VALUES ('sc003', 'it');

-- ----------------------------
-- Table structure for scores
-- ----------------------------
DROP TABLE IF EXISTS `scores`;
CREATE TABLE `scores`  (
  `stu_num` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `course` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `score` double(100, 3) NULL DEFAULT NULL,
  `score_des` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`stu_num`, `course`) USING BTREE,
  CONSTRAINT `scores_ibfk_1` FOREIGN KEY (`stu_num`) REFERENCES `students` (`stu_num`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scores
-- ----------------------------
INSERT INTO `scores` VALUES ('s001', 'c++', 77.000, 'B');
INSERT INTO `scores` VALUES ('s001', 'java', 100.000, 'A');
INSERT INTO `scores` VALUES ('s001', 'jsp', 98.000, 'A');
INSERT INTO `scores` VALUES ('s001', 'linux', 99.000, 'A');
INSERT INTO `scores` VALUES ('s002', 'c++', 88.000, 'B');
INSERT INTO `scores` VALUES ('s002', 'java', 66.000, 'B');
INSERT INTO `scores` VALUES ('s002', 'jsp', 78.000, 'B');
INSERT INTO `scores` VALUES ('s002', 'linux', 56.000, 'C');
INSERT INTO `scores` VALUES ('s003', 'c++', 85.000, 'B');
INSERT INTO `scores` VALUES ('s003', 'java', 77.000, 'C');
INSERT INTO `scores` VALUES ('s003', 'jsp', 67.000, 'C');
INSERT INTO `scores` VALUES ('s003', 'linux', 97.000, 'A');

-- ----------------------------
-- Table structure for students
-- ----------------------------
DROP TABLE IF EXISTS `students`;
CREATE TABLE `students`  (
  `stu_num` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `stu_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `school_num` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `stu_des` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`stu_num`) USING BTREE,
  INDEX `school_num`(`school_num`) USING BTREE,
  CONSTRAINT `students_ibfk_1` FOREIGN KEY (`school_num`) REFERENCES `schools` (`school_num`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of students
-- ----------------------------
INSERT INTO `students` VALUES ('s001', '张三', 'sc001', 'no');
INSERT INTO `students` VALUES ('s002', '李四', 'sc001', 'ok');
INSERT INTO `students` VALUES ('s003', '王五', 'sc001', 'ok');
INSERT INTO `students` VALUES ('s004', '朝阳', 'sc002', 'ok');
INSERT INTO `students` VALUES ('s006', '王大', 'sc001', 'ok');
INSERT INTO `students` VALUES ('s007', '熊二', 'sc001', 'ok');
INSERT INTO `students` VALUES ('s008', '熊大', 'sc001', 'ok');
INSERT INTO `students` VALUES ('s009', '赵六', 'sc001', 'ok');
INSERT INTO `students` VALUES ('s011', '王小', 'sc001', 'ok');
INSERT INTO `students` VALUES ('s990', 'oooo', 'sc001', 'mo');

SET FOREIGN_KEY_CHECKS = 1;
