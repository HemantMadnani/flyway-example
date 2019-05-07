/* Apexx Portal DDLs */


CREATE TABLE `app_config` (
  `app_config_id` varchar(250) NOT NULL,
  `code` varchar(50) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY (`app_config_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user` (
  `user_id` varchar(250) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(250) NOT NULL,
  `password` varchar(100) NOT NULL,
  `credential_expiry_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `login_attempt` int(10) DEFAULT '0',
  `account_lock` tinyint(1) DEFAULT NULL,
  `phone` varchar(35) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(250) DEFAULT NULL,
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(250) DEFAULT NULL,
  `organisation_id` varchar(250) DEFAULT NULL,
  `parent_user_id` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) engine=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `role` (
  `role_id` varchar(250) NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `description` varchar(250) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(250) DEFAULT NULL,
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`role_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `authority` (
  `authority_id` varchar(250) NOT NULL,
  `authority_name` varchar(100) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(250) DEFAULT NULL,
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`authority_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_role` (
  `user_role_id` varchar(250) NOT NULL,
  `role_id` varchar(250) DEFAULT NULL,
  `user_id` varchar(250) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`user_role_id`),
  KEY `role_id` (`role_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `role_authority` (
  `role_authority_id` varchar(250) NOT NULL,
  `role_id` varchar(250) DEFAULT NULL,
  `authority_id` varchar(250) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`role_authority_id`),
  KEY `role_authority_authority_fk` (`authority_id`),
  KEY `role_authority_role_fk` (`role_id`),
  CONSTRAINT `role_authority_authority_fk` FOREIGN KEY (`authority_id`) REFERENCES `authority` (`authority_id`),
  CONSTRAINT `role_authority_role_fk` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`)
) engine=InnoDB default CHARSET=utf8;

CREATE TABLE `error_log` (
  `error_id` varchar(250) NOT NULL,
  `error_message` varchar(250) NOT NULL,
  `error_type` varchar(100) NOT NULL,
  `error_level` varchar(100) NOT NULL,
  `error_code` int(10) NOT NULL,
  `class_name` varchar(150) DEFAULT NULL,
  `method_name` varchar(150) DEFAULT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`error_id`),
  KEY `error_log_user_fk` (`user_id`),
  CONSTRAINT `error_log_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `activity_log` (
  `activity_id` varchar(250) NOT NULL,
  `module` varchar(50) DEFAULT NULL,
  `activity_type` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `activity_data` longtext,
  `error_id` varchar(250) DEFAULT NULL,
  `user_id` varchar(250) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`activity_id`),
  KEY `activity_log_error_log_fk` (`error_id`),
  KEY `activity_log_user_fk` (`user_id`),
  KEY `activity_log_user_fk_email` (`email`),
  CONSTRAINT `activity_log_error_log_fk` FOREIGN KEY (`error_id`) REFERENCES `error_log` (`error_id`),
  CONSTRAINT `activity_log_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `activity_log_user_fk_email` FOREIGN KEY (`email`) REFERENCES `user` (`email`)
) engine=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `action_log` (
  `request_id` varchar(250) NOT NULL,
  `original_transaction_id` varchar(250) NOT NULL,
  `apx_transaction_id` varchar(250) NOT NULL,
  `organisation_id` varchar(250) NOT NULL,
  `account_id` varchar(250) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `error_id` varchar(250) DEFAULT NULL,
  `request_type` varchar(50) DEFAULT NULL,
  `request_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `request_data` longtext,
  `response_data` longtext,
  `response_datetime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_id` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `action_log_error_log_fk` (`error_id`),
  CONSTRAINT `action_log_error_log_fk` FOREIGN KEY (`error_id`) REFERENCES `error_log` (`error_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `password_log` (
  `password_id` varchar(250) NOT NULL,
  `user_id` varchar(250) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `error_id` varchar(250) DEFAULT NULL,
  `modified_by` varchar(250) DEFAULT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `initiator_id` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`password_id`),
  KEY `password_log_user_fk` (`user_id`),
  KEY `password_log_error_log_fk` (`error_id`),
  KEY `password_log_user_fk_modified_by` (`modified_by`),
  KEY `password_log_user_fk_initiator_id` (`initiator_id`),
  CONSTRAINT `password_log_error_log_fk` FOREIGN KEY (`error_id`) REFERENCES `error_log` (`error_id`),
  CONSTRAINT `password_log_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `password_log_user_fk_initiator_id` FOREIGN KEY (`initiator_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `password_log_user_fk_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `user` (`user_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `password_reset_log` (
  `password_reset_id` varchar(250) NOT NULL,
  `email_link` varchar(250) DEFAULT NULL,
  `expiry_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` varchar(250) DEFAULT NULL,
  `token` varchar(250) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `error_id` varchar(250) DEFAULT NULL,
  `reset_datetime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` tinyint(1) DEFAULT NULL,
  `initiator_id` varchar(250) DEFAULT NULL,
  `initiator_datetime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`password_reset_id`),
  KEY `password_reset_log_user_fk` (`user_id`),
  KEY `password_reset_log_error_log_fk` (`error_id`),
  KEY `password_reset_log_user_fk_initiator_id` (`initiator_id`),
  CONSTRAINT `password_reset_log_error_log_fk` FOREIGN KEY (`error_id`) REFERENCES `error_log` (`error_id`),
  CONSTRAINT `password_reset_log_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `password_reset_log_user_fk_initiator_id` FOREIGN KEY (`initiator_id`) REFERENCES `user` (`user_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `question_config` (
  `question_id` varchar(250) NOT NULL,
  `question_title` varchar(500) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `inactive_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(250) DEFAULT NULL,
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  KEY `question_config_user_fk_created_by` (`created_by`),
  KEY `question_config_user_fk_modified_by` (`modified_by`),
  CONSTRAINT `question_config_user_fk_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`),
  CONSTRAINT `question_config_user_fk_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `user` (`user_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `question_answer_config` (
  `question_answer_id` varchar(250) NOT NULL,
  `question_id` varchar(250) DEFAULT NULL,
  `answer` varchar(250) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `inactive_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_id` varchar(250) DEFAULT NULL,
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`question_answer_id`),
  KEY `question_answer_config_question_config_fk` (`question_id`),
  KEY `question_answer_config_user_fk` (`user_id`),
  CONSTRAINT `question_answer_config_question_config_fk` FOREIGN KEY (`question_id`) REFERENCES `question_config` (`question_id`),
  CONSTRAINT `question_answer_config_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) engine=InnoDB DEFAULT CHARSET=utf8;







